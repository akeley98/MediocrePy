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
#include <stdlib.h>
#include <string.h>
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
    const size_t vector_count = (bin_count + 7) & ~7;
    
    // accumulator is the buffer where we will be adding up and dividing data
    // to compute the mean. converted is the buffer we will use for conversions
    // from uint16_t to __mm256.
    __m256* allocated = NULL;
    __m256* accumulator = NULL;
    __m256* converted = NULL;
    
    // accumulator and converted buffers will share on allocation.
    allocated = aligned_alloc(vector_count * sizeof(__m256) * 2);
    if (allocated == NULL) {
        assert(errno == ENOMEM);
        return false;
    }
    accumulator = allocated;
    converted = allocated + vector_count;
    
    memset(accumulator, 0, vector_count * sizeof(__m256));
    
    for (size_t a = 0; a < array_count; ++a) {
        load_m256_from_u16(converted, data[a], bin_count);
        
        for (size_t i = 0; i < vector_count; ++i) {
            accumulator[i] = _mm_add_ps(accumulator[i], converted[i]);
        }
    }
    
    __m256 divisor_vector = _mm256_set1_ps((float)array_count);
    for (size_t i = 0; i < vector_count; ++i) {
        accumulator[i] = _mm256_div_ps(accumulator[i], divisor_vector);
    }
    
    load_u16_from_m256(out, accumulator, bin_count);
    
    free(allocated);
    return true;
}

