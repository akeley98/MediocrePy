#! /usr/bin/python2.7

import errno
import sys
import os
from ctypes import * # They put annoying c_ prefixes on EVERYTHING, that's why.
import numpy as np

try:
    _libname = os.path.join(os.path.split(__file__)[0], "bin/MediocrePy.so")
    _lib = cdll.LoadLibrary(_libname)
except OSError as e:
    print>>sys.stderr, e.message
    message = "Failed to load C library %r. "\
        "Did you remember to make it?" % _libname
    raise ImportError(message)

_typecodes = {
    "float64" : 0xD,
    "float32" : 0xF,
    "int8" : 8,
    "int16" : 16,
    "int32" : 32,
    "uint8" : 108,
    "uint16" : 116
}

def _call(
    original_args,
    function,
    sigma,
    sigma_lower,
    sigma_upper,
    sigma_iter
):
    args = tuple(original_args)    
    
    if sigma is not None:
        if sigma_iter is None:
            sigma_iter = 10
    else:
        if sigma_iter is None:
            sigma_iter = 0
        sigma = 3.0
    
    if sigma_lower is None:
        sigma_lower = sigma
    if sigma_upper is None:
        sigma_upper = sigma
    if len(args) == 0:
        raise ValueError("Need at least one array.")
    if sigma_lower is None or sigma_lower < 1.0:
        raise ValueError("sigma_lower needs to be at least 1.0")
    if sigma_upper is None or sigma_upper < 1.0:
        raise ValueError("sigma_upper needs to be at least 1.0")
    
    stride_arrays = np.empty(shape=(len(args), 5), dtype=c_void_p)
    shape = None
    
    for i, a in enumerate(args):
        if type(a) is not np.ndarray:
            raise TypeError("Requires numpy.ndarray objects only")
        
        shape_len = len(a.shape)
        if shape_len > 2:
            raise TypeError("Arrays may be 1 or 2 dimensional only")
        
        if shape is None:
            shape = a.shape
        elif a.shape != shape:
            raise TypeError("Arrays must have the same shape")
        
        try:
            array_typecode = _typecodes[a.dtype.name]
        except KeyError:
            raise TypeError("Cannot use array of %s as argument" % a.dtype.name)
        
        stride_arrays[i] = [    # See strideloader.h for struct definition.
            a.ctypes.data,      # Pointer to data
            array_typecode,     # Array type code
            a.shape[-1],        # Least-significant axis item count
            a.strides[0],       # Most-significant axis stride (unused for 1D).
            a.strides[-1],      # Least-significant axis stride
        ]
    
    output = np.empty(shape=shape, dtype=np.float32, order="C")
    
    error_code = function(
        output.ctypes.data_as(c_void_p),
        stride_arrays.ctypes.data_as(c_void_p),
        c_size_t(len(args)),
        c_size_t(shape[0] * (shape[1] if len(shape) == 2 else 1)),
        c_double(sigma_lower),
        c_double(sigma_upper),
        c_size_t(sigma_iter)
    )
    
    if error_code == 0:
        return output
    elif error_code == errno.ENOMEM:
        raise MemoryError
    elif error_code == errno.EINVAL:
        raise ValueError("Invalid argument. See console for possible details")
    elif error_code == errno.ERANGE:
        raise OverflowError
    else:
        raise Exception("%i %s" % (error_code, os.strerror(error_code)))

def mean(
    arrays,
    sigma=None,
    sigma_lower=None,
    sigma_upper=None,
    sigma_iter=None
):
    return _call(
        arrays,
        function=_lib.MediocrePy_clipped_mean,
        sigma=sigma,
        sigma_lower=sigma_lower,
        sigma_upper=sigma_upper,
        sigma_iter=sigma_iter
    )

def median(
    arrays,
    sigma=None,
    sigma_lower=None,
    sigma_upper=None,
    sigma_iter=None
):
    return _call(
        arrays,
        function=_lib.MediocrePy_clipped_median,
        sigma=sigma,
        sigma_lower=sigma_lower,
        sigma_upper=sigma_upper,
        sigma_iter=sigma_iter
    )

def get_normalized(array):
    flatdiv = np.median(array[500:1600, 1000:3500])
    result = np.copy(array) / flatdiv
    return result

# Demo program for fits files with 4 4608 by 2048 chips (16 bit unsigned)
def main():
    import astropy.io.fits as fits
    try:
        output_name = sys.argv[1]
        f = { "median": median, "mean": mean }[sys.argv[2]]
        sigma_iter = { "median": 0, "mean": 10 }[sys.argv[2]]
    except (IndexError, KeyError):
        print>>sys.stderr, """Format:
            [output filename] [mean|median] [input fits files...]"""
        raise SystemExit
    
    hdu_lists = [fits.open(name) for name in sys.argv[3:]]
    
    combined_chips = [None] * 5
    
    for chipnum in xrange(1, 5):
        chips = [get_normalized(lst[chipnum].data[0:4608, 0:2048]) for lst in hdu_lists]
        
        combined_chips[chipnum] = f(
            chips, sigma_iter=sigma_iter
        )
    # Normalize the data based on the middle of the first extension???
    flatdiv = np.median(combined_chips[1][500:1600, 1000:3500])
    
    for chipnum in xrange(1, 5):
        combined_chips[chipnum] = combined_chips[chipnum] / flatdiv
    
    hdulist = fits.HDUList(
        [fits.PrimaryHDU()] +
        [fits.ImageHDU(combined_chips[i]) for i in xrange(1, 5)]
    )
    hdulist.writeto(output_name)

if __name__ == "__main__":
    main()

