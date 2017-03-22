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
            array[0] = a;
    }
}

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
    __m256 input_exhausted_mask = _mm256_setzero_ps();
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
        input_exhausted_mask = _mm256_or_ps(input_exhausted_mask, at_end);
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
        mask = _mm256_or_ps(mask, input_exhausted_mask);
        
        // It really bothers me how blendv reads in the exact opposite order
        // as a ternary statement. condition ? if_true : if_false becomes
        // blendv(if_false, if_true, condition). RRRAAUURGH.
        out[i] = _mm256_blendv_ps(old_data, new_data, mask);
        old_data = _mm256_blendv_ps(new_data, old_data, mask);
        old_index = _mm256_blendv_ps(new_index, old_index, mask);
        new_index = _mm256_blendv_ps(inc_old_index, inc_new_index, mask);
    }
}

static void mergesort_m256(__m256* to_sort, __m256* scratch, size_t count) {
    size_t part_size = 20;
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

#include "testing.h"

float arr[800] = {
  26, 1079, 2023, 3081, 4020, 5081, 6083, 7058,
  88, 1059, 2073, 3015, 4019, 5054, 6001, 7011,
  65, 1060, 2086, 3043, 4065, 5058, 6078, 7049,
  83, 1028, 2093, 3084, 4084, 5015, 6067, 7003,
  29, 1021, 2056, 3062, 4003, 5011, 6041, 7080,
  23, 1076, 2076, 3010, 4016, 5012, 6023, 7095,
  12, 1044, 2036, 3095, 4043, 5022, 6044, 7097,
  97, 1089, 2043, 3028, 4042, 5062, 6075, 7065,
  35, 1047, 2050, 3020, 4048, 5010, 6049, 7030,
  25, 1078, 2012, 3075, 4039, 5025, 6074, 7025,
  50, 1097, 2089, 3025, 4030, 5027, 6059, 7052,
   8, 1065, 2046, 3035, 4008, 5013, 6064, 7092,
  13, 1098, 2017, 3082, 4032, 5040, 6084, 7081,
  93, 1026, 2003, 3056, 4013, 5003, 6061, 7094,
  59, 1094, 2061, 3001, 4023, 5069, 6048, 7060,
  19, 1016, 2090, 3030, 4089, 5061, 6093, 7085,
   2, 1006, 2079, 3054, 4037, 5017, 6014, 7056,
  38, 1053, 2014, 3033, 4064, 5039, 6060, 7074,
  48, 1032, 2096, 3090, 4040, 5047, 6033, 7029,
  95, 1091, 2005, 3026, 4031, 5045, 6026, 7031,
  11, 1036, 2030, 3049, 4010, 5042, 6046, 7069,
  21, 1058, 2034, 3052, 4061, 5088, 6065, 7076,
  71, 1024, 2002, 3037, 4038, 5021, 6076, 7083,
   5, 1011, 2022, 3002, 4022, 5053, 6016, 7017,
  44, 1061, 2021, 3086, 4051, 5046, 6056, 7040,
  32, 1096, 2064, 3011, 4068, 5090, 6068, 7079,
  82, 1069, 2059, 3005, 4060, 5086, 6039, 7087,
  61, 1049, 2087, 3078, 4046, 5057, 6007, 7071,
   6, 1074, 2001, 3072, 4002, 5074, 6047, 7024,
  22, 1033, 2053, 3079, 4017, 5092, 6045, 7047,
  85, 1014, 2075, 3009, 4045, 5007, 6082, 7026,
  47, 1046, 2060, 3057, 4005, 5043, 6058, 7066,
  56, 1042, 2092, 3088, 4083, 5080, 6080, 7096,
  75, 1054, 2040, 3040, 4027, 5083, 6086, 7051,
  76, 1031, 2026, 3029, 4056, 5044, 6057, 7077,
  34, 1064, 2098, 3099, 4095, 5067, 6070, 7067,
  45, 1027, 2037, 3014, 4018, 5089, 6003, 7062,
  28, 1002, 2055, 3064, 4093, 5078, 6013, 7048,
  80, 1041, 2095, 3094, 4096, 5096, 6015, 7023,
  58, 1015, 2035, 3023, 4015, 5087, 6051, 7015,
  46, 1013, 2031, 3093, 4088, 5084, 6100, 7070,
  20, 1018, 2100, 3085, 4041, 5031, 6025, 7018,
  42, 1063, 2067, 3089, 4098, 5065, 6034, 7061,
  30, 1052, 2065, 3055, 4034, 5038, 6005, 7001,
  57, 1090, 2004, 3063, 4025, 5030, 6052, 7008,
  18, 1017, 2020, 3039, 4085, 5048, 6092, 7045,
  79, 1048, 2054, 3045, 4072, 5073, 6008, 7053,
  17, 1071, 2091, 3065, 4087, 5034, 6020, 7068,
  99, 1007, 2080, 3080, 4044, 5041, 6089, 7059,
  55, 1043, 2047, 3092, 4073, 5085, 6024, 7098,
  92, 1009, 2066, 3083, 4077, 5052, 6077, 7028,
  89, 1025, 2013, 3018, 4091, 5063, 6009, 7039,
  98, 1080, 2018, 3048, 4086, 5006, 6018, 7089,
   1, 1070, 2072, 3044, 4100, 5071, 6062, 7082,
  49, 1045, 2006, 3091, 4009, 5099, 6097, 7036,
  36, 1066, 2042, 3074, 4028, 5019, 6072, 7020,
   9, 1083, 2025, 3069, 4052, 5095, 6081, 7073,
  81, 1073, 2088, 3087, 4062, 5035, 6040, 7090,
  31, 1068, 2074, 3058, 4006, 5076, 6091, 7055,
  67, 1050, 2032, 3053, 4079, 5028, 6099, 7010,
  77, 1086, 2057, 3019, 4059, 5037, 6032, 7038,
  66, 1093, 2099, 3012, 4033, 5036, 6042, 7086,
  16, 1077, 2038, 3050, 4014, 5070, 6030, 7043,
  24, 1092, 2094, 3066, 4071, 5075, 6055, 7063,
  52, 1085, 2070, 3017, 4099, 5004, 6043, 7019,
  70, 1023, 2009, 3046, 4063, 5060, 6054, 7004,
   4, 1040, 2010, 3070, 4053, 5033, 6088, 7035,
  96, 1095, 2071, 3013, 4055, 5094, 6028, 7044,
  64, 1067, 2024, 3027, 4001, 5002, 6035, 7075,
  90, 1072, 2083, 3059, 4036, 5077, 6071, 7012,
  33, 1100, 2027, 3060, 4058, 5005, 6027, 7006,
  27, 1075, 2085, 3071, 4066, 5029, 6029, 7078,
  14, 1099, 2033, 3006, 4075, 5016, 6004, 7037,
  94, 1010, 2016, 3022, 4029, 5009, 6063, 7013,
  40, 1003, 2029, 3021, 4080, 5072, 6066, 7014,
  51, 1022, 2011, 3051, 4090, 5097, 6006, 7034,
  43, 1008, 2049, 3003, 4007, 5066, 6095, 7022,
  62, 1087, 2051, 3047, 4094, 5056, 6069, 7072,
  10, 1029, 2028, 3061, 4074, 5051, 6096, 7027,
  74, 1030, 2052, 3098, 4012, 5079, 6094, 7032,
  86, 1001, 2084, 3004, 4026, 5100, 6002, 7084,
  84, 1019, 2062, 3038, 4069, 5026, 6090, 7041,
   3, 1062, 2081, 3041, 4024, 5014, 6031, 7016,
 100, 1057, 2069, 3100, 4021, 5068, 6079, 7100,
  41, 1081, 2068, 3067, 4050, 5032, 6098, 7042,
  73, 1004, 2039, 3032, 4049, 5091, 6022, 7050,
  53, 1051, 2063, 3096, 4057, 5064, 6085, 7009,
  68, 1055, 2041, 3031, 4078, 5098, 6053, 7057,
  60, 1056, 2097, 3008, 4047, 5024, 6038, 7005,
  87, 1038, 2008, 3073, 4082, 5023, 6010, 7007,
  63, 1035, 2007, 3068, 4097, 5020, 6036, 7002,
  91, 1088, 2044, 3097, 4081, 5049, 6012, 7021,
  78, 1082, 2045, 3076, 4035, 5001, 6019, 7091,
  15, 1012, 2058, 3007, 4054, 5008, 6087, 7093,
  39, 1084, 2019, 3034, 4076, 5093, 6037, 7088,
  72, 1039, 2082, 3016, 4092, 5059, 6017, 7064,
  69, 1037, 2077, 3036, 4011, 5055, 6021, 7033,
  54, 1034, 2015, 3024, 4070, 5018, 6050, 7099,
   7, 1020, 2078, 3042, 4067, 5050, 6073, 7046,
  37, 1005, 2048, 3077, 4004, 5082, 6011, 7054
};

#define X (1 << 20)

int main() {
    struct CanaryPage a_page, b_page;
    int err = init_canary_page(&a_page, sizeof(__m256) * X, 0);
    err    |= init_canary_page(&b_page, sizeof(__m256) * X, 0);
    
    if (err) {
        perror("Uh oh");
        exit(1);
    }
    
    __m256* m256_array = a_page.ptr;
    __m256* tmp = b_page.ptr;
    
    memset(tmp, 42, sizeof(__m256) * X);
    
    unsigned seed = 100;
    
    for (size_t i = 0; i < X * 8; ++i) {
        ((float*)m256_array)[i] = (float)rand_r(&seed);
    }
    
    struct timeb timer_start;
    ftime(&timer_start);
    mergesort_m256(m256_array, tmp, X);
    printf("%li\n", ms_elapsed(timer_start));
    /*
    for (size_t i = 0; i < X; ++i) {
        float* f = (float*)&m256_array[i];
        for (int i = 0; i < 8; ++i) {
            printf("%9.1f ", f[i]);
        }
        printf("\n");
    } */
    
    return 0;
}

