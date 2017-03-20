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

#ifndef MediocrePy_CONVERT_H_
#define MediocrePy_CONVERT_H_

#include <stdint.h>
#include <stdbool.h>

#include "emmintrin.h"
#include "immintrin.h"

#ifdef __cplusplus
extern "C" {
#endif

/*  The  comments  describe  the  non-stride  version   of   the   functions
 *  (implemented  as  an  inline  function  calling the _stride version with
 *  stride=1. The stride argument determines how the __m256 input/output  is
 *  read/written  (the  uint16_t  output  is  always treated as a contiguous
 *  array). The stride is per vector, not per scalar float: for stride=s and
 *  index=n,  floats[s*n:s*n+7]  correspond to uint16_t[n:n+7]. For example,
 *  for stride=3, floats 0 to 7,  24  to  31,  48  to  55...  correspond  to
 *  uint16_t  0 to 7, 8 to 15, 16 to 23... . This obviously changes the size
 *  requirements for the __m256 arrays: they will  need  to  be  just  under
 *  stride * item_count / 8 __m256 vectors wide.
 */

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
);

static inline int load_u16_from_m256(
    uint16_t* out_as_u16,
    __m256 const* in_as_float,
    size_t item_count
) {
    return load_u16_from_m256_stride(
        out_as_u16,
        in_as_float,
        item_count, 1
    );
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
);

static inline int load_m256_from_u16(
    __m256* out_as_float,
    uint16_t const* in_as_u16,
    size_t item_count
) {
    return load_m256_from_u16_stride(
        out_as_float,
        in_as_u16,
        item_count, 1
    );
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
);

static inline int iadd_m256_by_u16(
    __m256* to_increase,
    uint16_t const* in_as_u16,
    size_t item_count
) {
    return iadd_m256_by_u16_stride(
        to_increase,
        in_as_u16,
        item_count, 1
    );
}

#ifdef __cplusplus
}
#endif

#endif

