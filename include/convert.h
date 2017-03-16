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



/*  Convert an array of item_count  32-bit  floats  (passed  as  __m256*,  a
 *  pointer to 256-bit aligned memory) to an array of item_count unsigned 16
 *  bit integers. In the default rounding mode, the floats will  be  rounded
 *  to  the  nearest  integer  (with  floats halfway between two consecutive
 *  integers being rounded to the nearest even integer), and all floats must
 *  be  in  the  interval  [0,  65535.5).  Returns  true  if all floats were
 *  in-range, false if any were not (in which case  errno  will  be  set  to
 *  ERANGE).  The  output for an out-of-range float in unspecified, but will
 *  not crash the program.
 */
bool load_u16_from_m256(
    uint16_t* out_as_u16,
    __m256 const* in_as_float,
    size_t item_count
);

/*  Convert an array of item_count 16-bit  unsigned  ints  to  an  array  of
 *  item_count  floats.  The  float  array  is passed as __m256* and must be
 *  aligned to 256-bits. If item_count is not a multiple  of  8,  the  extra
 *  floats  past  the  end of the array up to the next 256 bit boundary will
 *  have an unspecified value (e.g., if item_count is 42, the function  will
 *  write  48  floats  (6  _mm256  vectors)  to the output array. The last 6
 *  floats will have an unspecified value. Always returns true.
 */
bool load_m256_from_u16(
    __m256* out_as_float,
    uint16_t const* in_as_u16,
    size_t item_count
);

#ifdef __cplusplus
}
#endif

#endif

