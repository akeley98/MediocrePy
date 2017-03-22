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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <immintrin.h>
#include <emmintrin.h>

#include "sigmautil.h"

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

#define BUBBLE_UPWARDS_16(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, t) \
    BUBBLE_UPWARDS_15(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, t); \
    BUBBLE_UPWARDS_2(O, P, t)


/*  To sort 8 lanes of up to 16 vectors,  we  will  use  the  most  advanced
 *  sorting algorithm known to science: THE BUBBLE SORT!
 */
static void sort_max_16_m256(__m256* array, size_t count) {
    __m256 a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, tmp;
    switch (count) {
        default:
            fprintf(stderr, "mediocre internal error: sort_max_16_lanes\n");
            abort();
        case 0: case 1:
            return;
        case 16:
        case 15:    o = array[14];
        case 14:    n = array[13];
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
        case 16:
            BUBBLE_UPWARDS_16(
                a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, array[15], tmp
            );
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
            array[0] = a;
    }
}

static int is_sorted_m256(__m256 const* in, size_t size) {
    __m256 bits = _mm256_setzero_ps();
    __m256 previous = in[0];
    for (size_t i = 1; i < size; ++i) {
        __m256 current = in[i];
        bits = _mm256_or_ps(bits, _mm256_cmp_ps(current, previous, _CMP_LT_OQ));
        previous = current;
    }
    return _mm256_movemask_ps(bits) == 0;
}

static void merge_m256(
    __m256* out, __m256 const* in, size_t l_size, size_t r_size
) {
    size_t total_size = l_size + r_size;
    if (l_size == 0) {
        memcpy(out, in, r_size);
        return;
    }
    if (r_size == 0) {
        memcpy(out, in, l_size);
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
    __m256 const last_l = _mm256_sub_ps(end_l, one);
    __m256 const last_r = _mm256_sub_ps(end_r, one);
    
    __m256 old_data = in[0];
    __m256 new_data = in[l_size];
    __m256 old_index = _mm256_setzero_ps();
    __m256 inc_old_index = one;
    __m256 new_index = end_l;
    __m256 inc_new_index = _mm256_add_ps(one, end_l);
    __m256 mask = _mm256_cmp_ps(old_data, new_data, _CMP_GE_OQ);
    
    out[0] = _mm256_min_ps(old_data, new_data);
    old_data = _mm256_max_ps(old_data, new_data);
    old_index = _mm256_blendv_ps(new_index, old_index, mask);
    new_index = _mm256_blendv_ps(inc_old_index, inc_new_index, mask);
    
    for (size_t i = 1; i != total_size; ++i) {
        
        __m256 const at_end_l = _mm256_cmp_ps(end_l, new_index, _CMP_EQ_OQ);
        __m256 const at_end_r = _mm256_cmp_ps(end_r, new_index, _CMP_EQ_OQ);
        
        new_index = _mm256_blendv_ps(new_index, last_r, at_end_l);
        new_index = _mm256_blendv_ps(new_index, last_l, at_end_r);
        
        inc_old_index = _mm256_add_ps(one, old_index);
        inc_new_index = _mm256_add_ps(one, new_index);
        
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
        
        mask = _mm256_cmp_ps(old_data, new_data, _CMP_GE_OQ);
        
        out[i] = _mm256_blendv_ps(old_data, new_data, mask);
        old_data = _mm256_blendv_ps(new_data, old_data, mask);
        old_index = _mm256_blendv_ps(new_index, old_index, mask);
        new_index = _mm256_blendv_ps(inc_old_index, inc_new_index, mask);
    }
}

static float arr[256] = {
      19,   31,   10,   14,    7,    1,   30,    2,
      17,   24,    1,    2,   13,   11,   23,   31,
      21,   13,    9,   23,    5,    4,    5,    6,
      30,   17,   16,   26,    9,    2,   12,   13,
      26,    3,   32,   27,   25,   22,   14,   26,
      20,   29,    4,    8,    2,   25,   29,   19,
       1,    7,   15,    6,   11,    7,   13,   16,
      27,   22,   24,    3,   28,   16,    2,   30,
      31,    5,    5,   13,   27,   26,   18,   14,
      29,    1,    8,   17,   16,   30,   24,   23,
      16,   18,   12,   20,   23,   13,   31,   29,
      28,   32,    3,   10,    3,   14,    4,    7,
      15,   26,   21,    5,   26,    6,   20,   10,
      23,   15,   17,    4,   17,   31,    8,   17,
      24,    6,   13,   19,   32,   12,    6,    1,
       9,   28,   22,   21,    1,   19,   19,   21,
      18,   14,   19,    1,   24,   23,   16,   28,
      12,   23,   31,    7,   30,   29,   27,   22,
       4,    9,   20, 1337,   18,    8,   22,    3,
       2,    8,   23,   28,    6,    3,   15,    4,
      11,   30,    6,    9,   10,   27,    1,    5,
       5,   16,   11,   32,   21,    5,   11,    9,
      25,    4,   14,   24,   22,   32,   25,   11,
       8,   25,   28,   30,   12,   18,   28,   20,
       3,   27,    7,   22,   31,   17,   17,   15,
       6,   10,   29,   16,    8,   15,    9,   25,
      32,   11,   26,   29,   14,   28,   32,    8,
      13,   21,   27,   15,   19,   10,   21,   27,
       7,   20,   30,   18,   29,   21,    3,   24,
      10,   12,    2,   11,   15,   24,    7,   18,
      14,   19,   18,   25,    4,   20,   10,   32,
      22,    2,   25,   31,   20,    9,   26,   12,
};

int main() {
    __m256* m256_array = aligned_alloc(32, sizeof(arr));
    memcpy(m256_array, arr, sizeof(arr));
    
    sort_max_16_m256(m256_array, 16);
    sort_max_16_m256(m256_array + 16, 10);
#ifdef MERGE
    __m256* temp = aligned_alloc(32, sizeof(arr));
    
    merge_m256(temp, m256_array, 16, 10);
    memcpy(m256_array, temp, sizeof(__m256) * 26);
#endif
    
    for (int a = 0; a < 32; ++a) {
        float const* f = (float*)&m256_array[a];
        for (int i = 0; i < 8; ++i) {
            printf("%6i", (int)f[i]);
        }
        printf("\n");
    }
}

