/*  An aggresively average SIMD python module
 *  Copyright (C) 2017 David Akeley
 *
 *  Default mean functors provided with the library implemented in this file.
 *  Includes mean, sigma clipped mean, and scaled mean combine algorithms.
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
#include "../exo_file/exo_file.h"

// The largest integer that can be stored in a single precision float
// with the least-significant-bit being the ones place.
static const size_t max_combine_count = 0xFFFFFF;

struct clipped_mean_result {
    __m256 clipped_mean;
    struct ClipBoundsM256 bounds;
};

/*  Calculate 8 clipped means of the 8 columns of [combine_count] numbers.
 *  The 8 columns are passed in chunk format. Return the 8 clipped means and
 *  the final 8 clipping bounds for those 8 means.
 */
static inline struct clipped_mean_result clipped_mean_m256(
    __m256 const* chunk,
    size_t combine_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter
) {
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
    // finish iterating, and return the final clipped_mean and clipping bounds.
    const __m256 zero = _mm256_setzero_ps();
    const __m256 one = _mm256_set1_ps(1.0f);

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

    struct clipped_mean_result result = { clipped_mean, bounds };
    return result;
}

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
    __m256 const* in2D,
    size_t combine_count,
    size_t chunk_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter
) {
    assert(chunk_count >= 1);
    assert(combine_count >= 1);
    assert(combine_count <= max_combine_count);

    for (size_t c = 0; c < chunk_count; ++c) {
        __m256 const* const chunk = in2D + c * combine_count;

        struct clipped_mean_result result = clipped_mean_m256(
            chunk, combine_count, sigma_lower, sigma_upper, max_iter
        );

        out[c] = result.clipped_mean;
    }
}

/*  Calculate the scaled mean (I'll explain later) of  data  passed  in  the
 *  same  format  as  for  clipped  mean.  The  first six arguments (out ...
 *  sigma_upper) have the same format as in the clipped mean function.
 *
 *  The scaled mean was  designed  with  the  use  case  of  combining  many
 *  astronomical photographs with different exposure times. To compare these
 *  photographs for outliers, we need to first  scale  them  so  that  their
 *  brightnesses  are similar. This is done by dividing each quantity by its
 *  scale factor and sigma clipping those  divided  quantities.  Then,  when
 *  outliers  are  removed,  we  take  the  weighted  mean  of the remaining
 *  quantities, with each quantity's scale factor as  its  weight  (weighted
 *  mean  because  data  from  photographs  with  longer  exposure  times is
 *  generally more reliable than data from photographs with  short  exposure
 *  times).
 *
 *  Arguments:
 *    ** out, in2D, combine_count, chunk_count, sigma_lower, sigma_upper
 *  Same as in clipped_mean_chunk_m256
 *    ** scaled_scratch
 *  Array of [combine_count] __m256 vectors for temporary storage
 *    ** scale_factors
 *  Array of [combine_count] floats used for  scaling  (divide  x  by  scale
 *  factor  to get value for sigma clipping). scale_factors[i] is the factor
 *  for data from the ith array (chunk[i]).
 *    ** recip_factors
 *  Array of [combine_count] floats that are reciprocals of  the  values  in
 *  scale_factors. recip_factors[i] = 1 / scale_factors[i]. Even though it's
 *  slightly less  precise,  we  multiply  by  the  reciprocal  rather  than
 *  dividing  by  the  scale  factor  in  order  to scale quantities because
 *  division is just too darn slow.
 */
static void scaled_mean_chunk_m256(
    __m256* out,
    __m256 const* in2D,
    size_t combine_count,
    size_t chunk_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter,
    __m256* scaled_scratch,
    float const* scale_factors,
    float const* recip_factors
) {
    assert(chunk_count >= 1);
    assert(combine_count >= 1);
    assert(combine_count <= max_combine_count);

    __m256 const zero = _mm256_setzero_ps();

    for (size_t c = 0; c < chunk_count; ++c) {
        __m256 const* const chunk = in2D + c*combine_count;

        // Store the scaled numbers in scaled_scratch.
        // Each vector in a chunk corresponds to 8 entries from a single
        // array, so just divide vector number i by scale factor number i.
        for (size_t i = 0; i < combine_count; ++i) {
            __m256 const recip_vec = _mm256_broadcast_ss(recip_factors + i);
            scaled_scratch[i] = _mm256_mul_ps(recip_vec, chunk[i]);
        }

        // Get the clipping bounds based on the scaled quantities.
        struct ClipBoundsM256 bounds = clipped_mean_m256(
            scaled_scratch, combine_count, sigma_lower, sigma_upper, max_iter
        ).bounds;

        // Now that we have the bounds for the scaled quantities, use them
        // to find the weighted mean of the scaled quantities.
        // This is done by by dividing the sum of the original, unscaled
        // quantities that were not clipped out by the sum of the scale
        // factors of the quantities that were not clipped out.
        // We have to check the scaled quantities to see if a number was
        // clipped out. The method for calculating the weighted mean works:
        //
        // Let s1 and s2 be the scaled quantities, and w1, w2 their weights.
        // The weighted mean of s1 and s2 is:
        //      WeightedMean = (s1*w1 + s2*w2) / (w1+w2)
        // But the weights are the scale factors, so, letting x1, x2 be the
        // original, unscaled values, s1 = x1/w1 and s2 = x2/w2, so
        //      WeightedMean = ((x1/w1)*w1 + (x2/w2)*x2) / (w1+w2)
        //      WeightedMean = (x1+x2) / (w1+w2)
        __m256 qty_sum = zero, wt_sum = zero;
        for (size_t i = 0; i < combine_count; ++i) {
            __m256 const mask = sigma_mask(scaled_scratch[i], bounds);
            __m256 const array_weight = _mm256_broadcast_ss(scale_factors + i);
            __m256 const masked_qty = _mm256_blendv_ps(chunk[i], zero, mask);
            __m256 const masked_wt = _mm256_blendv_ps(array_weight, zero, mask);

            qty_sum = _mm256_add_ps(qty_sum, masked_qty);
            wt_sum = _mm256_add_ps(wt_sum, masked_wt);
        }

        out[c] = _mm256_div_ps(qty_sum, wt_sum);
    }
}

/*  Implement the mean and clipped mean loop  function,  destructor  (either
 *  free,  or  a  no-op),  user  data structure, and MediocreFunctor factory
 *  function.
 */
struct arguments {
    double sigma_lower;
    double sigma_upper;
    size_t max_iter;
};

static int clipped_loop_function(
    MediocreFunctorControl* control,
    void const* user_data,
    MediocreDimension maximum_request
) {
    struct arguments* arguments_ptr = (struct arguments*)user_data;
    (void)maximum_request;

    const __m256d sigma_lower = _mm256_set1_pd(arguments_ptr->sigma_lower);
    const __m256d sigma_upper = _mm256_set1_pd(arguments_ptr->sigma_upper);
    const size_t max_iter = arguments_ptr->max_iter;

    const bool use_exo = max_iter == 0;

    MediocreFunctorCommand command;

    MEDIOCRE_FUNCTOR_LOOP(command, control) {
        // Divide the requested width by 8 (rounded up) to get the chunk count.
        size_t chunk_count = (command.dimension.width + 7) / 8;

        __m256* temp_output = mediocre_functor_aligned_temp(command, control);

        if (temp_output == NULL) {
            perror("mediocre_clipped_mean_functor\n"
                "could not allocated temp_output");
            return errno == 0 ? -1 : errno;
        } else if (command.dimension.combine_count > max_combine_count) {
            fprintf(stderr, "mediocre_clipped_mean_functor\n"
                "too many arrays to be combined [%zi > %zi]\n",
                command.dimension.combine_count, max_combine_count
            );
            return E2BIG;
        } else if (use_exo) {
            if (max_iter == 0) {
                float combine_count_f32 = command.dimension.combine_count;
                exo_mean_chunk_m256(0, command.dimension.combine_count,
                                    &combine_count_f32,
                                    chunk_count,
                                    (float*)temp_output,
                                    (const float*)command.input_chunks);
            }
            else {
                double sigma_lower_64 = arguments_ptr->sigma_lower;
                double sigma_upper_64 = arguments_ptr->sigma_upper;
                exo_clipped_mean_chunk_m256(
                        0,
                        command.dimension.combine_count,
                        chunk_count,
                        (float*)temp_output,
                        (const float*)command.input_chunks,
                        &sigma_lower_64, &sigma_upper_64, max_iter);
            }
        }
        else {
            clipped_mean_chunk_m256(
                temp_output,
                command.input_chunks,
                command.dimension.combine_count,
                chunk_count,
                sigma_lower,
                sigma_upper,
                max_iter
            );
        }
        mediocre_functor_write_temp(command, temp_output);
    }

    return 0;
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

    result.loop_function = clipped_loop_function;
    result.destructor = no_op;
    result.user_data = &no_sigma_clipping;
    result.nonzero_error = 0;

    return result;
}

MediocreFunctor mediocre_clipped_mean_functor2(
    double sigma_lower, double sigma_upper, size_t max_iter
) {
    MediocreFunctor result;
    result.loop_function = clipped_loop_function;
    result.destructor = free;
    result.user_data = NULL;

    if (sigma_lower < 1.0) {
        fprintf(stderr,
            "mediocre_clipped_mean_functor: sigma_lower must be at least 1.\n");
        result.nonzero_error = ERANGE;
        return result;
    } else if (sigma_upper < 1.0) {
        fprintf(stderr,
            "mediocre_clipped_mean_functor: sigma_upper must be at least 1.\n");
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

/*  Implement the scaled  mean  loop  function,  user  data  structure,  and
 *  MediocreFunctor factory.
 */
struct scaled_arguments {
    double sigma_lower;
    double sigma_upper;
    size_t max_iter;
    size_t combine_count;
    float const* scale_factors;
    float const* recip_factors;
};

static int scaled_loop_function(
    MediocreFunctorControl* control,
    void const* user_data,
    MediocreDimension maximum_request
) {
    struct scaled_arguments* args = (struct scaled_arguments*)user_data;
    if (args->combine_count != maximum_request.combine_count) {
        fprintf(stderr, "mediocre_scaled_mean_functor intended for combining\n"
            "%zi arrays but asked to combine %zi arrays.\n",
            args->combine_count, maximum_request.combine_count
        );
        return EINVAL;
    }

    void* scratch_pv = NULL;
    errno = posix_memalign(
        &scratch_pv,
        sizeof(__m256),
        maximum_request.combine_count * sizeof(__m256)
    );

    if (errno != 0) {
        perror("mediocre_clipped_mean_functor could not allocate memory");
        return (errno == 0 ? -1 : errno);
    }

    __m256* scratch = (__m256*)scratch_pv;
    __m256d sigma_lower = _mm256_broadcast_sd(&args->sigma_lower);
    __m256d sigma_upper = _mm256_broadcast_sd(&args->sigma_upper);
    size_t const max_iter = args->max_iter;
    float const* scale_factors = args->scale_factors;
    float const* recip_factors = args->recip_factors;

    MediocreFunctorCommand command;

    int error_code = 0;

    MEDIOCRE_FUNCTOR_LOOP(command, control) {
        // Divide the requested width by 8 (rounded up) to get the chunk count.
        size_t chunk_count = (command.dimension.width + 7) / 8;

        __m256* temp_output = mediocre_functor_aligned_temp(command, control);

        if (temp_output == NULL) {
            perror("mediocre_scaled_mean_functor\n"
                "could not allocated temp_output");
            error_code = errno;
            break;
        } else if (command.dimension.combine_count > max_combine_count) {
            fprintf(stderr, "mediocre_scaled_mean_functor\n"
                "too many arrays to be combined [%zi > %zi]\n",
                command.dimension.combine_count, max_combine_count
            );
            error_code = E2BIG;
            break;
        } else {
            scaled_mean_chunk_m256(
                temp_output,
                command.input_chunks,
                command.dimension.combine_count,
                chunk_count,
                sigma_lower,
                sigma_upper,
                max_iter,
                scratch,
                scale_factors,
                recip_factors
            );

            mediocre_functor_write_temp(command, temp_output);
        }
    }

    free(scratch);
    return error_code;
}

MediocreFunctor mediocre_scaled_mean_functor2(
    float const* scale_factors,
    size_t scale_count,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    // Initialize the MediocreFunctor result (with NULL for user data for now)
    // and check the arguments for illegal values.
    MediocreFunctor result;
    result.loop_function = scaled_loop_function;
    result.destructor = free;
    result.user_data = NULL;
    result.nonzero_error = 0;

    if (scale_count == 0) {
        fprintf(stderr,
            "mediocre_scaled_mean_functor: scale_count must be nonzero.\n");
        result.nonzero_error = EINVAL;
        return result;
    }
    if (sigma_lower < 1.0) {
        fprintf(stderr,
            "mediocre_scaled_mean_functor: sigma_lower must be at least 1.\n");
        result.nonzero_error = ERANGE;
        return result;
    }
    if (sigma_upper < 1.0) {
        fprintf(stderr,
            "mediocre_scaled_mean_functor: sigma_upper must be at least 1.\n");
        result.nonzero_error = ERANGE;
        return result;
    }

    // We need to allocate user data. This consists of a scaled_arguments struct
    // and two arrays of [scale_count] floats. Allocate all the memory needed
    // using a single malloc call. We'll split up the memory among the struct
    // and the two arrays, and assert that we allocated the right amount.
    const size_t array_bytes = sizeof(float) * scale_count;
    const size_t total_bytes = sizeof(struct scaled_arguments) + 2*array_bytes;

    char* allocated = (char*)malloc(total_bytes);
    char* end = allocated + total_bytes;

    if (allocated == NULL) {
        perror("mediocre_scaled_mean_functor could not allocated memory");
        result.nonzero_error = (errno == 0 ? -1 : errno);
        return result;
    }

    // args is equal to the allocated pointer, and is the user_data pointer,
    // so free (result.destructor) will eventually receive the correct pointer.
    struct scaled_arguments* args = (struct scaled_arguments*)allocated;
    float* scale = (float*)(allocated + sizeof(struct scaled_arguments));
    float* recip = (float*)((char*)scale + array_bytes);
    assert((char*)recip + array_bytes == end);

    // Now everything is allocated. Proceed to initialize args' variables.
    args->sigma_lower = sigma_lower;
    args->sigma_upper = sigma_upper;
    args->max_iter = max_iter;
    args->combine_count = scale_count;
    args->scale_factors = scale;
    args->recip_factors = recip;

    for (size_t i = 0; i < scale_count; ++i) {
        scale[i] = scale_factors[i];
        recip[i] = 1.0f / scale_factors[i];
    }

    result.user_data = args;
    return result;
}
