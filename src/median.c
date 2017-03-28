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

/*  Sort the numbers within the 8 lanes of the to_sort array[0 ...  count-1]
 *  of vectors passed in. If it makes more sense, think of it like calling a
 *  scalar array sort function 8 times with a stride of 32 bytes instead  of
 *  4  bytes.  The  scratch  array  is  used  as  temporary  storage for the
 *  mergesort  algorithm.  The  caller  is  responsible  for  ensuring  both
 *  pointers  point  to a suitably (32 byte) aligned array with enough space
 *  for count __m256 vectors each.
 */
static void mergesort_m256(__m256* to_sort, size_t count, __m256* scratch);

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
    assert(group_size <= 0x7FFFF0);
    
    const __m256 zero = _mm256_setzero_ps();
    const __m256 half = _mm256_set1_ps(0.5f);
    const __m256 one  = _mm256_set1_ps(1.0f);
    
    // More about this later.
    const __m256 initial_counter = _mm256_set1_ps(group_size * 0.5f + 1.0f);
    
    for (size_t g = 0; g < subarray_count; ++g) {
        __m256* subarray = in2D + g * group_size;
        
        // We will sort the subarray and work with only the sorted numbers.
        // Selection algorithm is neat but not easy to paralellize, so we sort.
        mergesort_m256(subarray, group_size, scratch);
        assert(is_sorted_m256(subarray, group_size));
        
        // The count of numbers in each lane that are within the clipping range.
        __m256 clipped_count = _mm256_set1_ps((float)group_size);
        
        // That same quantity in the previous iteration. If the counts for the
        // previous iteration of sigma clipping are the same as the counts for
        // this iteration, then we can finish iteration early.
        __m256 previous_count = clipped_count;
        
        // Calculate the median of all of the numbers.
        __m256 clipped_median = _mm256_add_ps(
            _mm256_mul_ps(half, subarray[(group_size-1)/2]),
            _mm256_mul_ps(half, subarray[group_size/2])
        );
        
        struct ClipBoundsM256 bounds = {
            _mm256_set1_ps(-1.f/0.f), _mm256_set1_ps(1.f/0.f)
        };        
      /*  In each iteration, calculate the median of the  numbers  within  the
       *  recalculated  clipping  bounds.  The  amazing, enigmatic, terrifying
       *  counter variable has a lot to do with this recalculation.
       *  
       *  Each lane of the counter  variable  indirectly  encodes  information
       *  about  where  the  median  of  the  in-range  numbers  is within the
       *  corresponding lane of the sorted list of all numbers. In the  second
       *  loop,  where  we iterate backwards through the subarray, the counter
       *  variable sort of stores the remaining distance (plus half)  to  each
       *  median  in  each  lane,  assuming  that  none  of the numbers in the
       *  subarray are above the clipping range. Each iteration the  lanes  of
       *  the  counter are decremented by one because in each iteration we get
       *  one unit closer to the median. If a lane of the counter is one-half,
       *  then  we reached the correct median position for an odd-length list,
       *  and we store the number at that position as the  new  median.  If  a
       *  lane of the counter is one or zero, then we are a half-unit above or
       *  below the median's position, and we store half  of  each  position's
       *  value  such  that  the sum of those values is the median (average of
       *  the numbers on the two sides of the median position).
       *  
       *  Of course, the assumption that all of the numbers we  visit  in  the
       *  backwards  iteration will be in bounds is false (more precisely, the
       *  assumption that none will be above the upper bound is false). So, if
       *  the  number at the position being visited in the backwards iteration
       *  is out-of-range, we decrement the corresponding lane of the  counter
       *  by only a half instead of one, since although we got one unit closer
       *  to the median, we also discover that  the  actual  position  of  the
       *  median  is  one-half of a unit farther away than we assumed (because
       *  the size of the list of in-bounds numbers shrank by one).
       *  
       *  To set up the counter, we assume that the median  is  at  the  exact
       *  halfway point of the subarray, initializing the value of the counter
       *  to  one  plus  half  of  the  length  of  the  subarray  using   the
       *  initial_counter  variable,  then iterate forwards from the beginning
       *  and decrement by half each time we see a number that  is  below  the
       *  clipping  range  (indicating  that  the  position of the median is a
       *  half-unit closer to the end of the subarray than we had assumed).
       */
        for (size_t iter = 0; iter != max_iter; ++iter) {
            bounds = get_new_clip_bounds(
                subarray,               // data
                group_size,             // vector_count
                bounds,                 // bounds
                clipped_median,         // center
                clipped_count,          // clipped_count
                sigma_lower,            // sigma_lower
                sigma_upper             // sigma_upper
            );
            
            __m256 counter = initial_counter;
            clipped_count = _mm256_set1_ps((float)group_size);
            
            size_t i = 0, not_finished = 1;
            
            // Forwards iteration loop. Exit once none of the numbers in any
            // of the lanes are below the lower bound of the clipping range.
            while (not_finished && i < group_size) {
                __m256 tmp = subarray[i++];
                tmp = _mm256_cmp_ps(tmp, bounds.lower, _CMP_LT_OQ);
                not_finished = _mm256_movemask_ps(tmp);
                
                clipped_count = _mm256_sub_ps(clipped_count,
                    _mm256_blendv_ps(zero, one, tmp)
                );
                tmp = _mm256_blendv_ps(zero, half, tmp);
                counter = _mm256_sub_ps(counter, tmp);
            }
            
            // Backwards iteration loop. Exit once all of the medians (or the
            // 2 half-terms of a median of an even length list) are collected.
            i = group_size;
            clipped_median = _mm256_setzero_ps();
            int clipped_count_changed;
            do {
                __m256 const data = subarray[--i];
                __m256 mask = _mm256_cmp_ps(data, bounds.upper, _CMP_GT_OQ);
                
                counter = _mm256_sub_ps(counter,
                    _mm256_blendv_ps(one, half, mask)
                );
                clipped_count = _mm256_sub_ps(clipped_count,
                    _mm256_blendv_ps(zero, one, mask)
                );
                
                clipped_count_changed = _mm256_movemask_ps(
                    _mm256_cmp_ps(clipped_count, previous_count, _CMP_NEQ_OQ)
                );
                
                // If there is at least one non-negative number in counter,
                // then there are still some medians that have not been found.
                not_finished = _mm256_movemask_ps(counter) == 0xFF ? 0 : -1;
                
                __m256 multiplier = _mm256_blendv_ps(
                    zero, half, _mm256_cmp_ps(counter, one, _CMP_EQ_OQ)
                );
                multiplier = _mm256_or_ps(multiplier,
                    _mm256_blendv_ps(
                        zero, one, _mm256_cmp_ps(counter, half, _CMP_EQ_OQ)
                    )
                );
                multiplier = _mm256_or_ps(multiplier,
                    _mm256_blendv_ps(
                        zero, half, _mm256_cmp_ps(counter, zero, _CMP_EQ_OQ)
                    )
                );
                clipped_median = _mm256_add_ps(clipped_median,
                    _mm256_mul_ps(multiplier, data)
                );
            } while ((i & not_finished));
            
            // Do the comparisons and possible early exit for the clipped count.
            if (!clipped_count_changed) break;
            previous_count = clipped_count;
        }
        out[g] = clipped_median;
    }
    
    // Overwrite the input array in debug mode to emphasize the point
    // that they are consumed as temporary storage by the function.
    assert(memset(in2D, 42, sizeof(__m256) * group_size * subarray_count));
}
/*
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
        }
        clipped_median_chunk_m256(
            out_chunk, in2D,
            array_count, chunk_vector_count,
            sigma_lower_vec, sigma_upper_vec,
            max_iter, scratch
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
*/
#include "chunkutil.h" // XXX move this to the top later.

int mediocre_clipped_median_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count,
    double sigma_lower,
    double sigma_upper, 
    size_t max_iter
) {
    return process_chunks(
        out, 116,
        data, 116,
        clipped_median_chunk_m256,
        array_count,
        bin_count,
        sigma_lower,
        sigma_upper,
        max_iter
    );
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

/*  Sort 8 lanes of count vectors using the most advanced sorting  algorithm
 *  known  to science: THE BUBBLE SORT! We speed up this tired old algorithm
 *  a bit by storing the lowest 13 to 15 vectors within registers.
 */
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
    assert((out + total_size <= in) | (in + total_size <= out));
    
    /*  Let me give a nine minute dump of my  brain's  contents.  The  basic
     *  idea  of  merging  two lists is to pick survivors. Each iteration we
     *  have two choices of numbers from the two partitions  to  merge,  and
     *  only  write  out  one number. The bigger number is the survivor, and
     *  will be kept for the next iteration. The smaller number  loses,  and
     *  gets  written  as  output, and the next number in the partition that
     *  the loser comes from will replace it in the next iteration. In  this
     *  algorithm,  the old_data and old_index variables store the value and
     *  position of the surviving  data  in  each  lane.  The  new_data  and
     *  new_index  variables  store the value and position of the new number
     *  being considered in an iteration. We take this  perspective  of  old
     *  and  new indexes rather than an index for one partition and an index
     *  for the oher partition (as used by most merge algorithms) so that we
     *  only  have  to reload new data from memory. The survivor will always
     *  be known  and  can  be  reused  from  registers  from  the  previous
     *  iteration.
     *  
     *  Anyway, at the end of each iteration we implement all of  the  logic
     *  of  the  surviving  numbers using some mask logic. For each lane, if
     *  the survivor from the previous iteration has  survived  again  (i.e.
     *  old_data  is  greater  than  new_data),  then  we  keep old_data and
     *  old_index as-is and only increment the new_index.  If  the  survivor
     *  from  the  last iteration was instead written to the output, then we
     *  move the new_data  and  new_index  to  the  old_data  and  old_index
     *  (because the new data is the new survivor), and set the new_index to
     *  one more than the old value of old_index (since the  new  data  will
     *  now  come  from  the  partition that the old survivor came from). In
     *  each case, the new_data is then loaded from memory then based on the
     *  new_index.
     *  
     *  Except, there is one problem. It is not always true that we have two
     *  choices  and  only one output each iteration. Towards the end one of
     *  the partitions will run out of numbers, so we really only  have  one
     *  choice.  This is encoded using the empty_partition_mask. If it's set
     *  for a lane, in that lane the new_data will always be written and the
     *  new_index  will  always be incremented by that lane, so in effect we
     *  are just copying data from the remaining partition without  thinking
     *  about  it.  In  a  lane's transition from the two-choice mode to the
     *  one-choice mode, we copy that  same  lane's  data  in  old_data  and
     *  old_index  to  new_data  and  new_index,  since  the  new_index  and
     *  new_data variables is where the data  for  the  remaining  partition
     *  will  be iterated over but the remaining partition must by necessity
     *  be the one  that  the  surviving  data  came  from  (pointed  to  by
     *  old_index). This is implemented using the at_end variable, which has
     *  false in all of its lanes in every iteration in the  two-choice  and
     *  one-choice  modes,  and  true in a lane only in the one iteration of
     *  transition between the two modes.
     */
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

/*  Sort the numbers within the 8 lanes of the to_sort array[0 ...  count-1]
 *  of vectors passed in. If it makes more sense, think of it like calling a
 *  scalar array sort function 8 times with a stride of 32 bytes instead  of
 *  4  bytes.  The  scratch  array  is  used  as  temporary  storage for the
 *  mergesort  algorithm.  The  caller  is  responsible  for  ensuring  both
 *  pointers  point  to a suitably (32 byte) aligned array with enough space
 *  for count __m256 vectors each.
 *       -> This comment is duplicated in the forward declaration. <-
 */
static void mergesort_m256(__m256* to_sort, size_t count, __m256* scratch) {
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
        
        merge_m256(dest, source, l_remainder, r_remainder);
        
        for (size_t i = remainder; i < count; i += 2*part_size) {
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

