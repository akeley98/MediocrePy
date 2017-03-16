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
#include <vector>
#include <algorithm>

static std::random_device the_random_device;
static std::uniform_int_distribution<uint32_t> dist;

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

uint32_t random_dist_u32(
    Random* generator, uint32_t min_inclusive, uint32_t max_inclusive
) noexcept {
    return static_cast<uint32_t>(
        dist(
            generator->generator,
            decltype(dist)::param_type{ min_inclusive, max_inclusive }
        )
    );
}

uint64_t get_seed(Random const* generator) noexcept {
    return generator->seed;
}

void shuffle_u32(Random* r, uint32_t* array, size_t bin_count) noexcept {
    struct Thing {
        uint32_t weight, data;
        bool operator<(Thing other) const {
            return weight < other.weight;
        }
    };
    std::vector<Thing> vec;
    vec.reserve(bin_count);
    for (size_t i = 0; i < bin_count; ++i) {
        vec.push_back({ static_cast<uint32_t>(r->generator()), array[i] });
    }
    std::sort(vec.begin(), vec.end());
    for (size_t i = 0; i < bin_count; ++i) {
        array[i] = vec[i].data;
    }
}

void delete_random(Random* generator) noexcept {
    delete generator;
}

} // end extern "C"

