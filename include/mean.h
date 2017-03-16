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

#ifndef MediocrePy_MEAN_H_
#define MediocrePy_MEAN_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <emmintrin.h>
#include <immintrin.h>

#ifdef __cplusplus
extern "C" {
#endif

bool mediocre_mean_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count
);

bool mediocre_clipped_mean_u16(
    uint16_t* out,
    uint16_t const* const* data,
    size_t array_count,
    size_t bin_count,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
);

#ifdef __cplusplus
}
#endif

#endif

