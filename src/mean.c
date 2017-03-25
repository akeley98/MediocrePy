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
#include <string.h>
#include <stdlib.h>
#include <immintrin.h>
#include <emmintrin.h>

#include "convert.h"
#include "sigmautil.h"


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

/*  Calculate the sigma clipped mean of groups  of  floating  point  numbers
 *  with lower and upper sigma bounds passed as specified below.
 *  
 *  Each group of numbers is passed to the function  as  a  lane  of  floats
 *  within an array[0 ... group_size - 1] of __m256 vectors. Since there are
 *  8 lanes within an __m256 vector, 8 groups are passed within  one  array.
 *  These  arrays  are  passed as subarrays[0 ... group_size - 1] within the
 *  in2D array. The clipped mean of each lane of floats is  written  to  the
 *  out  array.  Interpreting the pointers as pointer to float instead of to
 *  __m256,
 *      out[8x + y]
 *  corresponds to the clipped mean of every 8th float in the range
 *      in2D[8*x*group_size + y ... 8*(x+1)*group_size + y - 8]
 *  (see example below)
 *  
 *    ** out
 *  array [0 ... subarray_count - 1] of __m256
 *    ** in2D
 *  array [0 ... subarray_count * group_size - 1] of __m256
 *    ** group_size
 *  count of the number of floats that are clipped into a single output
 *    ** subarray_count
 *  number of groups, divided by 8.
 *    ** sigma_lower
 *  lower bound (in standard deviations) for the sigma clipping passed as  a
 *  vector of 4 identical positive doubles.
 *    ** sigma_upper
 *  upper bound (in standard deviations) for the sigma clipping passed as  a
 *  vector of 4 identical positive doubles.
 *    ** max_iter
 *  maximum number of iterations of sigma clipping to be performed.
 *  
 *  Example memory layout for group_size = 4, subarray_count = 3 (3 * 8 = 24
 *  groups of 4 floats total). Each of the 4 numbers stored in in2D labelled
 *  with the same character has their clipped mean output to the number with
 *  the same label in out.
 *  
 *      out+0:  0 1 2 3 4 5 6 7  8 9 A B C D E F
 *      +64:    G H I J K L M N
 *  
 *      in2D+0: 0 1 2 3 4 5 6 7  0 1 2 3 4 5 6 7
 *      +64:    0 1 2 3 4 5 6 7  0 1 2 3 4 5 6 7
 *      +128:   8 9 A B C D E F  8 9 A B C D E F
 *      +192:   8 9 A B C D E F  8 9 A B C D E F
 *      +256:   G H I J K L M N  G H I J K L M N
 *      +320:   G H I J K L M N  G H I J K L M N 
 */
static inline void clipped_mean_chunk_m256(
    __m256* out,
    __m256 const* in2D,
    size_t group_size,
    size_t subarray_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter
) {
    assert(subarray_count >= 1);
    assert(group_size >= 1);
    assert(group_size <= 0xFFFFFF);
    
    const __m256 zero = _mm256_setzero_ps();
    const __m256 one = _mm256_set1_ps(1.0f);
    
    for (size_t g = 0; g < subarray_count; ++g) {
        // Prepare for the coming iterations of sigma clipping.
        // The group pointer will be initialized to point to the subarray
        // of 8 lanes of group_size floats. We will calculate 8 means
        // at once for the 8 lanes of floats.
        // 
        // bounds is the current clipping bounds, which will be updated
        // per iteration. We start with the least restrictive bounds
        // possible: negative to positive infinity.
        // 
        // clipped_mean is the mean of the numbers currently within the clipping
        // bounds defined by bounds. This is also updated per iteration.
        // 
        // If the same number of numbers were used to calculate the clipped
        // mean in one iteration as in the next iteration, then we know that
        // all further iterations will also clip no more numbers and we can
        // finish iteration early. We implement this by storing the count of
        // numbers used per lane to calculate the mean in the previous     
        // iteration using the lanes of the previous_count variable, and
        // comparing this with the count used in the current iteration.
        // Once there is no change in each lane (or we iterate until max_iter),
        // finish iterating, write out each lane of the final clipped_mean 
        // output, and move on to the next group of 8-lane vectors.
        // 
        // In truth, I wonder if the branch (mis)prediction costs are more
        // than the time saved by finishing iteration early (probably not).
        __m256 const* const subarray = in2D + g * group_size;
        
        __m256 clipped_mean;
        __m256 previous_count = _mm256_set1_ps((float)group_size + 1.f);
        
        struct ClipBoundsM256 bounds = {
            _mm256_set1_ps(-1.f/0.f), _mm256_set1_ps(1.f/0.f)
        };
        
        for (size_t iter = 0; true; ++iter) {
            // Sum is the sum of the numbers in each lane that were not
            // clipped. Count is the number of numbers in each lane that
            // were not clipped. We will calculate the clipped mean by
            // dividing the sum by the count, both of which only take into
            // account numbers that were not clipped.
            __m256 sum = _mm256_setzero_ps();
            __m256 count = _mm256_setzero_ps();
            
            for (size_t i = 0; i < group_size; ++i) {
                // For each vector in the subarray and each lane within that
                // vector, add zero if that lane's number is out of the
                // clipping range and either the number itself or one
                // to sum and count, respectively, if it was in range.
                __m256 const vec = subarray[i];
                __m256 const mask = sigma_mask(vec, bounds);
                
                sum = _mm256_add_ps(sum, _mm256_blendv_ps(vec, zero, mask));
                count = _mm256_add_ps(count, _mm256_blendv_ps(one, zero, mask));
            }
            clipped_mean = _mm256_div_ps(sum, count);
            
            // Each number in count will be less than or equal to the 
            // corresponding number in previous_count. Subtract the two,
            // and if each sign bit in the difference is 0, we know no
            // more numbers were clipped this iteration than the last
            // iteration so we can exit and move on to the next subarray of
            // 8 groups. We also exit if we have reached the iteration limit.
            previous_count = _mm256_sub_ps(count, previous_count);
            if (iter == max_iter || _mm256_movemask_ps(previous_count) == 0) {
                break;
            }
            previous_count = count;
            
            // Now we know that we should continue iterating, calculate
            // the new bounds to be used for next iteration's calculation
            // of the mean.
            bounds = sigma_clip_step(
                subarray,               // data
                group_size,             // vector_count
                bounds,                 // bounds
                clipped_mean,           // center
                count,                  // clipped_count
                sigma_lower,            // sigma_lower (double vector)
                sigma_upper             // sigma_upper (double vector)
            );
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
        // Set up the in2D array the way clipped_mean_chunk_m256 expects it.
        for (size_t a = 0; a < array_count; ++a) {
            load_m256_from_u16_stride(
                in2D + a,
                data[a] + chunk_item_count*c,
                chunk_item_count,               // item_count
                array_count                     // stride
            );
        }
        clipped_mean_chunk_m256(
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
        clipped_mean_chunk_m256(
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

