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

#include "assert.h"
#include "stddef.h"
#include "memory"

#include "vec.h"

#define INTERNAL_CHECK(x) assert(("Internal MediocrePy error: ", x))

namespace {

void iadd_array(u32vec8* lhs, u16vec8 const* rhs, size_t count) noexcept {
    INTERNAL_CHECK(count % 8 == 0);
    
    for ( ; count != 0; count -= 8) {
        *lhs++ += u32vec8(*rhs++);
    }
}

void iround_div_array(u32vec8* arr, uint32_t div, size_t count) noexcept {
    INTERNAL_CHECK(count % 8 == 0);
    const u32vec8 half_div_vector((div+1) / 2);
    const u32vec8 div_vector(div);
    
    for ( ; count != 0; count -= 8) {
        u32vec8 temp = *arr;
        temp += half_div_vector;
        temp /= div_vector;
        *arr++ = temp;
    }
}

void iround_div_array(u32vec8* lhs, u16vec8 const* rhs, size_t count) noexcept {
    # error
}

void to_u16_array(u16vec8* lhs, u32vec8 const* rhs, size_t count) noexcept {
    INTERNAL_CHECK(count % 8 == 0);
    
    for ( ; count != 0; count -= 8) {
        *lhs++ = static_cast<u16vec8>(*rhs++);
    }
}

void to_u32_array(u32vec8* lhs, u16vec8 const* rhs, size_t count) noexcept {
    INTERNAL_CHECK(count % 8 == 0);
    
    for ( ; count != 0; count -= 8) {
        *lhs++ = u32vec8(*rhs++);
    }
}

} // end anonymous namespace

namespace MediocrePy {



} // end namespace MediocrePy

