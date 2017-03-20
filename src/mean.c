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
    __m256 const lower_mask = _mm256_sub_ps(lower, arg);
    // 0 bit if arg[i] <= upper[i], 1 bit if arg[i] > upper[i].
    __m256 const upper_mask = _mm256_sub_ps(arg, upper);
    // If either bit is 1, it's out-of-range and we should return 1.
    return _mm_or_ps(lower_mask, upper_mask);
}

static inline void clipped_mean_u16_chunk(
    __m256* out,
    __m256 const* in2D,
    size_t vectors_per_group,
    size_t group_count,
    __m256 sigma_lower,
    __m256 sigma_upper,
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
        __m256 previous_count = _mm256_set1_ps((float)vectors_per_group);
        
        for (size_t it = 0; it < max_iter; ++it) {
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
            // corresponding number in previous_count. 
            previous_count = _mm256_sub_ps(count, previous_count);
            if (_mm256_movemask_ps(previous_count) == 0) {
                goto finish_iter;
            }
            previous_count = count;
            
            
            __m256 sqdev = _mm256_setzero_ps();
        }
        
      finish_iter:
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
    
}

