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

#include "median.h"

#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <immintrin.h>
#include <emmintrin.h>

#include "convert.h"
#include "sigmautil.h"

/*  Sort the numbers within the 8 lanes of the to_sort array[0...count -  1]
 *  of vectors passed in. If it makes more sense, think of it like calling a
 *  scalar array sort function 8 times with a stride of 32 bytes instead  of
 *  4  bytes.  The  scratch  array  is  used  as  temporary  storage for the
 *  mergesort  algorithm.  The  caller  is  responsible  for  ensuring  both
 *  pointers  point  to a suitably (32 byte) aligned array with enough space
 *  for count __m256 vectors each.
 */
void mergesort_m256(__m256* to_sort, size_t count, __m256* scratch);

/*  Function for checking merge precondition: all 8 lanes in  the  array  of
 *  vector_count vectors must have their floats in ascending order.
 */

static int is_sorted_m256(__m256 const* in, size_t vector_count) {
    __m256 bits = _mm256_setzero_ps();
    __m256 previous = in[0];
    for (size_t i = 1; i < vector_count; ++i) {
        __m256 current = in[i];
        bits = _mm256_or_ps(bits, _mm256_cmp_ps(current, previous, _CMP_LT_OQ));
        previous = current;
    }
    return _mm256_movemask_ps(bits) == 0;
}

/*  Calculate the sigma clipped median of groups of floating  point  numbers
 *  with lower and upper sigma bounds passed as specified below.
 *  
 *  Each group of numbers is passed to the function  as  a  lane  of  floats
 *  within an array[0 ... group_size - 1] of __m256 vectors. Since there are
 *  8 lanes within an __m256 vector, 8 groups are passed within  one  array.
 *  These  arrays  are  passed as subarrays[0 ... group_size - 1] within the
 *  in2D array. The in2D array will be used as temporary storage within this
 *  function,  and  will  have  unspecified  value  upon return. The clipped
 *  median of each lane of floats is written to the out array.  Interpreting
 *  the pointers as pointers to float instead of to__m256,
 *      out[8x + y]
 *  corresponds to the clipped median of every 8th float in the range
 *      in2D[8*x*group_size + y ... 8*(x+1)*group_size + y - 8]
 *  (see example below)
 *  
 *    ** out
 *  array [0 ... subarray_count - 1] of __m256
 *    ** in2D
 *  array [0 ... subarray_count * group_size - 1] of __m256
 *  in2D's CONTENTS WILL HAVE UNSPECIFIED VALUE AFTER THE FUNCTION RETURNS.
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
 *    ** scratch
 *  array [0 ... group_size - 1] of __m256 (for temporary storage).
 *  
 *  Example memory layout for group_size = 4, subarray_count = 3 (3 * 8 = 24
 *  groups of 4 floats total). Each of the 4 numbers stored in in2D labelled
 *  with the same character has their clipped median output  to  the  number
 *  with the same label in out.
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
static inline void clipped_median_chunk_m256(
    __m256* out,
    __m256* in2D,
    size_t group_size,
    size_t subarray_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter,
    __m256* scratch
) {
    assert(subarray_count >= 1);
    assert(group_size >= 1);
    assert(group_size <= 0x7FFFFF);
    
    const __m256 zero = _mm256_setzero_ps();
    const __m256 half = _mm256_set1_ps(0.5f);
    const __m256 half_group_size_vector = _mm256_set1_ps(group_size / 2.0f);
    
    for (size_t g = 0; g < subarray_count; ++g) {
        __m256* subarray = in2D + g * group_size;
        
        mergesort_m256(subarray, group_size, scratch);
        assert(is_sorted_m256(subarray, group_size));
        
        __m256 clipped_median = _mm256_add_ps(
            _mm256_mul_ps(half, subarray[group_size/2]),
            _mm256_mul_ps(half, subarray[(group_size+1)/2])
        );
        __m256 previous_count = _mm256_set1_ps(-1.0f);
        __m256 count = _mm256_div_ps(half_group_size_vector, half);
        
        struct ClipBoundsM256 bounds = {
            _mm256_set1_ps(-1.f/0.f), _mm256_set1_ps(1.f/0.f)
        };
        
        for (size_t iter = 0; iter != max_iter; ++iter) {
            bounds = sigma_clip_step(
                subarray,               // data
                group_size,             // vector_count
                bounds,                 // bounds
                clipped_median,         // center
                count,                  // clipped_count
                sigma_lower,            // sigma_lower
                sigma_upper             // sigma_upper
            );
            
            // Recalculate median.
            __m256 median_index = half_group_size_vector;
            count = half_group_size_vector;
            
            for (size_t i = 0; i < group_size; ++i) {
                const __m256 vec = subarray[i];
                
                const __m256 half_if_below = _mm256_blendv_ps(
                    zero, half,
                    _mm256_cmp_ps(vec, bounds.lower, _CMP_LT_OQ)
                );
                const __m256 half_if_above = _mm256_blendv_ps(
                    zero, half,
                    _mm256_cmp_ps(vec, bounds.upper, _CMP_GT_OQ)
                );
                median_index = _mm256_add_ps(median_index, half_if_below);
                median_index = _mm256_sub_ps(median_index, half_if_above);
                
                count = _mm256_sub_ps(count, half_if_below);
                count = _mm256_sub_ps(count, half_if_above);
            }
            count = _mm256_div_ps(count, half);
            
            previous_count = _mm256_cmp_ps(previous_count, count, _CMP_NEQ_OQ);
            if (_mm256_movemask_ps(previous_count) == 0) {
                break;
            }
            previous_count = count;
            
            const __m256i low_index = _mm256_cvtps_epi32(
                _mm256_floor_ps(median_index)
            );
            
            const __m256i high_index = _mm256_cvtps_epi32(
                _mm256_ceil_ps(median_index)
            );
            
            __m256i low_data = _mm256_undefined_ps();
            
            int32_t i0 = _mm256_extract_epi32(low_index, 0);
            int32_t i1 = _mm256_extract_epi32(low_index, 1);
            int32_t i2 = _mm256_extract_epi32(low_index, 2);
            int32_t i3 = _mm256_extract_epi32(low_index, 3);
            int32_t i4 = _mm256_extract_epi32(low_index, 4);
            int32_t i5 = _mm256_extract_epi32(low_index, 5);
            int32_t i6 = _mm256_extract_epi32(low_index, 6);
            int32_t i7 = _mm256_extract_epi32(low_index, 7);
            
            low_data = _mm256_blend_ps(low_data, subarray[i0], 1 << 0);
            low_data = _mm256_blend_ps(low_data, subarray[i1], 1 << 1);
            low_data = _mm256_blend_ps(low_data, subarray[i2], 1 << 2);
            low_data = _mm256_blend_ps(low_data, subarray[i3], 1 << 3);
            low_data = _mm256_blend_ps(low_data, subarray[i4], 1 << 4);
            low_data = _mm256_blend_ps(low_data, subarray[i5], 1 << 5);
            low_data = _mm256_blend_ps(low_data, subarray[i6], 1 << 6);
            low_data = _mm256_blend_ps(low_data, subarray[i7], 1 << 7);
            
            i0 = _mm256_extract_epi32(high_index, 0);
            i1 = _mm256_extract_epi32(high_index, 1);
            i2 = _mm256_extract_epi32(high_index, 2);
            i3 = _mm256_extract_epi32(high_index, 3);
            i4 = _mm256_extract_epi32(high_index, 4);
            i5 = _mm256_extract_epi32(high_index, 5);
            i6 = _mm256_extract_epi32(high_index, 6);
            i7 = _mm256_extract_epi32(high_index, 7);
            
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i0], 1);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i1], 2);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i2], 4);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i3], 8);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i4], 16);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i5], 32);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i6], 64);
            clipped_median = _mm256_blend_ps(clipped_median, subarray[i7], 128);
            
            clipped_median = _mm256_add_ps(clipped_median, low_data);
            clipped_median = _mm256_mul_ps(half, clipped_median);
        }
        out[g] = clipped_median;
    }
    
    // Overwrite the input array in debug mode to emphasize the point
    // that they are consumed as temporary storage by the function.
    assert(memset(in2D, 42, sizeof(__m256) * group_size * subarray_count));
}

int mediocre_clipped_median_u16(
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
        sizeof(__m256), (2 + array_count) * chunk_vector_count * sizeof(__m256)
    );
    
    if (allocated == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    
    __m256* out_chunk = allocated;
    __m256* scratch = allocated + chunk_vector_count;
    __m256* in2D = allocated + 2 * chunk_vector_count;
    
    for (size_t c = 0; c < chunk_count; ++c) {
        for (size_t a = 0; a < array_count; ++a) {
            load_m256_from_u16_stride(
                in2D + a,
                data[a] + chunk_item_count*c,
                chunk_item_count,               // item_count
                array_count                     // stride
            );
            clipped_median_chunk_m256(
                out_chunk, in2D,
                array_count, chunk_vector_count,
                sigma_lower_vec, sigma_upper_vec,
                max_iter, scratch
            );
        }
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
                remainder,      // item_count
                array_count     // stride
            );
        }
        clipped_median_chunk_m256(
            out_chunk, in2D,
            array_count, remainder_vector_count,
            sigma_lower_vec, sigma_upper_vec,
            max_iter, scratch
        );
        uint16_t* final_output = out + chunk_item_count*chunk_count;
        err |= load_u16_from_m256(final_output, out_chunk, remainder);
    }
    free(allocated);
    
    return err;
}

/**************************************************************************
 *                                                                        *
 *                           THE END (really)                             *
 *                                                                        *
 **************************************************************************/










// Have you ever read "The Ones Who Walk Away from Omelas"?

#define BUBBLE_UPWARDS_2(a, b, temporary) \
    temporary = a; \
    a = _mm256_min_ps(a, b); \
    b = _mm256_max_ps(temporary, b)

#define BUBBLE_UPWARDS_3(A, B, C, temporary) \
    BUBBLE_UPWARDS_2(A, B, temporary); \
    BUBBLE_UPWARDS_2(B, C, temporary)

#define BUBBLE_UPWARDS_4(A, B, C, D, temporary) \
    BUBBLE_UPWARDS_3(A, B, C, temporary); \
    BUBBLE_UPWARDS_2(C, D, temporary)

#define BUBBLE_UPWARDS_5(A, B, C, D, E, temporary) \
    BUBBLE_UPWARDS_4(A, B, C, D, temporary); \
    BUBBLE_UPWARDS_2(D, E, temporary)

#define BUBBLE_UPWARDS_6(A, B, C, D, E, F, temporary) \
    BUBBLE_UPWARDS_5(A, B, C, D, E, temporary); \
    BUBBLE_UPWARDS_2(E, F, temporary)

#define BUBBLE_UPWARDS_7(A, B, C, D, E, F, G, temporary) \
    BUBBLE_UPWARDS_6(A, B, C, D, E, F, temporary); \
    BUBBLE_UPWARDS_2(F, G, temporary)

#define BUBBLE_UPWARDS_8(A, B, C, D, E, F, G, H, temporary) \
    BUBBLE_UPWARDS_7(A, B, C, D, E, F, G, temporary); \
    BUBBLE_UPWARDS_2(G, H, temporary)

#define BUBBLE_UPWARDS_9(A, B, C, D, E, F, G, H, I, temporary) \
    BUBBLE_UPWARDS_8(A, B, C, D, E, F, G, H, temporary); \
    BUBBLE_UPWARDS_2(H, I, temporary)

#define BUBBLE_UPWARDS_10(A, B, C, D, E, F, G, H, I, J, temporary) \
    BUBBLE_UPWARDS_9(A, B, C, D, E, F, G, H, I, temporary); \
    BUBBLE_UPWARDS_2(I, J, temporary)

#define BUBBLE_UPWARDS_11(A, B, C, D, E, F, G, H, I, J, K, temporary) \
    BUBBLE_UPWARDS_10(A, B, C, D, E, F, G, H, I, J, temporary); \
    BUBBLE_UPWARDS_2(J, K, temporary)

#define BUBBLE_UPWARDS_12(A, B, C, D, E, F, G, H, I, J, K, L, temporary) \
    BUBBLE_UPWARDS_11(A, B, C, D, E, F, G, H, I, J, K, temporary); \
    BUBBLE_UPWARDS_2(K, L, temporary)

#define BUBBLE_UPWARDS_13(A, B, C, D, E, F, G, H, I, J, K, L, M, temporary) \
    BUBBLE_UPWARDS_12(A, B, C, D, E, F, G, H, I, J, K, L, temporary); \
    BUBBLE_UPWARDS_2(L, M, temporary)

#define BUBBLE_UPWARDS_14(A, B, C, D, E, F, G, H, I, J, K, L, M, N, temporary) \
    BUBBLE_UPWARDS_13(A, B, C, D, E, F, G, H, I, J, K, L, M, temporary); \
    BUBBLE_UPWARDS_2(M, N, temporary)

#define BUBBLE_UPWARDS_15(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, t) \
    BUBBLE_UPWARDS_14(A, B, C, D, E, F, G, H, I, J, K, L, M, N, t); \
    BUBBLE_UPWARDS_2(N, O, t)

//  Sort 8 lanes of count vectors using the most advanced sorting
//  algorithm known to science: THE BUBBLE SORT!
static void bubble_sort_m256(__m256* array, size_t count) {
    __m256 a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, tmp;
    switch (count) {
        case 0: case 1:
            return;
        case 15:    o = array[14];
        case 14:    n = array[13];
        default:
        case 13:    m = array[12];
        case 12:    l = array[11];
        case 11:    k = array[10];
        case 10:    j = array[9];
        case 9:     i = array[8];
        case 8:     h = array[7];
        case 7:     g = array[6];
        case 6:     f = array[5];
        case 5:     e = array[4];
        case 4:     d = array[3];
        case 3:     c = array[2];
        case 2:     b = array[1];
                    a = array[0];
    }
    switch (count) {
        default:
            for ( ; count != 14; --count) {
                BUBBLE_UPWARDS_13(a, b, c, d, e, f, g, h, i, j, k, l, m, tmp);
                
                n = array[13];
                BUBBLE_UPWARDS_2(m, n, tmp);
                
                size_t i = 14;
                while (1) {
                    o = array[i];
                    BUBBLE_UPWARDS_2(n, o, tmp);
                    array[i-1] = n;
                    if (++i == count) {
                        array[i-1] = o;
                        break;
                    }
                    
                    n = array[i];
                    BUBBLE_UPWARDS_2(o, n, tmp);
                    array[i-1] = o;
                    if (++i == count) {
                        array[i-1] = n;
                        break;
                    }
                }
            }
            n = array[13];
            o = array[14];
        case 15:
            BUBBLE_UPWARDS_15(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, tmp);
            array[14] = o;
        case 14:
            BUBBLE_UPWARDS_14(a, b, c, d, e, f, g, h, i, j, k, l, m, n, tmp);
            array[13] = n;
        case 13: 
            BUBBLE_UPWARDS_13(a, b, c, d, e, f, g, h, i, j, k, l, m, tmp);
            array[12] = m;
        case 12:
            BUBBLE_UPWARDS_12(a, b, c, d, e, f, g, h, i, j, k, l, tmp);
            array[11] = l;
        case 11:
            BUBBLE_UPWARDS_11(a, b, c, d, e, f, g, h, i, j, k, tmp);
            array[10] = k;
        case 10:
            BUBBLE_UPWARDS_10(a, b, c, d, e, f, g, h, i, j, tmp);
            array[9] = j;
        case 9:
            BUBBLE_UPWARDS_9(a, b, c, d, e, f, g, h, i, tmp);
            array[8] = i;
        case 8:
            BUBBLE_UPWARDS_8(a, b, c, d, e, f, g, h, tmp);
            array[7] = h;
        case 7:
            BUBBLE_UPWARDS_7(a, b, c, d, e, f, g, tmp);
            array[6] = g;
        case 6:
            BUBBLE_UPWARDS_6(a, b, c, d, e, f, tmp);
            array[5] = f;
        case 5:
            BUBBLE_UPWARDS_5(a, b, c, d, e, tmp);
            array[4] = e;
        case 4:
            BUBBLE_UPWARDS_4(a, b, c, d, tmp);
            array[3] = d;
        case 3:
            BUBBLE_UPWARDS_3(a, b, c, tmp);
            array[2] = c;
        case 2:
            BUBBLE_UPWARDS_2(a, b, tmp);
            array[1] = b;
        case 1:
            array[0] = a;
        case 0:
            break;
    }
}

/*  Merge the 8 lanes  of  floats  in  the  input  array,  which  should  be
 *  partitioned into two parts, one l_size vectors long and the other r_size
 *  vectors long, both of which have all 8  lanes  of  floats  in  ascending
 *  order.  The output is written into the output array, which must be of at
 *  least size l_size + r_size and must not overlap with  the  input  array.
 *  l_size + r_size must not exceed 16777215.
 *  
 *  The implementation of this function is very difficult to explain.
 */
static void merge_m256(
    __m256* out, __m256 const* in, size_t l_size, size_t r_size
) {
    size_t total_size = l_size + r_size;
    if (l_size == 0 || r_size == 0) {
        for (size_t i = 0; i < total_size; ++i) {
            out[i] = in[i];
        }
        return;
    }
    // We will be using single-precision floats to represent the array
    // index, so make sure it's small enough to fit with full precision.
    if ((l_size + r_size) & ~0xffffff) {
        fprintf(stderr, "mediocre internal error: merge_m256\n");
        abort();
    }
    assert(is_sorted_m256(in, l_size));
    assert(is_sorted_m256(in + l_size, r_size));
    
    // The input and output pointers must not overlap.
    assert((out + total_size < in) | (in + total_size < out));
    
    __m256 const one = _mm256_set1_ps(1.0f);
    __m256 const end_l = _mm256_set1_ps((float)(int)l_size);
    __m256 const end_r = _mm256_set1_ps((float)(int)total_size);
    
    __m256 old_data = in[0];
    __m256 new_data = in[l_size];
    __m256 old_index = _mm256_setzero_ps();
    __m256 inc_old_index = one;
    __m256 new_index = end_l;
    __m256 inc_new_index = _mm256_add_ps(one, end_l);
    __m256 empty_partition_mask = _mm256_setzero_ps();
    __m256 mask = _mm256_cmp_ps(old_data, new_data, _CMP_GE_OQ);
    
    out[0] = _mm256_min_ps(old_data, new_data);
    old_data = _mm256_max_ps(old_data, new_data);
    old_index = _mm256_blendv_ps(new_index, old_index, mask);
    new_index = _mm256_blendv_ps(inc_old_index, inc_new_index, mask);
    
    for (size_t i = 1; i != total_size; ++i) {
        __m256 const at_end = _mm256_or_ps(
            _mm256_cmp_ps(end_r, new_index, _CMP_EQ_OQ),
            _mm256_cmp_ps(end_l, new_index, _CMP_EQ_OQ)
        );
        empty_partition_mask = _mm256_or_ps(empty_partition_mask, at_end);
        new_index = _mm256_blendv_ps(new_index, old_index, at_end);
        
        inc_old_index = _mm256_add_ps(one, old_index);
        inc_new_index = _mm256_add_ps(one, new_index);
        
        // This part is slow :(
        __m256i new_index_i = _mm256_cvtps_epi32(new_index);
        int32_t i0 = _mm256_extract_epi32(new_index_i, 0);
        int32_t i1 = _mm256_extract_epi32(new_index_i, 1);
        int32_t i2 = _mm256_extract_epi32(new_index_i, 2);
        int32_t i3 = _mm256_extract_epi32(new_index_i, 3);
        int32_t i4 = _mm256_extract_epi32(new_index_i, 4);
        int32_t i5 = _mm256_extract_epi32(new_index_i, 5);
        int32_t i6 = _mm256_extract_epi32(new_index_i, 6);
        int32_t i7 = _mm256_extract_epi32(new_index_i, 7);
        
        new_data = _mm256_blend_ps(new_data, in[i0], 1 << 0);
        new_data = _mm256_blend_ps(new_data, in[i1], 1 << 1);
        new_data = _mm256_blend_ps(new_data, in[i2], 1 << 2);
        new_data = _mm256_blend_ps(new_data, in[i3], 1 << 3);
        new_data = _mm256_blend_ps(new_data, in[i4], 1 << 4);
        new_data = _mm256_blend_ps(new_data, in[i5], 1 << 5);
        new_data = _mm256_blend_ps(new_data, in[i6], 1 << 6);
        new_data = _mm256_blend_ps(new_data, in[i7], 1 << 7);
        
        mask = _mm256_cmp_ps(old_data, new_data, _CMP_GT_OQ);
        mask = _mm256_or_ps(mask, empty_partition_mask);
        
        // It really bothers me how blendv reads in the exact opposite order
        // as a ternary statement. condition ? if_true : if_false becomes
        // blendv(if_false, if_true, condition). RRRAAUURGH.
        out[i] = _mm256_blendv_ps(old_data, new_data, mask);
        old_data = _mm256_blendv_ps(new_data, old_data, mask);
        old_index = _mm256_blendv_ps(new_index, old_index, mask);
        new_index = _mm256_blendv_ps(inc_old_index, inc_new_index, mask);
    }
}

/*  Sort the numbers within the 8 lanes of the to_sort array[0...count -  1]
 *  of vectors passed in. If it makes more sense, think of it like calling a
 *  scalar array sort function 8 times with a stride of 32 bytes instead  of
 *  4  bytes.  The  scratch  array  is  used  as  temporary  storage for the
 *  mergesort  algorithm.  The  caller  is  responsible  for  ensuring  both
 *  pointers  point  to a suitably (32 byte) aligned array with enough space
 *  for count __m256 vectors each.
 *       -> This comment is duplicated in the forward declaration. <-
 */
void mergesort_m256(__m256* to_sort, size_t count, __m256* scratch) {
    // The first step is to bubble sort short (32) groups of vectors.    
    // After that, we will merge those short runs of sorted vectors
    // into larger runs until the run length equals the array length.
    // Bubble sort runs faster than mergesort for various reasons for short
    // inputs (chiefly due to memory vs register usage. My insane bubble
    // sort function is ugly and hidden at the bottom of this file for a
    // reason), so we use it as the first step in sorting. My quick-and-
    // dirty experiments on a laptop seemed to show that 32 or 64 was the
    // sweet spot for the initial bubble sort. 16 was a bit slower.
    size_t part_size = 32;
    size_t remainder = count % part_size;
    
    bubble_sort_m256(to_sort, remainder);
    for (size_t i = remainder; i < count; i += part_size) {
        bubble_sort_m256(to_sort + i, part_size);
    }
    
    __m256* dest = scratch;
    __m256* source = to_sort;
    
    for ( ;part_size < count; part_size *= 2) {
        size_t l_remainder = remainder;
        remainder = count % (2 * part_size);
        size_t r_remainder = remainder - l_remainder;
        
        // printf("[0 %zu %zu]\n", l_remainder, l_remainder + r_remainder);
        merge_m256(dest, source, l_remainder, r_remainder);
        
        for (size_t i = remainder; i < count; i += 2*part_size) {
            // printf("[%zu %zu %zu]\n", i, i + part_size, i + part_size * 2);
            merge_m256(dest + i, source + i, part_size, part_size);
        }
        scratch = dest;
        dest = source;
        source = scratch;
    }
    if (source != to_sort) {
        memcpy(to_sort, source, count * sizeof(__m256));
    }
}

