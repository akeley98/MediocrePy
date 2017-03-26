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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#include <algorithm>
#include <random>
#include <vector>

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

// Sort floats in an array of the specified size.
void sort_floats(float* array, size_t size) noexcept {
    std::sort(array, array + size);
}

/*  Initialize a canary page with space for data_size bytes of  data  and  a
 *  canary  of  canary_size bytes. The canary is optional and is useful only
 *  for substituting segfaults for softer errors. If the canary is set to  0
 *  bytes,  all  overruns  will  immediately result in a hard crash. Get the
 *  pointer to your data array by getting the .ptr  member  of  the  struct.
 *  Returns -1 if the struct could not be initialized, 0 if all is well.
 */
int init_canary_page (
    struct CanaryPage* out,
    size_t data_size,
    size_t canary_size
) noexcept {
    static unsigned seed;    
    // Total room needed to store 3 useful parts + rounded up to multiple
    // of 4096 bytes as required by mmap.
    size_t mapped_size = (4096 + data_size + canary_size + 4095) & ~4095;
    
    // If the user requested canary bytes, remember some random canary
    // bytes in a separate malloc'd buffer. Later we will copy this to the
    // end of the user's data space, and even later we will check the
    // malloc'd buffer with the canaries at the end of the user's data
    // space to check for overruns.
    unsigned char* canary_data = NULL;
    if (canary_size != 0) {
        canary_data = (unsigned char*)malloc(canary_size);
        if (canary_data == NULL) {
            return -1;
        }
        for (size_t i = 0; i < canary_size; ++i) {
            canary_data[i] = (unsigned char)rand_r(&seed);
        }
    }
    
    void* page = mmap(
        NULL, mapped_size, PROT_READ|PROT_WRITE,
        MAP_PRIVATE|MAP_ANONYMOUS, -1, 0
    );
    
    if (page == MAP_FAILED) {
        free(canary_data);
        perror("init_canary_page mmap");
        return -1;
    }
    
    // The CanaryPage spans several pages (4096 bytes each) in computer memory.
    // This space is split into 4 regions: the guard page, the canary, the
    // data portion, and unused space needed to align to 4096 bytes. If the
    // user overruns the data buffer by <= canary_size bytes, that will be
    // detected when we compare the canary bytes. If the user overruns past
    // that, they will touch the guard page and get a segmentation fault.
    void* end_page = (char*)page + mapped_size;
    void* guard_page = (char*)end_page - 4096;
    void* canary_ptr = (char*)guard_page - canary_size;
    void* data_ptr = (char*)canary_ptr - data_size;
    
    // Make it so that anyone who touches the guard page dies.
    if (mprotect(guard_page, 4096, PROT_NONE) != 0) {
        free(canary_data);
        munmap(page, mapped_size);
        perror("init_canary_page mprotect");
        return -1;
    }
    
    if (canary_size != 0) {
        memcpy(canary_ptr, canary_data, canary_size);
    }
    
    *out = {
        data_ptr,
        page,
        mapped_size,
        canary_data,
        canary_size
    };
    return 0;
}

/*  Returns -1 if the canary bytes don't match, 0  if  they  do,  or  if  no
 *  canary bytes were allocated in the first place.
 */
int check_canary_page(struct CanaryPage cp) noexcept {
    // Recover the position of the canary in the mmap'd portion.
    // (It's towards the end of the area, before the 4096 byte guard page).
    unsigned char* canary = ((unsigned char*)cp.mapped_ 
        + cp.mapped_length_ - 4096 - cp.canary_length_
    );
    int result = 0;
    for (size_t i = 0; i < cp.canary_length_; ++i) {
        if (cp.canary_data_[i] != canary[i]) {
            result = -1;
            fprintf(stderr, "check_canary_page: [%zi] overwritten by 0x%02X\n",
                i, canary[i]);
        }
    }
    return result;
}

// Frees the memory used by a canary page. Always returns 0.
int free_canary_page(struct CanaryPage cp) noexcept {
    free(cp.canary_data_);
    munmap(cp.mapped_, cp.mapped_length_);
    return 0;
}

} // end extern "C"

