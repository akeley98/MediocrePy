# An aggresively average SIMD combine library
# Copyright (C) 2017 David Akeley
# 
# All combine algorithms implemented in C are reimplemented here in Python.
# We will test the combine functions (and 5x5 median filter) here by comparing
# the mediocre library results with the Python results. The results won't
# match perfectly because the C library uses single precision while Python is
# in double precision, so we use almost_equal to see if each result is close
# enough to the other. Even that isn't enough though, because the clipped 
# combine algorithms are 'chaotic', that is, small rounding differences can 
# have a big influence on the output since it could be the difference between
# including and excluding a borderline outlier. Because of this, this program
# allows a few errors to occur before failing a test; it just flags those
# errors for review.
# 
# NOTE THAT THE Python implementations are REALLY slow. This means that we
# aren't really testing the speed of the MediocrePy module nor are we testing
# it with as much different data as we could. The library also includes tests
# written in C that should be faster (but won't test the Python functionality).
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

from __future__ import print_function
import sys
import os
import random
import numpy as np

sys.path.append(os.path.join(os.path.split(__file__)[0], "../.."))

import MediocrePy

epsilon = 1.000005
epsilon_recip = 1/epsilon

try:
    range = xrange
except NameError: pass

def almost_equal(a, b):
    if b != 0:
        return epsilon_recip < a/b < epsilon
    else:
        return a == 0

def random_data(shape, dtype=None, contiguous=False):
    if dtype is None:
        dtype = rand.choice((
            np.int8, np.int16,  np.int32,  np.int64,  np.float32,
            np.uint8, np.uint16, np.uint32, np.uint64, np.float64
        ))
        scale, offset = (127, 0)
    else:
        # For getting normal distribution numbers that fit in the dtype's range.
        # We only do this is dtype is given explicitly, because that means 
        # we're testing homogeneous data. If we're testing heterogeneous data,
        # then we choose the most conservative scale and offset (127, 0).
        scale, offset = {
            "int8"      : (1e2, -30),
            "int16"     : (3e4, -1e4),
            "int32"     : (3e8, -1e8),
            "int64"     : (3e18, -1e18),
            "uint8"     : (2e2, 0),
            "uint16"    : (2e4, 0),
            "uint32"    : (4e9, 0),
            "uint64"    : (4e18,  0),
            "float32"   : (137.035999139, -40.0),
            "float64"   : (137.035999139, -40.0)
        }[dtype().dtype.name]
    
    rand_normal = lambda: \
        (rand.random() + rand.random() + rand.random() + rand.random()) \
        * 0.25 * scale + offset
    
    if contiguous:
        r0 = 0
        r1 = 0
        order = 'C'
    else:
        r0 = rand.randrange(3)
        r1 = rand.randrange(3)
        order = rand.choice("CF")
    
    # We will test strides by returing a slice of a raw data array.
    # Also randomize C / Fortran order.
    if len(shape) == 1:
        raw_data = np.empty((shape[0] * (1+r0),), dtype, order)
        result = raw_data[::1+r0]
        assert result.shape == shape
        for i in range(shape[0]):
            result[i] = rand_normal()
    
    elif len(shape) == 2:
        raw_data = np.empty((shape[0]*(1+r0), shape[1]*(1+r1)), dtype, order)
        result = raw_data[::1+r0, ::1+r1]
        assert result.shape == shape
        for x in range(shape[0]):
            for y in range(shape[1]):
                result[x][y] = rand_normal()
    
    return result

def random_mask(shape, dtype=None, nonzero_means_bad=True):
    if dtype is None:
        dtype = rand.choice((
            np.int8,  np.int16,  np.int32,  np.int64,  np.float32,
            np.uint8, np.uint16, np.uint32, np.uint64, np.float64
        ))
    
    assert len(shape) == 2
    nonzero_means_bad = bool(nonzero_means_bad)
    
    r0 = rand.randrange(3)
    r1 = rand.randrange(3)
    order = rand.choice("CF")
    
    raw_data = np.empty((shape[0] * (1+r0), shape[1] * (1+r1)), dtype, order)
    result = raw_data[::1+r0, ::1+r1]
    assert result.shape == shape
    for x in range(shape[0]):
        for y in range(shape[1]):
            result[x][y] = (rand.random() > .05) ^ nonzero_means_bad
    
    return result

# Apply median filter to masked out pixels.
def py_mask(array, mask, nonzero_means_bad):
    nonzero_means_bad = bool(nonzero_means_bad)
    shape = array.shape
    if mask.shape != array.shape or len(shape) != 2:
        raise TypeError
    result = np.empty(shape=shape, dtype=np.float32)
    row_count, col_count = shape
    for r in range(row_count):
        for c in range(col_count):
            if bool(mask[r][c]) == nonzero_means_bad:
                numbers = []
                for mask_r in range(max(0, r-2), min(r+3, row_count)):
                    for mask_c in range(max(0, c-2), min(c+3, col_count)):
                        if bool(mask[mask_r][mask_c]) != nonzero_means_bad:
                            numbers.append(array[mask_r][mask_c])
                result[r][c] = np.median(numbers)
            else:
                result[r][c] = array[r][c]
    return result

# Apply combine_function (takes one column of data) to stack of arrays
# (and masks, if applicable) in pure python.
def py_combine(combine_function, arrays, masks=None, nonzero_means_bad=True):
    shape = arrays[0].shape
    result = np.empty(shape=shape, dtype=np.float32)
    if masks is not None:
        arrays = [py_mask(arr, masks[i], nonzero_means_bad)
            for i, arr in enumerate(arrays)]
        
    if len(shape) == 1:
        for i in range(shape[0]):
            result[i] = combine_function([arr[i] for arr in arrays])
    elif len(shape) == 2:
        for r in range(shape[0]):
            for c in range(shape[1]):
                result[r][c] = combine_function([arr[r][c] for arr in arrays])
    else:
        raise TypeError
    return result

# Clipped mean combine of one column of data implemented in pure python.
def py_clipped_mean_combine(data, sigma_lower, sigma_upper, max_iter):
    for it in range(max_iter):
        mean, std = np.mean(data), np.std(data)
        lower_bounds = mean - std * sigma_lower
        upper_bounds = mean + std * sigma_upper
        
        data = [n for n in data if lower_bounds <= n <= upper_bounds]
    return np.mean(data)

# Scaled mean combine of one column of data implemented in pure python.
def py_scaled_mean_combine(
    data, sigma_lower, sigma_upper, max_iter, scale_factors
):
    qty_wt_pairs = [(n / scale_factors[i], scale_factors[i])
        for i, n in enumerate(data)]
    
    del data
    
    for it in range(max_iter):
        mean = np.mean([x[0] for x in qty_wt_pairs])
        std = np.std([x[0] for x in qty_wt_pairs])
        lower_bounds = mean - std * sigma_lower
        upper_bounds = mean + std * sigma_upper
        
        qty_wt_pairs = [n for n in qty_wt_pairs
            if lower_bounds <= n[0] <= upper_bounds]
    
    return np.average(
        [x[0] for x in qty_wt_pairs],
        weights=[x[1] for x in qty_wt_pairs]
    )

# Clipped median combine of one column of data implemented in pure python.
def py_clipped_median_combine(data, sigma_lower, sigma_upper, max_iter):
    for it in range(max_iter):
        median = np.median(data)
        ss = sum((n-median)*(n-median) for n in data)
        dev = np.sqrt(ss / len(data))
        
        lower_bounds = median - dev * sigma_lower
        upper_bounds = median + dev * sigma_upper
        
        data = [n for n in data if lower_bounds <= n <= upper_bounds]
    return np.median(data)

def get_test_data(shape1D, shape2D, combine_count, dtype):
    contiguous = rand.choice((False, True))
    nonzero_means_bad = rand.choice((False, True))
    
    arrays1D = [random_data(shape1D, dtype, contiguous)
        for i in range(combine_count)]
    
    arrays2D = [random_data(shape2D, dtype, contiguous)
        for i in range(combine_count)]
    
    masks = [random_mask(shape2D, dtype, nonzero_means_bad)
        for i in range(combine_count)]
    
    print("combine_count     %s" % combine_count)
    print("contiguous        %s" % contiguous)
    print("nonzero_means_bad %s" % nonzero_means_bad)
    print("shape1D           %s" % (shape1D, ))
    print("shape2D           %s" % (shape2D, ))
    print("dtype             %s" % (dtype().dtype.name if dtype else "multiple"))
    
    return contiguous, nonzero_means_bad, arrays1D, arrays2D, masks

def compare_1D(original_data, actual, expected):
    errors = 0
    max_errors = int(round(.0025 * actual.shape[0]))
    for x in range(actual.shape[0]):
        if not almost_equal(actual[x], expected[x]):
            print("[%i] %f != %f" % (x, actual[x], expected[x]))
            print([data[x] for data in original_data])
            errors += 1
            if errors >= max_errors:
                print("Too many errors, test failed")
                sys.exit(1)
    
    rate = errors / float(actual.shape[0])
    color = 34 if rate == 0 else 31
    print("\t\t\x1b[%im\x1b[1mError rate %.4f%%\x1b[0m" % (color, 100.0 * rate))

def compare_2D(original_data, actual, expected):
    errors = 0
    max_errors = int(round(.0025 * actual.shape[0] * actual.shape[1]))
    for x in range(actual.shape[0]):
        for y in range(actual.shape[1]):
            if not almost_equal(actual[x,y], expected[x,y]):
                print("[%i %i] %f != %f" % (x, y, actual[x,y], expected[x,y]))
                print([data[x,y] for data in original_data])
                errors += 1
                if errors >= max_errors:
                    print("Too many errors, test failed")
                    sys.exit(1)
    rate = errors / float(actual.shape[0] * actual.shape[1])
    color = 34 if rate == 0 else 31
    print("\t\t\x1b[%im\x1b[1mError rate %.4f%%\x1b[0m" % (color, 100.0 * rate))
    
def test_mean(shape1D, shape2D, combine_count, dtype):
    print("\n\x1b[1m\x1b[33mMean test\x1b[0m")
    contiguous, nonzero_means_bad, arrays1D, arrays2D, masks = get_test_data(
        shape1D, shape2D, combine_count, dtype
    )
    
    print("\t1D arrays")
    actual = MediocrePy.mean(arrays1D)
    expected = py_combine(np.mean, arrays1D)
    compare_1D(arrays1D, actual, expected)
    
    print("\t2D arrays")
    actual = MediocrePy.mean(arrays2D)
    expected = py_combine(np.mean, arrays2D)
    compare_2D(arrays2D, actual, expected)
    
    print("\t2D masked arrays")
    actual = MediocrePy.mean(arrays2D, masks, nonzero_means_bad)
    masked_arrays = [py_mask(a, m, nonzero_means_bad)
        for a, m in zip(arrays2D, masks)]
    expected = py_combine(np.mean, masked_arrays)
    compare_2D(arrays2D, actual, expected)

def test_median(shape1D, shape2D, combine_count, dtype):
    print("\n\x1b[1m\x1b[33mMedian test\x1b[0m")
    contiguous, nonzero_means_bad, arrays1D, arrays2D, masks = get_test_data(
        shape1D, shape2D, combine_count, dtype
    )
    
    print("\t1D arrays")
    actual = MediocrePy.median(arrays1D)
    expected = py_combine(np.median, arrays1D)
    compare_1D(arrays1D, actual, expected)
    
    print("\t2D arrays")
    actual = MediocrePy.median(arrays2D)
    expected = py_combine(np.median, arrays2D)
    compare_2D(arrays2D, actual, expected)
    
    print("\t2D masked arrays")
    actual = MediocrePy.median(arrays2D, masks, nonzero_means_bad)
    masked_arrays = [py_mask(a, m, nonzero_means_bad)
        for a, m in zip(arrays2D, masks)]
    expected = py_combine(np.median, masked_arrays)
    compare_2D(arrays2D, actual, expected)

def test_clipped_mean(shape1D, shape2D, combine_count, dtype, sigma_data):
    print("\n\x1b[1m\x1b[33mClipped mean test [%f %f] %i\x1b[0m" % sigma_data)
    contiguous, nonzero_means_bad, arrays1D, arrays2D, masks = get_test_data(
        shape1D, shape2D, combine_count, dtype
    )
    
    sigma_lower, sigma_upper, max_iter = sigma_data
    
    expected_combine = lambda data: py_clipped_mean_combine(data, *sigma_data)
    
    if sigma_lower != sigma_upper:
        clipped_mean_functor = MediocrePy.ClippedMean2(*sigma_data)
    else:
        # Test that the 1 sigma argument function works.
        clipped_mean_functor = MediocrePy.ClippedMean(sigma_lower, max_iter)
    
    print("\t1D arrays")
    actual = clipped_mean_functor(arrays1D)
    expected = py_combine(expected_combine, arrays1D)
    compare_1D(arrays1D, actual, expected)
    
    print("\t2D arrays")
    actual = clipped_mean_functor(arrays2D)
    expected = py_combine(expected_combine, arrays2D)
    compare_2D(arrays2D, actual, expected)
    
    print("\t2D masked arrays")
    actual = clipped_mean_functor(arrays2D, masks, nonzero_means_bad)
    masked_arrays = [py_mask(a, m, nonzero_means_bad)
        for a, m in zip(arrays2D, masks)]
    expected = py_combine(expected_combine, masked_arrays)
    compare_2D(arrays2D, actual, expected)

def test_scaled_mean(shape1D, shape2D, combine_count, dtype, sigma_data):
    print("\n\x1b[1m\x1b[33mScaled mean test [%f %f] %i\x1b[0m" % sigma_data)
    contiguous, nonzero_means_bad, arrays1D, arrays2D, masks = get_test_data(
        shape1D, shape2D, combine_count, dtype
    )
    
    sigma_lower, sigma_upper, max_iter = sigma_data
    
    scale_factors = [rand.random() + .5 for i in range(combine_count)]
    print("\x1b[36mScale factors: %s\x1b[0m" % repr(scale_factors))
    
    expected_combine = lambda data: py_scaled_mean_combine(
        data,
        sigma_data[0],
        sigma_data[1],
        sigma_data[2],
        scale_factors
    )
    
    if sigma_lower == sigma_upper:
        def c_scaled_mean(arrays, masks=None):
            return MediocrePy.scaled_mean(
                scale_factors=scale_factors,
                arrays=arrays,
                masks=masks,
                nonzero_means_bad=nonzero_means_bad,
                sigma=sigma_lower,
                max_iter=max_iter,
            )
    else:
        def c_scaled_mean(arrays, masks=None):
            return MediocrePy.scaled_mean(
                scale_factors=scale_factors,
                arrays=arrays,
                masks=masks,
                nonzero_means_bad=nonzero_means_bad,
                sigma_lower=sigma_lower,
                sigma_upper=sigma_upper,
                max_iter=max_iter
            )
    
    print("\t1D arrays")
    actual = c_scaled_mean(arrays1D)
    expected = py_combine(expected_combine, arrays1D)
    compare_1D(arrays1D, actual, expected)
    
    print("\t2D arrays")
    actual = c_scaled_mean(arrays2D)
    expected = py_combine(expected_combine, arrays2D)
    compare_2D(arrays2D, actual, expected)
    
    print("\t2D masked arrays")
    actual = c_scaled_mean(arrays2D, masks)
    masked_arrays = [py_mask(a, m, nonzero_means_bad)
        for a, m in zip(arrays2D, masks)]
    expected = py_combine(expected_combine, masked_arrays)
    compare_2D(arrays2D, actual, expected)

def test_clipped_median(shape1D, shape2D, combine_count, dtype, sigma_data):
    print("\n\x1b[1m\x1b[33mClipped median test [%f %f] %i\x1b[0m" % sigma_data)
    contiguous, nonzero_means_bad, arrays1D, arrays2D, masks = get_test_data(
        shape1D, shape2D, combine_count, dtype
    )
    
    sigma_lower, sigma_upper, max_iter = sigma_data
    
    expected_combine = lambda data: py_clipped_median_combine(data, *sigma_data)
    
    if sigma_lower != sigma_upper:
        clipped_median_functor = MediocrePy.ClippedMedian2(*sigma_data)
    else:
        # Test that the 1 sigma argument function works.
        clipped_median_functor = MediocrePy.ClippedMedian(sigma_lower, max_iter)
    
    print("\t1D arrays")
    actual = clipped_median_functor(arrays1D)
    expected = py_combine(expected_combine, arrays1D)
    compare_1D(arrays1D, actual, expected)
    
    print("\t2D arrays")
    actual = clipped_median_functor(arrays2D)
    expected = py_combine(expected_combine, arrays2D)
    compare_2D(arrays2D, actual, expected)
    
    print("\t2D masked arrays")
    actual = clipped_median_functor(arrays2D, masks, nonzero_means_bad)
    masked_arrays = [py_mask(a, m, nonzero_means_bad)
        for a, m in zip(arrays2D, masks)]
    expected = py_combine(expected_combine, masked_arrays)
    compare_2D(arrays2D, actual, expected)

def main():
    print("""
\x1b[32m\x1b[1mNOTE:\x1b[0m

Rare errors are to be expected, because the python implementation uses
double precision floats while the mediocre library uses single
precision. These tests are not representative of the speed of the
mediocre library (implemented in C). The library's results are being
compared to results calculated using pure Python. Calculating these
Python results takes up almost all of the testing time.\n""")
    global seed, rand
    while 1:
        seed = hash(os.urandom(8))
        rand = random.Random(seed)
        
        print("Seed = ", seed)
        
        shape1D = (rand.randrange(40000, 70000),)
        shape2D = (rand.randrange(180, 240), rand.randrange(200, 300))
        combine_count = rand.randrange(8, 24)
        dtype = rand.choice((
            None,None,None,None,None,None,None,None,None,None,
            np.int8,  np.int16,  np.int32,  np.int64,  np.float32,
            np.uint8, np.uint16, np.uint32, np.uint64, np.float64,
        ))
        sigma_data = (
            rand.choice((1.5, 2.0, 2.5, 3.0)),
            rand.choice((1.5, 2.0, 2.5, 3.0)),
            rand.randrange(2, 6)
        )
            
        test_mean(shape1D, shape2D, combine_count, dtype)
        test_median(shape1D, shape2D, combine_count, dtype)
        
        shape1D = (rand.randrange(6000, 8000),)
        shape2D = (rand.randrange(70, 95), rand.randrange(70, 95))
        
        test_clipped_mean(shape1D, shape2D, combine_count, dtype, sigma_data)
        test_scaled_mean(shape1D, shape2D, combine_count, dtype, sigma_data)
        test_clipped_median(shape1D, shape2D, combine_count, dtype, sigma_data)

if __name__ == "__main__":
    main()

