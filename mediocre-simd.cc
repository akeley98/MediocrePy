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

#include "stdint.h"
#include "stddef.h"

using u32vec4 = uint32_t __attribute__((vector_size(16)));
using u16vec8 = uint16_t __attribute__((vector_size(16)));

/*  Stores 8 32 bit integers as 2 16 byte 32 bit vectors. This  is  intended
 *  only for storing intermediate values that might overflow in calculations
 *  on 16 bit values. The  32  bit  integers  are  'interleaved'  in  memory
 *  intstead  of  being  laid  out  sequentially  in order to speed up casts
 *  between u16vec8 and u32vec8. The  logical  positions  of  numbers  in  a
 *  vector are laid out in this order in memory: 0, 2, 4, 6, 1, 3, 5, 7.
 */
class u32vec8 {
    u32vec4 even, odd;
    
    u32vec8() {
    
    }
  public:
    u32vec8(uint32_t a) {
        even = u32vec4{ a, a, a, a };
        odd =  u32vec4{ a, a, a, a };
    }
    
    u32vec8(
        uint32_t a0, uint32_t a1, uint32_t a2, uint32_t a3,
        uint32_t a4, uint32_t a5, uint32_t a6, uint32_t a7
    ) {
        even = u32vec4{ a0, a2, a4, a6 };
        odd =  u32vec4{ a1, a3, a5, a7 };
    }
    
    u32vec8(u16vec8 input) {
        // The even positions in the input (0, 2, 4, 8) correspond to the
        // lower 16 bits of a 32 bit integer when the 16 bit input vector
        // is interpreted as a 32 bit vector. Zero out the upper 16 bits
        // of the 32 bit vector to convert the even positions to 32 bits.
        const u32vec4 even_mask = u32vec4{ 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF };
        even = reinterpret_cast<u32vec4>(input);
        even &= even_mask;
        // The odd positions in the input (1, 3, 5, 7) correspond to the
        // upper 16 bits of a 32 bit integer when the 16 bit input vector
        // is interpreted as a 32 bit vector. Shift the upper 16 bits into
        // the space occupied by the lower 16 bits to convert the odd
        // positions to 32 bits.
        const u32vec4 odd_shifts = u32vec4{ 16, 16, 16, 16 };
        odd = reinterpret_cast<u32vec4>(input);
        odd >>= odd_shifts;
    }
    
    explicit operator u16vec8() {
        const u32vec4 even_mask = u32vec4{ 0xFFFF, 0xFFFF, 0xFFFF, 0xFFFF };
        const u32vec4 odd_shifts = u32vec4{ 16, 16, 16, 16 };
        // even_16vec holds the numbers for the even positions and 0 for the
        // odds. odd_16vec holds the numbers for the odd positions and 0 for the
        // evens. Or them together and you will get the original 16 bit vector.
        const u16vec8 even_16vec = reinterpret_cast<u16vec8>(even & even_mask);
        const u16vec8 odd_16vec = reinterpret_cast<u16vec8>(odd << odd_shifts);
        return even_16vec | odd_16vec;
    }
    
    void operator+=(u32vec8 input) {
        even += input.even;
        odd += input.odd;
    }
    
    u32vec8 operator + (u32vec8 input) {
        input += *this;
        return input;
    }
    
    void operator/=(u32vec8 input) {
        even /= input.even;
        odd /= input.odd;
    }
    
    u32vec8 operator < (u32vec8 input) {
        u32vec8 output;
        output.even = even < input.even;
        output.odd = odd < input.odd;
        return output;
    }
};



