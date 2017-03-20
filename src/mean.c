/*  An aggresively average SIMD python module
 *  Copyright (C) 2017 David Akeley
 *  
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *  
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *  
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "mean.h"

#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <immintrin.h>
#include <emmintrin.h>

#include "convert.h"

int mediocre_mean_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count
) {
    if (array_count == 0 || bin_count == 0) {
        errno = EINVAL;
        return -1;
    }
    // vector_count is the number of __m256 vectors needed to store bin_count
    // floats. This is equal to bin_count / 8, rounded up.
    const size_t vector_count = (bin_count + 7) / 8;
    
    // accumulator is the buffer that we will use to sum up each lane of
    // the input arrays.
    // i.e. accumulator[n] = sum(data[i][n] for i := 0 to bin_count - 1)
    __m256* accumulator = aligned_alloc(
        sizeof(__m256), vector_count * sizeof(__m256));
    
    if (accumulator == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    
    load_m256_from_u16(accumulator, data[0], bin_count);
    
    for (size_t a = 1; a < array_count; ++a) {
        iadd_m256_by_u16(accumulator, data[a], bin_count);
    }
    
    __m256 divisor_vector = _mm256_set1_ps((float)array_count);
    for (size_t i = 0; i < vector_count; ++i) {
        accumulator[i] = _mm256_div_ps(accumulator[i], divisor_vector);
    }
    
    load_u16_from_m256(out, accumulator, bin_count);
    
    free(accumulator);
    return 0;
}

/*  Return a mask representing whether each float arg[i] in arg  is  in  the
 *  range [lower[i], upper[i]] (inclusive). mask[i] is positive (high bit 0)
 *  if arg[i] was in-range, negative (high bit 1) if it was out of range.
 */
static inline __m256 sigma_mask(__m256 arg, __m256 lower, __m256 upper) {
    // 0 bit if arg[i] >= lower[i], 1 bit if arg[i] < lower[i].
    __m256 const lower_mask = _mm256_sub_ps(arg, lower);
    // 0 bit if arg[i] <= upper[i], 1 bit if arg[i] > upper[i].
    __m256 const upper_mask = _mm256_sub_ps(upper, arg);
    // If either bit is 1, it's out-of-range and we should return 1.
    return _mm256_or_ps(lower_mask, upper_mask);
}

// TODO Document this mess. To start, what is in2D?
static inline void clipped_mean_u16_chunk(
    __m256* out,
    __m256 const* in2D,
    size_t vectors_per_group,
    size_t group_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter
) {
    assert(group_count >= 1);
    assert(vectors_per_group >= 1);
    
    const __m256 zero = _mm256_setzero_ps();
    const __m256 one = _mm256_set1_ps(1.0f);
    
    for (size_t g = 0; g < group_count; ++g) {
        __m256 const* group = in2D + g*vectors_per_group;
        __m256 lower_clip = _mm256_setzero_ps();
        __m256 upper_clip = _mm256_set1_ps(65536.0f);
        __m256 clipped_mean;
        __m256 previous_count = _mm256_set1_ps((float)vectors_per_group + 1.f);
        
        for (size_t it = 0; true; ++it) {
            // Sum is the sum of the numbers in each lane that were not
            // clipped. Count is the number of numbers in each lane that
            // were not clipped. We will calculate the clipped mean by
            // dividing the sum by the count, both of which only take into
            // account numbers that were not clipped.
            __m256 sum = _mm256_setzero_ps();
            __m256 count = _mm256_setzero_ps();
            
            for (size_t i = 0; i < vectors_per_group; ++i) {
                // For each vector in the group and each lane within that
                // vector, add zero if that lane's number is out of the
                // clipping range and either the number itself or one
                // to sum and count, respectively, if it was in range.
                __m256 const vec = group[i];
                __m256 const mask = sigma_mask(vec, lower_clip, upper_clip);
                
                sum = _mm256_add_ps(sum, _mm256_blendv_ps(vec, zero, mask));
                count = _mm256_add_ps(count, _mm256_blendv_ps(one, zero, mask));
            }
            clipped_mean = _mm256_div_ps(sum, count);
            
            // Each number in count will be less than or equal to the 
            // corresponding number in previous_count. Subtract the two,
            // and if each sign bit in the difference is 0, we know no
            // more numbers were clipped this iteration than the last
            // iteration so we can exit and move on to the next group.
            // We also exit if we have reached the iteration limit.
            previous_count = _mm256_sub_ps(count, previous_count);
            if (it == max_iter || _mm256_movemask_ps(previous_count) == 0) {
                break;
            }
            previous_count = count;
            
            // To calculate the standard deviation, we need to first get the
            // sum of the squared deviations. We will do this in double rather
            // than single precision since we will be adding up a lot of
            // large numbers, and we want to minimize rounding error.
            // (Trust me, this was in single precision before I rewrote
            // it using double precision; float wasn't good enough -_-).
            __m256d lo_ss = _mm256_setzero_pd();
            __m256d hi_ss = _mm256_setzero_pd();
            __m256d const lo_count = _mm256_cvtps_pd(
                _mm256_castps256_ps128(count)
            );
            __m256d const hi_count = _mm256_cvtps_pd(
                _mm256_extractf128_ps(count, 1)
            );
            __m256d const lo_mean = _mm256_cvtps_pd(
                _mm256_castps256_ps128(clipped_mean)
            );
            __m256d const hi_mean = _mm256_cvtps_pd(
                _mm256_extractf128_ps(clipped_mean, 1)
            );
            for (size_t i = 0; i < vectors_per_group; ++i) {
                // I think that recalculating the mask is faster than storing
                // and reloading it from memory. Memory is slooooow.
                __m256 const vec = group[i];
                __m256 const mask = sigma_mask(vec, lower_clip, upper_clip);
                
                __m256 const diffs = _mm256_blendv_ps(
                    _mm256_sub_ps(vec, clipped_mean), zero, mask
                );
                __m256d const lo_diffs = _mm256_cvtps_pd(
                    _mm256_castps256_ps128(diffs)
                );
                __m256d const hi_diffs = _mm256_cvtps_pd(
                    _mm256_extractf128_ps(diffs, 1)
                );
                __m256d lo_sq = _mm256_mul_pd(lo_diffs, lo_diffs);
                __m256d hi_sq = _mm256_mul_pd(hi_diffs, hi_diffs);
                
                hi_ss = _mm256_add_pd(hi_ss, hi_sq);
                lo_ss = _mm256_add_pd(lo_ss, lo_sq);
            }
            // Now we have the sum of the squared deviations and we can
            // use it to get the standard deviation. Use this to calculate
            // the lower and upper clip bounds for the next iteration.
            // (Yes, I know about FMA, but not all processors do ;_; )
            __m256d const lo_avg_ss = _mm256_div_pd(lo_ss, lo_count);
            __m256d const hi_avg_ss = _mm256_div_pd(hi_ss, hi_count);
            __m256d const lo_sd = _mm256_sqrt_pd(lo_avg_ss);
            __m256d const hi_sd = _mm256_sqrt_pd(hi_avg_ss);
            
            __m256 const new_lower_clip = _mm256_setr_m128(
                _mm256_cvtpd_ps(
                    _mm256_sub_pd(lo_mean, _mm256_mul_pd(lo_sd, sigma_lower))
                ),
                _mm256_cvtpd_ps(
                    _mm256_sub_pd(hi_mean, _mm256_mul_pd(hi_sd, sigma_lower))
                )
            );
            __m256 const new_upper_clip = _mm256_setr_m128(
                _mm256_cvtpd_ps(
                    _mm256_add_pd(lo_mean, _mm256_mul_pd(lo_sd, sigma_upper))
                ),
                _mm256_cvtpd_ps(
                    _mm256_add_pd(hi_mean, _mm256_mul_pd(hi_sd, sigma_upper))
                )
            );
            
            lower_clip = _mm256_max_ps(lower_clip, new_lower_clip);
            upper_clip = _mm256_min_ps(upper_clip, new_upper_clip);
        }
        out[g] = clipped_mean;
    }
}

int mediocre_clipped_mean_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    if (
        array_count == 0 || bin_count == 0 ||
        sigma_lower < 1. || sigma_upper < 1.
    ) {
        errno = EINVAL;
        return -1;
    }
    int err = 0;
    const __m256d sigma_lower_vec = _mm256_set1_pd(sigma_lower);
    const __m256d sigma_upper_vec = _mm256_set1_pd(sigma_upper);
    const size_t chunk_vector_count = 2048;
    const size_t chunk_item_count = chunk_vector_count * 8;
    
    const size_t chunk_count = bin_count / chunk_item_count;
    __m256* allocated = (__m256*)aligned_alloc(
        sizeof(__m256), (1 + array_count) * chunk_vector_count * sizeof(__m256)
    );
    
    if (allocated == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    
    __m256* out_chunk = allocated;
    __m256* in2D = allocated + chunk_vector_count;
    
    for (size_t c = 0; c < chunk_count; ++c) {
        // Set up the in2D array the way clipped_mean_u16_chunk expects it.
        // The array is organized into groups of array_count __m256 vectors,
        // with each group corresponding to a column of 8 16-bit unsigned 
        // ints from the unsigned input arrays. Each group of vectors will
        // be sigma clipped and averaged down to one vector. The in2D array
        // slice [i*array_count:(i+1)*array_count-1] corresponds to the
        // concatenated slices [i*8:i*8+7] of each data array from 0 to
        // array_count-1. The output vector i corresponds to output uint16_t
        // array slice [i*8:i*8+7]. I tried my best to explain this :(.
        for (size_t a = 0; a < array_count; ++a) {
            load_m256_from_u16_stride(
                in2D + a,
                data[a] + chunk_item_count*c,
                chunk_item_count,               // item_count
                array_count                     // stride
            );
        }
        clipped_mean_u16_chunk(
            out_chunk, in2D,
            array_count, chunk_vector_count,
            sigma_lower_vec, sigma_upper_vec,
            max_iter
        );
        uint16_t* final_output = out + chunk_item_count*c;
        err |= load_u16_from_m256(final_output, out_chunk, chunk_item_count);
    }
    size_t remainder = bin_count % chunk_item_count;
    size_t remainder_vector_count = (remainder + 7) / 8;
    if (remainder != 0) {
        for (size_t a = 0; a < array_count; ++a) {
            load_m256_from_u16_stride(
                in2D + a,
                data[a] + chunk_item_count*chunk_count,
                remainder,          // item_count
                array_count         // stride
            );
        }
        clipped_mean_u16_chunk(
            out_chunk, in2D,
            array_count, remainder_vector_count,
            sigma_lower_vec, sigma_upper_vec,
            max_iter
        );
        uint16_t* final_output = out + chunk_item_count*chunk_count;
        err |= load_u16_from_m256(final_output, out_chunk, remainder);
    }
    free(allocated);
    
    return err;
}

