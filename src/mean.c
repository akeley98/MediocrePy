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

bool mediocre_mean_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count
) {
    if (array_count == 0 || bin_count == 0) {
        errno = EINVAL;
        return false;
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
        return false;
    }
    
    load_m256_from_u16(accumulator, data[0], bin_count);
    
    const size_t extra_bytes_count = (bin_count % 8) * sizeof(uint16_t);
    const __m128i zero = _mm_set1_epi16(0);
    
    for (size_t a = 1; a < array_count; ++a) {
        size_t i = vector_count - 1;
        __m256* accumulator_ptr = accumulator + i;
        __m128i const* current_data_array = (__m128i const*)data[a];
        __m128i const* data_ptr;
        __m128i extra_data;
        
        if (extra_bytes_count == 0) {
            data_ptr = current_data_array + i;
        } else {
            data_ptr = &extra_data;
            memcpy(&extra_data, current_data_array + i, extra_bytes_count);
        }
        
        while (true) {
            __m128i data = _mm_lddqu_si128(data_ptr);
            __m128i low_as_u32 = _mm_unpacklo_epi16(data, zero);
            __m128i high_as_u32 = _mm_unpackhi_epi16(data, zero);
            __m256 to_add = _mm256_set_m128(
                _mm_cvtepi32_ps(high_as_u32), _mm_cvtepi32_ps(low_as_u32)
            );
            
            *accumulator_ptr = _mm256_add_ps(*accumulator_ptr, to_add);
            
            if (i == 0) {
                break;
            } else {
                --i;
                --accumulator_ptr;
                data_ptr = current_data_array + i;
            }
        }
    }
    
    __m256 divisor_vector = _mm256_set1_ps((float)array_count);
    for (size_t i = 0; i < vector_count; ++i) {
        accumulator[i] = _mm256_div_ps(accumulator[i], divisor_vector);
    }
    
    load_u16_from_m256(out, accumulator, bin_count);
    
    free(accumulator);
    return true;
}

