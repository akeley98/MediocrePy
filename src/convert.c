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

#include "convert.h"

#include <stdint.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <emmintrin.h>
#include <immintrin.h>
#include <tmmintrin.h>

#include <stdio.h>

/*  Convert an array of item_count  32-bit  floats  (passed  as  __m256*,  a
 *  pointer to 256-bit aligned memory) to an array of item_count unsigned 16
 *  bit integers. In the default rounding mode, the floats will  be  rounded
 *  to  the  nearest  integer  (with  floats halfway between two consecutive
 *  integers being rounded to the nearest even integer), and all floats must
 *  be  in the interval [0, 65535.5). Returns 0 if all floats were in-range,
 *  -1 if any were not (in which case errno will  be  set  to  ERANGE).  The
 *  output  for an out-of-range float in unspecified, but will not crash the
 *  program.
 */
int load_u16_from_m256_stride(
    uint16_t* out_as_u16,
    __m256 const* in_as_float,
    size_t item_count,
    long input_stride
) {
    if (item_count % 8 != 0) {
        // We will handle arrays that are not exactly multiples of 8 items long
        // by first converting the "main part" of the array, which is the first
        // 8x items of an array 8x + r long (e.g. 48 items of a 51 item array).
        // We then convert the extra r items by copying the last vector of 8
        // floats from in_as_float (the last 8-r floats are garbage) into a
        // temporary buffer, zeroing out the garbage, converting those 8 floats
        // to 16 bits in another temporary buffer, and copying the first r
        // integers in that buffer to the end of the output array.
        const size_t remainder = item_count % 8;
        const size_t main_part = item_count - remainder;
        const size_t istr = (size_t)input_stride;
        
        // The temporary buffers for the remaining items.
        // Some compilers are known to not properly align vectorized types
        // on the stack, so we have an array twice the size of an __m256 and
        // manually align a pointer to it to get a place for a temporary __m256.
        uint16_t extra_output[8];
        __m256* extra_input;
        assert(sizeof(*extra_input) == 32);
        char buffer[2 * 32];
        char* aligned_buffer = &buffer[32 - ((uintptr_t)&buffer % 32)];
        extra_input = (__m256*)(aligned_buffer);
        
        // It's safe to dereference the extra garbage floats because the
        // __m256 items must be aligned to 32 bytes, so we will never cross
        // a page boundary into a page we are not allowed to access.
        *extra_input = in_as_float[main_part * istr/ 8];
        for (size_t i = remainder; i < 8; ++i) {
            // FYI we zero out these numbers just in case the garbage values
            // were not representable as 16 bit integers. This prevents false
            // overflow alarms.
            ((float*)extra_input)[i] = 0.0f;
            
        }
        int code0 = load_u16_from_m256_stride(
            out_as_u16, in_as_float, main_part, istr
        );
        int code1 = load_u16_from_m256_stride(
            extra_output, extra_input, 8, istr
        );
        for (size_t i = 0; i < remainder; ++i) {
            out_as_u16[main_part + i] = extra_output[i];
        }
        // Recursive call will set errno if something went wrong.
        // We are responsible only for forwarding both calls' return codes.
        return code0 | code1;
    }
    
    // magic_float = 2 ** 23. 2 ** 23 + n for any float n in [0, 65535.5)
    // will have the low word equal to the integer representation of the
    // number n (since a float with expontent of 23 will have the lowest
    // bit be the ones place bit), and a high word equal to 0x4B00.
    // We will extract the 16 bit int from the low word and check that the
    // high word was 0x4B00 for every float to check for overflow.
    const float magic_float = 8388608.0f;
    
    const __m256 magic_float_vector = _mm256_set1_ps(magic_float);
    __m256 overflow_check = _mm256_set1_ps(0.0f);
    __m256 expected_vector = _mm256_set1_ps(magic_float);
    
    const bool out_is_aligned = ((uintptr_t)out_as_u16) % 16 == 0;
    
    const uint8_t z = 0x80;
    // Mask for getting lower 16-bits of floating point numbers in a 128-bit
    // register and storing them in the high half of destination 128-bit
    // register, zeroing out the lower half of the destination register.
    const __m128i high_shuffle = _mm_set_epi8(
        13, 12, 9, 8, 5, 4, 1, 0, z, z, z, z, z, z, z, z
    );
    const __m128i low_shuffle = _mm_set_epi8(
        z, z, z, z, z, z, z, z, 13, 12, 9, 8, 5, 4, 1, 0
    );
    
    // Walk through the arrays and do the actual conversion.
    while (item_count != 0) {
        const __m256 magic = _mm256_add_ps(*in_as_float, magic_float_vector);
        // High word of each float should be 0x4B00, low word should be the
        // 16 bit integer that we want. Check the high word using xor and or
        // it into the overflow check vector. At the end, if any of the high
        // words of the floats in overflow check are nonzero, we know that
        // some float somewhere did not fit in an unsigned 16-bit integer.
        overflow_check = _mm256_or_ps(
            overflow_check, _mm256_xor_ps(magic, expected_vector)
        );
        __m128i high_part = _mm_castps_si128(_mm256_extractf128_ps(magic, 1));
        __m128i low_part = _mm_castps_si128(_mm256_extractf128_ps(magic, 0));
        
        high_part = _mm_shuffle_epi8(high_part, high_shuffle);
        low_part = _mm_shuffle_epi8(low_part, low_shuffle);
        __m128i output = _mm_or_si128(low_part, high_part);
        
        // Clang will move this branch out of this loop.
        if (out_is_aligned) {
            _mm_store_si128((__m128i*)out_as_u16, output);
        } else {
            _mm_storeu_si128((__m128i*)out_as_u16, output);
        }
        
        in_as_float += input_stride;
        out_as_u16 += 8;
        item_count -= 8;
    }
    // Each float vector was xor'd with 0x4B000000 before being or'd to
    // the overflow_check vector. Check every high 16-bit word (odd-numbered
    // words because intel uses little endian), and complain if it is not 0,
    // which occurs if a float overflowed and thus has a high word != 0x4B00.
    uint16_t overflow_check_words[16];
    memcpy(overflow_check_words, &overflow_check, 32);
    for (int i = 1; i < 16; i += 2) {
        if (overflow_check_words[i] != 0) {
            errno = ERANGE;
            return -1;
        }
    }
    return 0;
}

/*  Convert an array of item_count 16-bit  unsigned  ints  to  an  array  of
 *  item_count  floats.  The  float  array  is passed as __m256* and must be
 *  aligned to 256-bits. If item_count is not a multiple  of  8,  the  extra
 *  floats  past  the  end of the array up to the next 256 bit boundary will
 *  have an unspecified value (e.g., if item_count is 42, the function  will
 *  write  48  floats  (6  _mm256  vectors)  to the output array. The last 6
 *  floats will have an unspecified value). Always returns 0.
 */
int load_m256_from_u16_stride(
    __m256* out_as_float,
    uint16_t const* in_as_u16,
    size_t item_count,
    long output_stride
) {
    if (item_count % 8 != 0) {
        // To handle cases where item_count is not an exact multiple of 8,
        // split the work into two parts: the "main part", which is all of
        // the items up to the biggest multiple of 8 under the item_count
        // (e.g. the first 80 items of an 83 item array), and the "remainder",
        // which are the last 1 to 7 items not handled in the main part. To
        // handle the main part, just call ourselves recursively with the
        // same pointers but with item_count rounded down to a multiple of 8.
        // For the remainder, we copy the last few items to a temporary array
        // 8 integers wide (we have to be careful not to read past the end of
        // the input array, because it might be pushed up against a page
        // boundary or otherwise unsafe to read), and call ourselves recursively
        // with 8 as the item_count (unlike for the input array, it IS safe to
        // write past the end of the output array by a few items, because we
        // stated in the function description that the last few items up to a
        // 256 bit boundary will have unspecified value, and each __m256 is
        // aligned, so it won't cross a page boundary into unmapped memory.
        const size_t remainder = item_count % 8;
        const size_t main_part = item_count - remainder;
        const size_t os = (size_t)output_stride;
        
        __m256* extra_output = out_as_float + main_part*os/8;
        uint16_t extra_input[8];
        
        load_m256_from_u16_stride(out_as_float, in_as_u16, main_part, os);
        
        for (size_t i = 0; i < remainder; ++i) {
            extra_input[i] = in_as_u16[i + main_part];
        }
        load_m256_from_u16_stride(extra_output, extra_input, 8, os);
        
        return 0;
    }
    
    const __m128i zero = _mm_set1_epi16(0);
    const bool in_is_aligned = (uintptr_t)in_as_u16 % 16 == 0;
    
    // Walk through the arrays and do the actual conversion.
    while (item_count != 0) {
        // So straightforward compared to the float->int conversion...
        __m128i vector_as_u16;
        if (in_is_aligned) {
            vector_as_u16 = _mm_load_si128((__m128i const*)in_as_u16);
        } else {
            vector_as_u16 = _mm_lddqu_si128((__m128i const*)in_as_u16);
        } // Again, clang should hoist these ifs out of the loop.
        
        __m128i low_as_u32 = _mm_unpacklo_epi16(vector_as_u16, zero);
        __m128i high_as_u32 = _mm_unpackhi_epi16(vector_as_u16, zero);
        
        *out_as_float = _mm256_set_m128(
            _mm_cvtepi32_ps(high_as_u32), _mm_cvtepi32_ps(low_as_u32)
        );
        
        out_as_float += output_stride;
        in_as_u16 += 8;
        item_count -= 8;
    }
    return 0;
}

/*  Increases each float in the output  array  of  size  item_count  by  the
 *  corresponding 16-bit unsigned int in the input array of size item_count.
 *  If the array size is not an exact multiple of 8, the extra  floats  past
 *  the end of the output array up to the next 256-bit boundary will have an
 *  unspecified value (e.g., if item_count  is  77,  80  floats  (10  __m256
 *  vectors)  will  be  written,  and the 3 floats past the end of the float
 *  array will have unspecified value). Always returns 0.
 */
int iadd_m256_by_u16_stride(
    __m256* to_increase,
    uint16_t const* in_as_u16,
    size_t item_count,
    long output_stride
) {
    // The function is mostly copied from the load_m256_from_u16 function.
    // The structure is basically the same so I won't repeat the gigantic
    // comment again here.
    if (item_count % 8 != 0) {
        const size_t remainder = item_count % 8;
        const size_t main_part = item_count - remainder;
        const size_t os = (size_t)output_stride;
        
        __m256* extra_part = to_increase + main_part*os/8;
        uint16_t extra_input[8];
        
        iadd_m256_by_u16_stride(to_increase, in_as_u16, main_part, os);
        
        for (size_t i = 0; i < remainder; ++i) {
            extra_input[i] = in_as_u16[i + main_part];
        }
        iadd_m256_by_u16_stride(extra_part, extra_input, 8, os);
        
        return 0;
    }
    
    const __m128i zero = _mm_set1_epi16(0);
    const bool in_is_aligned = (uintptr_t)in_as_u16 % 16 == 0;
    
    while (item_count != 0) {
        const __m256 before_increment = *to_increase;
        
        __m128i vector_as_u16;
        if (in_is_aligned) {
            vector_as_u16 = _mm_load_si128((__m128i const*)in_as_u16);
        } else {
            vector_as_u16 = _mm_lddqu_si128((__m128i const*)in_as_u16);
        }
        
        __m128i low_as_u32 = _mm_unpacklo_epi16(vector_as_u16, zero);
        __m128i high_as_u32 = _mm_unpackhi_epi16(vector_as_u16, zero);
        
        const __m256 floats_to_add = _mm256_set_m128(
            _mm_cvtepi32_ps(high_as_u32), _mm_cvtepi32_ps(low_as_u32)
        );
        
        *to_increase = _mm256_add_ps(before_increment, floats_to_add);
        
        to_increase += output_stride;
        in_as_u16 += 8;
        item_count -= 8;
    }
    return 0;
}

