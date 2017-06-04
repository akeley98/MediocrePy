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

"""File full of Python things that are needed for the mediocre library's
Python interface, but should not be used by users. We're mainly repeating struct
and function definitions here using ctypes, and we'd prefer to have users work
with the high level interface implemented in __init__.py

Actually, we're not just repeating definitions, we're also adding wrappers
that take Structures from the C functions and package them in higher-level,
resource safe objects so that the code in __init__.py never has a `raw` structure that could leak resources if an exception is thrown.
"""

import os
from ctypes import CFUNCTYPE, POINTER, Structure, byref, cdll, c_size_t, c_int, c_void_p, c_int8, c_int16, c_int32, c_int64, c_uint8, c_uint16, c_uint32, c_uint64, c_float, c_double

import numpy as np

float_ptr = POINTER(c_float)

try:
    lib = cdll.LoadLibrary(
        os.path.join(os.path.split(__file__)[0], "bin/mediocre.so")
    )
except Exception as err:
    raise ImportError(
        "Failed to load C library. Did you remember to build it?\ncause:%r"
        % err
    )

# Actually these 2 errors classes are fine for use by users. I just moved
# them here because I'm fed up with them spamming up the docstrings.
class CombineError(Exception):
    """Error thrown to report any error codes returned when combining data.
    """
    def __init__(self, _errno, message=None):
        super(CombineError, self).__init__(
            os.strerror(_errno) if message is None else message
        )
        self.errno = _errno
    
    def __repr__(self):
        return "CombineError(%i, %r)" % (self.errno, self.message)

class FunctorFactoryError(Exception):
    """Error thrown to indicate failure to construct a Functor.
    """
    def __init__(self, _errno, message=None):
        super(FunctorFactoryError, self).__init__(
            os.strerror(_errno) if message is None else message
        )
        self.errno = _errno
        
    def __repr__(self):
       return "FunctorFactoryError(%i, %r)" % (self.errno, self.message)

class Dimension(Structure):
    """MediocreDimension structure (combine_count, width)"""
    _fields_ = [("combine_count", c_size_t), ("width", c_size_t)]
    
    def __repr__(self):
        return "Dimension(%r, %r)" % (self.combine_count, self.width)

loop_function_type = CFUNCTYPE(c_int, c_void_p, c_void_p, Dimension)
destructor_type = CFUNCTYPE(None, c_void_p)

class InputBlob(Structure):
    """Class representing raw data of MediocreInput structure.

    Doesn't come with a destructor. It's called a 'blob' because it's just that:
    a pile of binary data that has no behavior built in. MediocrePy users should
    not use this class, and it should be hidden from them.
    """
    _fields_ = [
        ("loop_function", loop_function_type),
        ("destructor", destructor_type),
        ("user_data", c_void_p),
        ("dimension", Dimension),
        ("nonzero_error", c_int)
    ]
    
    def __init__(self, *args):
        # Should not be instantiated by us, only by C functions.
        raise Exception("Cannot create InputBlob from Python code")

class FunctorBlob(Structure):
    """Class representing raw data of MediocreFunctor structure.

    Doesn't come with a destructor. It's called a 'blob' because it's just that:
    a pile of binary data that has no behavior built in. MediocrePy users should
    not use this class, except specifying it as the return type of C functions.
    """
    _fields_ = [
        ("loop_function", loop_function_type),
        ("destructor", destructor_type),
        ("user_data", c_void_p),
        ("nonzero_error", c_int),
    ]
    
    def __init__(self, *args):
        # Should not be instantiated by us, only by C functions.
        raise Exception("Cannot create FunctorBlob from Python code")


class Input(object):
    """RAII object that manages a MediocreInput struct, calling its destructor
    when the object gets deleted (or dispose is called).

    This could be made user-visible one day like the Functor structure, but for
    now I don't feel like adding yet another thing to the Python interface. Call
    me if you think you need this functionality.
    """
    __slots__ = ["_struct"]
    
    def __init__(self, blob=None):
        """Construct an object that manages an InputBlob (MediocreInput).
        There should never be two Input objects managing the same InputBlob,
        otherwise it will eventually have its destructor called twice.
        
        Checks whether the MediocreInput is good before managing it. If not,
        destroy the bad structure (nonzero_error != 0) and throw an exception.
        """
        if blob is None:
            self._struct = None
        elif type(blob) is InputBlob:
            self._struct = blob
            if blob.nonzero_error != 0:
                blob.destructor(blob.user_data)
                self._struct = None
                raise Exception(os.strerror(blob.nonzero_error))
        else:
            raise TypeError("Can only manage MediocreInput structs.")
    
    def __del__(self):
        self.dispose()
    
    def dispose(self):
        if self._struct is not None:
            self._struct.destructor(self._struct.user_data)
            self._struct = None
    
    def __nonzero__(self):
        """We're truthy if we are managing a MediocreInput falsey if not."""
        return self._struct is not None


class Mediocre2D(Structure):
    """Class representing Mediocre2D structure of the mediocre library.

    Like the Mediocre2D type in the C library, this object doesn't take
    ownership of anything it points to. It just holds a pointer to somewhere,
    and depends on others not to delete that pointer from under its feet.
    """
    _fields_ = [
        ("data", c_void_p),
        ("type_code", c_size_t),        # Actually uintptr_t.
        ("major_width", c_size_t),
        ("major_stride", c_size_t),
        ("minor_width", c_size_t),
        ("minor_stride", c_size_t),
    ]
    
    def __init__(self, arr):
        """Wrap 1 or 2 dimensional numpy array as Mediocre2D structure.
        The numpy array must have an 8/16/32/64 bit signed/unsigned integer
        data type, or 32/64 bit floating point data type. Mediocre2D works okay
        with arrays with unusual strides, but the array should otherwise not be
        weird (bad alignment, incorrect endianness, etc.) Remember that this
        object DOESN'T keep the numpy array alive.
        """
        if type(arr) is not np.ndarray:
            raise TypeError("Can only work with exact numpy ndarray instances.")
        
        try:
            type_code, ignored, ignored2 = np_type_dict[arr.dtype.name]
        except KeyError:
            raise TypeError("Unknown numpy array dtype %r" % (arr.dtype.name,))
        
        shape = arr.shape
        strides = arr.strides
        
        self.data = arr.ctypes.data_as(c_void_p)
        self.type_code = type_code
        
        if len(shape) == 1:
            self.major_width = 1
            self.major_stride = shape[0] * strides[0]
            self.minor_width = shape[0]
            self.minor_stride = strides[0]
        elif len(shape) == 2:
            self.major_width = shape[0]
            self.major_stride = strides[0]
            self.minor_width = shape[1]
            self.minor_stride = strides[1]
        else:
            raise TypeError("Array must be 1D or 2D. shape=%r" % (arr.shape,))


class Masked2D(Structure):
    """Corresponds to MediocreMasked2D structure.

    Remember that this object doesn't bla bla bla dangling pointers be careful.
    """
    _fields_ = [
        ("data_2D", Mediocre2D),
        ("mask_2D", Mediocre2D),
    ]

# Declare the all-important mediocre_combine function. (Just `combine` here).
combine = lib.mediocre_combine
combine.restype = c_int
combine.argtypes = (float_ptr, InputBlob, FunctorBlob, c_int)

# Declare the default combine functor factories.
_mean_functor = lib.mediocre_mean_functor
_mean_functor.restype = FunctorBlob
_mean_functor.argtypes = ()

_clipped_mean_functor2 = lib.mediocre_clipped_mean_functor2
_clipped_mean_functor2.restype = FunctorBlob
_clipped_mean_functor2.argtypes = (c_double, c_double, c_size_t)

_scaled_mean_functor2 = lib.mediocre_scaled_mean_functor2
_scaled_mean_functor2.restype = FunctorBlob
_scaled_mean_functor2.argtypes = (
    float_ptr, c_size_t, c_double, c_double, c_size_t
)
_median_functor = lib.mediocre_median_functor
_median_functor.restype = FunctorBlob
_median_functor.argtypes = ()

_clipped_median_functor2 = lib.mediocre_clipped_median_functor2
_clipped_median_functor2.restype = FunctorBlob
_clipped_median_functor2.argtypes = (c_double, c_double, c_size_t)

# Declare a bunch of MediocreInput factories for 1D homogeneous data.(English!!)
# Also make lambdas that return that MediocreInput wrapped in an Input object.
ptr2ptr = lambda c_type: POINTER(POINTER(c_type))

_i8_input = lib.mediocre_i8_input
_i8_input.restype = InputBlob
_i8_input.argtypes = (ptr2ptr(c_int8), Dimension)
i8_input = lambda ptrs, dim: Input(_i8_input(ptrs, dim))

_i16_input = lib.mediocre_i16_input
_i16_input.restype = InputBlob
_i16_input.argtypes = (ptr2ptr(c_int16), Dimension)
i16_input = lambda ptrs, dim: Input(_i16_input(ptrs, dim))

_i32_input = lib.mediocre_i32_input
_i32_input.restype = InputBlob
_i32_input.argtypes = (ptr2ptr(c_int32), Dimension)
i32_input = lambda ptrs, dim: Input(_i32_input(ptrs, dim))

_i64_input = lib.mediocre_i64_input
_i64_input.restype = InputBlob
_i64_input.argtypes = (ptr2ptr(c_int64), Dimension)
i64_input = lambda ptrs, dim: Input(_i64_input(ptrs, dim))

_u8_input = lib.mediocre_u8_input
_u8_input.restype = InputBlob
_u8_input.argtypes = (ptr2ptr(c_uint8), Dimension)
u8_input = lambda ptrs, dim: Input(_u8_input(ptrs, dim))

_u16_input = lib.mediocre_u16_input
_u16_input.restype = InputBlob
_u16_input.argtypes = (ptr2ptr(c_uint16), Dimension)
u16_input = lambda ptrs, dim: Input(_u16_input(ptrs, dim))

_u32_input = lib.mediocre_u32_input
_u32_input.restype = InputBlob
_u32_input.argtypes = (ptr2ptr(c_uint32), Dimension)
u32_input = lambda ptrs, dim: Input(_u32_input(ptrs, dim))

_u64_input = lib.mediocre_u64_input
_u64_input.restype = InputBlob
_u64_input.argtypes = (ptr2ptr(c_uint64), Dimension)
u64_input = lambda ptrs, dim: Input(_u64_input(ptrs, dim))

_float_input = lib.mediocre_float_input
_float_input.restype = InputBlob
_float_input.argtypes = (ptr2ptr(c_float), Dimension)
float_input = lambda ptrs, dim: Input(_float_input(ptrs, dim))

_double_input = lib.mediocre_double_input
_double_input.restype = InputBlob
_double_input.argtypes = (ptr2ptr(c_double), Dimension)
double_input = lambda ptrs, dim: Input(_double_input(ptrs, dim))

# Declare the MediocreInput factories for 2D input (masked & unmasked).
# Same as before, we also include lambdas returning Input objects.
_masked_2D_input = lib.mediocre_masked_2D_input
_masked_2D_input.restype = InputBlob
_masked_2D_input.argtypes = (POINTER(Masked2D), c_size_t, c_int)
masked_2D_input = lambda ptr, ct, nz: Input(_masked_2D_input(ptr, ct, nz))

_mediocre_2D_input = lib.mediocre_2D_input
_mediocre_2D_input.restype = InputBlob
_mediocre_2D_input.argtypes = (POINTER(Mediocre2D), c_size_t)
mediocre_2D_input = lambda ptr, count: Input(_mediocre_2D_input(ptr, count))

# Dictionary mapping numpy names for C types to type codes used in the
# mediocre library, MediocreInput factories, and ctypes pointer classes
# corresponding to that C type.
np_type_dict = {
    "int8"   : (8, i8_input, POINTER(c_int8)),
    "int16"  : (16, i16_input, POINTER(c_int16)),
    "int32"  : (32, i32_input, POINTER(c_int32)),
    "int64"  : (64, i64_input, POINTER(c_int64)),
    "uint8"  : (108, u8_input, POINTER(c_uint8)),
    "uint16" : (116, u16_input, POINTER(c_uint16)),
    "uint32" : (132, u32_input, POINTER(c_uint32)),
    "uint64" : (164, u64_input, POINTER(c_uint64)),
    "float32": (0xF, float_input, POINTER(c_float)),
    "float64": (0xD, double_input, POINTER(c_double)),
}

