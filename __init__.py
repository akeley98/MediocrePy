#! /usr/bin/python2.7

import sys
import os
from ctypes import * # They put annoying c_ prefixes on EVERYTHING, that's why.
import numpy as np

try:
    _libname = os.path.join(os.path.split(__file__)[0], "bin/mediocre.so")
    _lib = cdll.LoadLibrary(_libname)
except OSError as e:
    print>>sys.stderr, e.message
    message = "Failed to load C library %r. "\
        "Did you remember to make it?" % _libname
    raise ImportError(message)

_u16_np = np.dtype("uint16")
_f32_np = np.dtype("float32")

def _call(
    original_args,
    function,
    output_type,
    sigma,
    sigma_lower,
    sigma_upper,
    sigma_iter
):
    args = list(original_args)    
    
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
    if output_type not in (_u16_np, _f32_np):
        raise TypeError("Output type must be float32 or uint16")
    if sigma_lower is None or sigma_lower < 1.0:
        raise ValueError("sigma_lower needs to be at least 1.0")
    if sigma_upper is None or sigma_upper < 1.0:
        raise ValueError("sigma_upper needs to be at least 1.0")
    
    pointers = np.ndarray(shape=(len(args,)), dtype=c_void_p)
    
    arg0 = args[0]
    shape = args[0].shape
    bin_count = shape[0]
    for n in shape[1:]:
        bin_count *= n
    
    for i, a in enumerate(args):
        if type(a) is not np.ndarray:
            raise TypeError("Only supports numpy arrays, not %r" % type(a))
        if a.dtype != _u16_np:
            raise TypeError("Only supports arrays of uint16, not %r" % a.dtype)
            # This will change.
        if a.shape != shape:
            raise TypeError("Arrays must have the same shape.")
        if not a.flags["C_CONTIGUOUS"]:
            # Store the C contiguous copy in our copy of the list of arguments
            # to keep it alive while we use the pointer to its data.
            args[i] = np.ascontiguousarray(a)
            assert args[i].flags["C_CONTIGUOUS"]
            
        pointers[i] = args[i].ctypes.data
    
    if output_type == _f32_np:
        output_type_code = 0xF
    elif output_type == _u16_np:
        output_type_code = 116
    
    input_type_code = 116
    
    output = np.ndarray(shape=shape, dtype=output_type)
    
    error_code = function(
        output.ctypes.data_as(c_void_p), c_size_t(output_type_code),
        pointers.ctypes.data_as(c_void_p), c_size_t(input_type_code),
        c_size_t(len(pointers)),
        c_size_t(bin_count),
        c_double(sigma_lower),
        c_double(sigma_upper),
        c_size_t(sigma_iter)
    )
    
    if error_code != 0:
        raise Exception("Something happened (add real message later)")
    
    return output

def mean(
    arrays,
    output_type=np.uint16,
    sigma=None,
    sigma_lower=None,
    sigma_upper=None,
    sigma_iter=None
):
    return _call(
        arrays,
        function=_lib.mediocre_clipped_mean,
        output_type=output_type,
        sigma=sigma,
        sigma_lower=sigma_lower,
        sigma_upper=sigma_upper,
        sigma_iter=sigma_iter
    )

def median(
    arrays,
    output_type=np.uint16,
    sigma=None,
    sigma_lower=None,
    sigma_upper=None,
    sigma_iter=None
):
    return _call(
        arrays,
        function=_lib.mediocre_clipped_median,
        output_type=output_type,
        sigma=sigma,
        sigma_lower=sigma_lower,
        sigma_upper=sigma_upper,
        sigma_iter=sigma_iter
    )

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
        chips = [lst[chipnum].data[0:4608, 0:2048] for lst in hdu_lists]
        
        combined_chips[chipnum] = f(
            chips, output_type=np.float32, sigma_iter=sigma_iter
        )
    # Normalize the data based on the middle of the first extension???
    flatdiv = np.median(combined_chips[1][500:1600, 1000:3500])
    
    print combined_chips[1][10,10]
    
    print "flatdiv = %f" % flatdiv # XXX
    for chipnum in xrange(1, 5):
        combined_chips[chipnum] = combined_chips[chipnum] / flatdiv
    
    print combined_chips[1][10, 10]
    
    hdulist = fits.HDUList(
        [fits.PrimaryHDU()] +
        [fits.ImageHDU(combined_chips[i]) for i in xrange(1, 5)]
    )
    hdulist.writeto(output_name)

if __name__ == "__main__":
    main()
