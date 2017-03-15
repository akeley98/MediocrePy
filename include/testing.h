/*  An aggresively average SIMD python module
 *  Declarations for internal functions for testing.
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

#ifndef MediocrePy_TEST_UTILS_H_
#define MediocrePy_TEST_UTILS_H_

#include <stdint.h>
#include <sys/timeb.h>

#ifdef noexcept
#error "noexcept macro defined"
#endif

#ifdef __cplusplus
extern "C" {
#else
#define noexcept // C / C++ compatibility hack.
#endif

// C wrapper around C++ Mersenne Twister object.
struct Random;

struct Random* new_random() noexcept;
struct Random* new_random1(uint64_t seed) noexcept;
uint32_t random_u32(struct Random* generator) noexcept;
uint64_t get_seed(struct Random const* generator) noexcept;
void delete_random(struct Random* generator) noexcept;

// Return the difference between the current time and the timeb passed as an
// argument (in milliseconds). Ignores the timezone and dstflag.
static inline long ms_elapsed(struct timeb before) noexcept {
    struct timeb now;
    ftime(&now);
    long before_ms = 1000L * before.time + before.millitm;
    long now_ms = 1000L * now.time + now.millitm;
    return now_ms - before_ms;
}

#ifdef __cplusplus
}
#endif

#undef noexcept
#endif

