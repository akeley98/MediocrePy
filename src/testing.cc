/*  An aggresively average SIMD python module
 *  Internal functions used for the module's tests.
 *  DO NOT LINK THIS FILE TO THE MAIN BUILD FOR THE LIBRARY.
 *  The names exported by this file are likely to collide with others' names.
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

#include "testing.h"

#include <random>

static std::random_device the_random_device;

extern "C" {

struct Random {
    uint64_t seed;
    std::mt19937 generator;
    
    Random(uint64_t seed_arg) :
        seed(seed_arg), generator(seed_arg) { }
};

Random* new_random() noexcept {
    return new Random(the_random_device());
}

Random* new_random1(uint64_t seed) noexcept {
    return new Random(seed);
}

uint32_t random_u32(Random* generator) noexcept {
    return static_cast<uint32_t>(generator->generator());
}

uint64_t get_seed(Random const* generator) noexcept {
    return generator->seed;
}

void delete_random(Random* generator) noexcept {
    delete generator;
}

} // end extern "C"

