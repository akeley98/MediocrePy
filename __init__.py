# An aggresively average SIMD python module
# Copyright (C) 2017 David Akeley
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

from . import _c
Dimension = _c.Dimension
struct_mediocre_functor = _c.FunctorBlob

import numpy as _np
import os

class CombineError(Exception):
    """Error thrown to report any error codes returned when combining data.
    """
    def __init__(self, _errno, message=None):
        self.errno = _errno
        self.message = os.strerror(_errno) if message is None else message
    
    def __repr__(self):
        return "CombineError(%i, %r)" % (self.errno, self.message)

class FunctorFactoryError(Exception):
    """Error thrown to indicate failure to construct a Functor.
    """
    def __init__(self, _errno, message=None):
        self.errno = _errno
        self.message = os.strerror(_errno) if message is None else message
    
    def __repr__(self):
        return "BadFunctor(%i, %r)" % (self.errno, self.message)

class Functor(object):
    """RAII object that manages a MediocreFunctor struct, calling its destructor
    when the object gets deleted (or dispose is called).

    Users should not create this object themselves. Rather, they should receive
    this object from a factory function created with make_functor_factory.
    """
    __slots__ = ["_struct"]
    
    def __init__(self, blob=None):
        """Users should not be constructing Functor objects manually.
        Construct an object that manages a struct_mediocre_functor.
        There should never be two Functor objects managing the same
        functor structure, otherwise the C MediocreFunctor struct will
        eventually have its destructor called twice.
        
        Checks whether the MediocreFunctor is good before managing it. If not,
        destroy the bad Functor (nonzero_error != 0) and throw an exception.
        """
        if blob is None:
            self._struct = None
        elif type(blob) is struct_mediocre_functor:
            self._struct = blob
            if blob.nonzero_error != 0:
                blob.destructor(blob.user_data)
                self._struct = None
                raise FunctorFactoryError(blob.nonzero_error)
        else:
            raise TypeError("Can only manage MediocreFunctor structs.")
    
    def __del__(self):
        self.dispose()
    
    def dispose(self):
        if self._struct is not None:
            self._struct.destructor(self._struct.user_data)
            self._struct = None
    
    def __nonzero__(self):
        """Functor is truthy if it's managing an actual functor object, and can
        be used for combining; false if it's not."""
        return self._struct is not None
    
    # Only for 1D and 2D numpy arrays for now. XXX to document.
    def __call__(
        self, arrays, masks=None, nonzero_means_bad=True, thread_count=7
    ):
        if type(self._struct) is not _c.FunctorBlob:
            if self._struct is None:
                raise Exception("Functor not initialized.")
            else:
                raise AssertionError("Functor._struct has unexpected type.")
        
        try:
            if len(arrays) == 0:
                raise ValueError("Must have at least one array to combine")
        except Exception as e:
            raise TypeError("arrays must be a sequence type.\n"
                "(arrays had no len because of %r)" % e)
        
        expected_shape = arrays[0].shape
        combine_count = len(arrays)
        
        if masks is None:
            mediocre_array = (_c.Mediocre2D * combine_count)()
            for i, arr in enumerate(arrays):
                mediocre_array[i] = _c.Mediocre2D(arr)
                if arr.shape != expected_shape:
                    raise TypeError("All arrays must have the same shape.")
            
            assert all(m2d.data for m2d in mediocre_array), "NULL POINTER!!!"
            
            first_dtype = arrays[0].dtype
            
            # Check if 1D homogeneous input is okay. We can treat 2D arrays as
            # if they were 1D arrays if they are C contiguous.
            can_use_1d_input = all(
                arr.dtype == first_dtype and arr.flags["C_CONTIGUOUS"]
                for arr in arrays
            )
            if not can_use_1d_input:
                input_obj = _c.mediocre_2D_input(mediocre_array, combine_count)
            else:
                # Use faster 1D homogeneous input functions if able.
                unused, input_factory, ptr_t = _c.np_type_dict[first_dtype.name]
                pointer_array = (ptr_t * combine_count)()
                for i, arr in enumerate(arrays):
                    pointer_array[i] = arr.ctypes.data_as(ptr_t)
                
                width = expected_shape[0]
                if len(expected_shape) == 2:
                    width *= expected_shape[1]
                
                dim = Dimension(combine_count, width)
                input_obj = input_factory(pointer_array, dim)
                
        else:       # We have masks
            try:
                if len(masks) != combine_count:
                    raise ValueError("Need %i masks for %i arrays, have %i" %
                        (combine_count, combine_count, len(masks)))
            except Exception as e:
                raise TypeError("masks must be a sequence type.\n"
                "(masks had no len because of %r)" % e)
            
            mediocre_masked_array = (_c.Masked2D * combine_count)()
            for i in xrange(combine_count):
                arr = arrays[i]
                mask = masks[i]
                if arr.shape != expected_shape:
                    raise TypeError("All arrays must have the same shape.")
                if mask.shape != expected_shape:
                    raise TypeError("Mask must have same shape as data array.")
                mediocre_masked_array[i].data_2D = _c.Mediocre2D(arr)
                mediocre_masked_array[i].mask_2D = _c.Mediocre2D(mask)
            
            nonzero_means_bad = bool(nonzero_means_bad)
            input_obj = _c.masked_2D_input(
                mediocre_masked_array, combine_count, nonzero_means_bad
            )
        
        output = _np.empty(shape=expected_shape, dtype=_np.float32)
        
        status = _c.combine(
            output.ctypes.data_as(_c.float_ptr),
            input_obj._struct,
            self._struct,
            thread_count
        )
        
        if status != 0:
            raise CombineError(status)
        
        return output
 

def make_functor_factory(c_function, doc=None, no_argtypes=False):
    if c_function.restype is not struct_mediocre_functor:
        raise TypeError("C function must have restype=struct_mediocre_functor")
    if c_function.argtypes is None and not no_argtypes:
        raise TypeError("Must set argtypes of C function")
    
    def functor_factory(*args):
        structure = c_function(*args)
        return Functor(structure)
    
    functor_factory.__doc__ = doc
    return functor_factory


mean = Functor(_c._mean_functor())

ClippedMean2 = make_functor_factory(_c._clipped_mean_functor2)

def ClippedMean(sigma, max_iter):
    return ClippedMean2(sigma, sigma, max_iter)

clipped_mean = ClippedMean(3.0, 8)

median = Functor(_c._median_functor())

ClippedMedian2 = make_functor_factory(_c._clipped_median_functor2)

def ClippedMedian(sigma, max_iter):
    return ClippedMedian2(sigma, sigma, max_iter)

clipped_median = ClippedMedian(3.0, 8)

def scaled_mean(
    scale_factors, arrays, masks=None, nonzero_means_bad=True, thread_count=7,
    sigma=3.0, sigma_upper=None, sigma_lower=None, max_iter=8
):
    scale_factors = _np.array(scale_factors, _np.float32)
    if len(scale_factors) != len(arrays):
        raise TypeError("Need exactly as many scale_factors as arrays")
    
    if sigma_upper is None: sigma_upper = sigma
    if sigma_lower is None: sigma_lower = sigma
    
    functor = Functor(_c._scaled_mean_functor2(
        scale_factors.ctypes.data_as(_c.float_ptr),
        len(scale_factors),
        sigma_lower,
        sigma_upper,
        max_iter
    ))
    
    return functor.combine(arrays, masks, nonzero_means_bad, thread_count)
        

