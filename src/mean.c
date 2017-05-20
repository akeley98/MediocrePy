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

#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <immintrin.h>

#include "mediocre.h"
#include "sigmautil.h"

// The largest integer that can be stored in a single precision float
// with the least-significant-bit being the ones place.
static const size_t max_combine_count = 0xFFFFFF;

/*  Calculate the sigma clipped mean of groups  of  floating  point  numbers
 *  with lower and upper sigma bounds passed as specified below.
 *  
 *  Each column of numbers to be combined is passed to  the  function  as  a
 *  lane  of  floats  within  an  array[0  ...  combine_count - 1] of __m256
 *  vectors. Since there are 8 lanes within an __m256 vector, 8 columns  are
 *  passed  within  one  array.  These  arrays are passed as subarrays[0 ...
 *  combine_count - 1] (chunks) within the in2D array. The clipped  mean  of
 *  each  lane  of  floats  is  written  to  the out array. Interpreting the
 *  pointers as pointer to float instead of to __m256,
 *      out[8x + y]
 *  corresponds to the clipped mean of every 8th float in the range
 *      in2D[8*x*combine_count + y ... 8*(x+1)*combine_count + y - 8]
 *  (see example below)
 *  
 *    ** out
 *  array [0 ... chunk_count - 1] of __m256
 *    ** in2D
 *  array [0 ... chunk_count * combine_count - 1] of __m256
 *  (list of [chunk_count] chunks of [combine_count] __m256 vectors.
 *    ** combine_count
 *  count of the number of floats that are clipped into a single output
 *    ** chunk_count
 *  number of chunks (subarrays of 8 columns of numbers).
 *    ** sigma_lower
 *  lower bound (in standard deviations) for the sigma clipping passed as  a
 *  vector of 4 identical positive doubles.
 *    ** sigma_upper
 *  upper bound (in standard deviations) for the sigma clipping passed as  a
 *  vector of 4 identical positive doubles.
 *    ** max_iter
 *  maximum number of iterations of sigma clipping to be performed.
 *  
 *  Example memory layout for combine_count = 4, chunk_count = 3 (3 * 8 = 24
 *  columns  of  4  floats  total).  Each  of  the  4 numbers stored in in2D
 *  labelled with the same character has their clipped mean  output  to  the
 *  number with the same label in out.
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
static void clipped_mean_chunk_m256(
    __m256* out,
    __m256* in2D,
    size_t combine_count,
    size_t chunk_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter
) {
    assert(chunk_count >= 1);
    assert(combine_count >= 1);
    assert(combine_count <= max_combine_count);
    
    const __m256 zero = _mm256_setzero_ps();
    const __m256 one = _mm256_set1_ps(1.0f);
    
    for (size_t g = 0; g < chunk_count; ++g) {
        // Prepare for the coming iterations of sigma clipping.
        // The chunk pointer will be initialized to point to the subarray
        // of 8 lanes of combine_count floats. We will calculate 8 means
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
        __m256 const* const chunk = in2D + g * combine_count;
        
        __m256 clipped_mean;
        __m256 previous_count = _mm256_set1_ps((float)combine_count + 1.f);
        
        struct ClipBoundsM256 bounds = {
            _mm256_set1_ps(-1.f/0.f), _mm256_set1_ps(1.f/0.f)
        };
        
        for (size_t iter = 0; ; ++iter) {
            // Sum is the sum of the numbers in each lane that were not
            // clipped. Count is the number of numbers in each lane that
            // were not clipped. We will calculate the clipped mean by
            // dividing the sum by the count, both of which only take into
            // account numbers that were not clipped.
            __m256 sum = _mm256_setzero_ps();
            __m256 count = _mm256_setzero_ps();
            
            // Todo consider using the Kahan summation algorithm.
            
            for (size_t i = 0; i < combine_count; ++i) {
                // For each vector in the chunk and each lane within that
                // vector, add the number inside the lane and one to sum and
                // count, respectively, only if the lane's number was in range.
                // (Add zero if it wasn't - this shouldn't have an effect).
                __m256 const vec = chunk[i];
                __m256 const mask = sigma_mask(vec, bounds);
                
                sum = _mm256_add_ps(sum, _mm256_blendv_ps(vec, zero, mask));
                count = _mm256_add_ps(count, _mm256_blendv_ps(one, zero, mask));
            }
            clipped_mean = _mm256_div_ps(sum, count);
            
            // Each number in count will be less than or equal to the 
            // corresponding number in previous_count. Subtract the two,
            // and if each sign bit in the difference is 0, we know no
            // more numbers were clipped this iteration than the last
            // iteration so we can exit and move on to the next chunk of
            // 8 columns. We also exit if we have reached the iteration limit.
            previous_count = _mm256_sub_ps(count, previous_count);
            if (iter == max_iter || _mm256_movemask_ps(previous_count) == 0) {
                break;
            }
            previous_count = count;
            
            // Now we know that we should continue iterating, calculate
            // the new bounds to be used for next iteration's calculation
            // of the mean.
            bounds = get_new_clip_bounds(
                chunk,                  // data
                combine_count,          // vector_count
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

struct arguments {
    double sigma_lower;
    double sigma_upper;
    size_t max_iter;
};

static void loop_function(
    MediocreFunctorControl* control,
    void const* user_data,
    MediocreDimension maximum_request
) {
    struct arguments* arguments_ptr = (struct arguments*)user_data;
    (void)maximum_request;
    
    const __m256d sigma_lower = _mm256_set1_pd(arguments_ptr->sigma_lower);
    const __m256d sigma_upper = _mm256_set1_pd(arguments_ptr->sigma_upper);
    const size_t max_iter = arguments_ptr->max_iter;
    
    MediocreFunctorCommand command;
    
    MEDIOCRE_FUNCTOR_LOOP(command, control) {
        // Divide the requested width by 8 (rounded up) to get the chunk count.
        size_t chunk_count = (command.dimension.width + 7) / 8;
        
        __m256* temp_output = mediocre_functor_aligned_temp(command, control);
        
        if (temp_output == NULL) {
            perror("mediocre_clipped_mean_functor\n"
                "could not allocated temp_output");
            mediocre_functor_error(control, errno);
        } else if (command.dimension.combine_count > max_combine_count) {
            fprintf(stderr, "mediocre_clipped_mean_functor\n"
                "too many arrays to be combined [%zi > %zi]\n",
                command.dimension.combine_count, max_combine_count
            );
            mediocre_functor_error(control, E2BIG);
        } else {
            clipped_mean_chunk_m256(
                temp_output,
                command.input_chunks,
                command.dimension.combine_count,
                chunk_count,
                sigma_lower,
                sigma_upper,
                max_iter
            );
            mediocre_functor_write_temp(command, temp_output);
        }
    }
}

static void no_op(void* ignored) {
    (void)ignored;
}

MediocreFunctor mediocre_mean_functor() {
    // The mean functor will just be the clipped mean functor set to run with
    // zero iterations of sigma clipping.
    static const struct arguments no_sigma_clipping = {
        3.0, 3.0, 0
    };
    
    MediocreFunctor result;
    
    result.loop_function = loop_function;
    result.destructor = no_op;
    result.user_data = &no_sigma_clipping;
    result.nonzero_error = 0;
    
    return result;
}

MediocreFunctor mediocre_clipped_mean_functor2(
    double sigma_lower, double sigma_upper, size_t max_iter
) {
    MediocreFunctor result;
    result.loop_function = loop_function;
    result.destructor = free;
    result.user_data = NULL;
    
    if (sigma_lower < 1.0) {
        fprintf(stderr, "sigma_lower must be at least 1.\n");
        result.nonzero_error = ERANGE;
        return result;
    } else if (sigma_upper > 1.0) {
        fprintf(stderr, "sigma_upper must be at lest 1.\n");
        result.nonzero_error = ERANGE;
        return result;
    }
    
    struct arguments* args = (struct arguments*)malloc(sizeof *args);
    
    if (args == NULL) {
        perror("mediocre_clipped_mean_functor2");
        result.nonzero_error = errno;
        return result;
    } else {
        args->sigma_lower = sigma_lower;
        args->sigma_upper = sigma_upper;
        args->max_iter = max_iter;
        
        result.user_data = args;
        result.nonzero_error = 0;
        
        return result;
    }
}

