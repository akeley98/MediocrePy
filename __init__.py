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

"""An aggressively average SIMD python module

A combine library for averaging 1D and 2D numpy arrays together (with
optional masks for median filtering). Combine algorithms include the mean,
median, sigma-clipped mean, clipped median, and the mysterious scaled mean.
Most of the library is implemented in vectorized (AVX) C code for high 
performance. (This module is a wrapper for that C library, mediocre.so).

First, an example to whet your appetite:

>>> import numpy as np
>>> import MediocrePy
>>> 
>>> # 12 example arrays (with outliers) for combining.
>>> a = np.array([175, 170, 183, 138, 140, 128])
>>> b = np.array([115, 171, 101, 157, 145, 116])
>>> c = np.array([113, 170, 180, 100, 150, 176])
>>> d = np.array([157, 171, 162, 198, 155, 112])
>>> e = np.array([119, 171, 145, 125, 160, 188])
>>> f = np.array([155, 170, 182, 130,  90, 145])
>>> g = np.array([182, 999, 100, 128, 165, 109])
>>> h = np.array([121, 172, 144, 158, 170, 128])
>>> i = np.array([122, 171, 175, 180, 175, 199])
>>> j = np.array([120, 170, 121, 158, 180, 188])
>>> k = np.array([178, 171, 174, 115, 185, 127])
>>> l = np.array([121, 170, 166, 177, 190, 116])
>>> 
>>> # We'll combine arrays using the clipped mean algorithm today.
>>> # Clipping removes outliers before averaging the remaining entries.
>>> n = MediocrePy.clipped_mean((a, b, c, d, e, f, g, h, i, j, k, l))
>>> print "%.2f %.2f %.2f %.2f %.2f %.2f" % tuple(n)
139.83 170.64 152.75 147.00 158.75 144.33
>>> #     ^                    ^
>>> # Outlier 999 is rejected, ^
>>> # but outlier 90 is accepted and affected the mean.
>>>
>>> print MediocrePy.clipped_mean
<MediocrePy.Functor object at 0x7fe638478910>
>>> # clipped_mean is a function-like object MediocrePy.Functor. We can
>>> # create our own -- let's set a stricter limit for outliers (2 SD).
>>> stricter_mean = MediocrePy.ClippedMean(sigma=2.0)
>>> 
>>> n = stricter_mean((a, b, c, d, e, f, g, h, i, j, k, l))
>>> print "%.2f %.2f %.2f %.2f %.2f %.2f" % tuple(n)
139.83 170.50 152.75 147.00 165.00 144.33
>>> #     ^                    ^
>>> # With stricter bounds, both 999 and 90 were clipped out as outliers.

Now that you might have some idea of how the library works, the Functor
docstrings and the other combine functions (clipped_median, mean, median,
and scaled_mean) provide good places to learn more about the library.
"""

from . import _c
from . import _docs
from _c import Dimension, CombineError, FunctorFactoryError
struct_mediocre_functor = _c.FunctorBlob

import numpy as _np
import os

class Functor(object):
    """A callable object that can combine arrays of (possibly masked) data
    
    Behind the scenes, this object behaves as a RAII object that manages a
    MediocreFunctor structure (the C object that underlies the implemen-
    tation of a combine algorithm), calling the MediocreFunctor's destructor
    function when the object gets deleted (or dispose is called).

    Users should not create this object themselves. Rather, they should
    receive this object from a factory function created with
    make_functor_factory, or from one of the many Functor factory functions
    supplied by default by this library (e.g. ClippedMedian).
    """
    __slots__ = ["_struct"]
    
    def __init__(self, blob=None):
        """Users should not be constructing Functor objects manually.
        
        Constructor used by factory function made by make_functor_factory.
        
        Constructs an object that manages a struct_mediocre_functor.
        There should never be two Functor objects managing the same
        functor structure, otherwise the C MediocreFunctor struct will
        eventually have its destructor called twice.
        
        Checks whether the MediocreFunctor is good before managing it. If
        not, destroy the bad Functor (nonzero_error != 0) and
        throw an exception.
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
        """Functor is truthy if it's managing an actual functor object,
        and can be used for combining; false if it's not."""
        return self._struct is not None
    
    def __call__(
        self, arrays, masks=None, nonzero_means_bad=True, thread_count=7
    ):
        """Run this combine algorithm on a sequence of input arrays.
        
        arrays: a sequence (e.g. list) of 1D or 2D numpy arrays. The arrays
        must all have the same shape, must have a primitive data type
        (8-64 bit unsigned/int, 32/64 bit float), and can have unusual
        strides but otherwise should not be 'weird' (e.g. misaligned data)
         (I forbid weirdness as a CYA for power users. If this doesn't mean
          anything to you, you probably don't have to worry about this)
        
        There needs to be at least one numpy array in the arrays argument.
        
        masks: an optional sequence of 2D arrays. If supplied, masking is
        enabled for this combine operation. The same requirements for the
        data arrays apply to the mask arrays, including the requirement
        that the masks have the same shape as the data arrays.
        
        If supplied, there must be one mask for each array in arrays.
        
        nonzero_means_bad: If truthy, a nonzero value in a mask array
        indicates a value in the corresponding data array to be masked out.
        If falsey, the opposite is true.
        
        thread_count: a reasonable integer not less than one.
        
        return value: a 1 or 2 dimensional numpy array of float32 holding
        the result of combining the [masked] input arrays.
        
        Masking:
        
        If masking is enabled, each 2D array arrays[I] is masked by the
        2D array masks[I]. arrays[I] [x,y] is considered a 'bad' value
        if and only if masks[I] [x,y] holds a value that indicates a bad
        value (a truthy number if nonzero_means_bad, falsey otherwise)
        
        Each bad value gets replaced before it's used as part of the combine
        (replaced in a local copy, not in the original array, which is not
        modified by the combine function). A bad value within an input
        array is replaced by the median of all values (that are themselves
        not indicated as bad by the mask) within a 5x5 box around the bad
        value being replaced. Edges and corners don't get extra weight.
        """
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
        
        # All of this below is just to construct the wrapped MediocreInput
        # instance input_obj.
        if masks is None:
            # Build an array of Mediocre2D structs that point to data in the
            # numpy arrays. The constructor for Mediocre2D in _c.py does
            # most of this work for us. Check that they all have the same
            # shape as we do this.
            mediocre_array = (_c.Mediocre2D * combine_count)()
            for i, arr in enumerate(arrays):
                mediocre_array[i] = _c.Mediocre2D(arr)
                if arr.shape != expected_shape:
                    raise IndexError("All arrays must have the same shape.")
            
            assert all(m2d.data for m2d in mediocre_array), "NULL POINTER!!!"
            
            first_dtype = arrays[0].dtype
            
            # Check if 1D homogeneous input is okay. We can treat 2D arrays as
            # if they were 1D arrays if they are C contiguous. Otherwise,
            # we stick with the Mediocre2D input functions.
            #
            # Note: A potential optimization for Fortran arrays: if all input
            # arrays are Fortran-Contiguous arrays of the same data type, we
            # can use the fast homogeneous input functions as long as the
            # output numpy array is in Fortran rather than C order, as it is
            # now. I feel like implementing this but I sure as hell don't feel
            # like testing it today, so I'll just leave this note for now.
            can_use_1d_input = all(
                arr.dtype == first_dtype and arr.flags["C_CONTIGUOUS"]
                for arr in arrays
            )
            if not can_use_1d_input:
                input_obj = _c.mediocre_2D_input(mediocre_array, combine_count)
            else:
                # Use faster 1D homogeneous input functions if able.
                # Lookup the input_factory for the input arrays' data type
                # and use it to construct a (wrapped) MediocreInput instance.
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
            if len(expected_shape) != 2:
                raise TypeError("Masking can only be done for 2D arrays")
            try:
                if len(masks) != combine_count:
                    raise IndexError("Need %i masks for %i arrays, have %i" %
                        (combine_count, combine_count, len(masks)))
            except Exception as e:
                raise TypeError("masks must be a sequence type.\n"
                "(masks had no len because of %r)" % e)
            
            # Construct an array of MediocreMasked2D structures and then
            # use the MediocreMasked2D input type as the input_obj.
            mediocre_masked_array = (_c.Masked2D * combine_count)()
            for i in xrange(combine_count):
                arr = arrays[i]
                mask = masks[i]
                if arr.shape != expected_shape:
                    raise IndexError("All arrays must have the same shape.")
                if mask.shape != expected_shape:
                    raise IndexError("Mask must have same shape as data array.")
                mediocre_masked_array[i].data_2D = _c.Mediocre2D(arr)
                mediocre_masked_array[i].mask_2D = _c.Mediocre2D(mask)
            
            nonzero_means_bad = bool(nonzero_means_bad)
            input_obj = _c.masked_2D_input(
                mediocre_masked_array, combine_count, nonzero_means_bad
            )
        
        # Now that we have the MediocreInput-manager object input_obj,
        # allocate the output floats and call the C combine function.
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
    """Function for wrapping a C MediocreFunctor factory function as a
Python-programmer-friendly Functor object factory function.
    
    c_function: a ctypes function created by loading a C function that
    returns a MediocreFunctor structure by-value, as the default
    MediocreFunctor factories in the mediocre library do.
    
    The ctypes function must have its restype (=struct_mediocre_functor)
    and argtypes attributes set.
    
    doc: a docstring for the returned factory function.
    
    no_argtypes: Force this argument to true to override the requirement
    to set c_function's argtypes attribute. You still have to set the
    restype attribute no matter what.
    
    return value: a Python function that takes arguments that are
    passed to the C factory function and returns a Functor object that
    wraps the kind of MediocreFunctor instance made by the C factory.
    """
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

ClippedMean2 = make_functor_factory(_c._clipped_mean_functor2, _docs.cmean2)

def ClippedMean(sigma=3.0, max_iter=8):
    return ClippedMean2(sigma, sigma, max_iter)
ClippedMean.__doc__ = _docs.cmean

clipped_mean = ClippedMean()

median = Functor(_c._median_functor())

ClippedMedian2 = make_functor_factory(_c._clipped_median_functor2, _docs.cmedi2)

def ClippedMedian(sigma=3.0, max_iter=8):
    return ClippedMedian2(sigma, sigma, max_iter)
ClippedMedian.__doc__ = _docs.cmedi

clipped_median = ClippedMedian()

def scaled_mean(
    scale_factors, arrays, masks=None, nonzero_means_bad=True, thread_count=7,
    sigma=3.0, sigma_lower=None, sigma_upper=None, max_iter=8
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
    
    return functor(arrays, masks, nonzero_means_bad, thread_count)
scaled_mean.__doc__ = _docs.smean

