/*  An aggresively average SIMD python module
 *  Declarations for internal functions for help with effective testing.
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

#ifndef MediocrePy_INLINE_TESTING_H_
#define MediocrePy_INLINE_TESTING_H_

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/timeb.h>

#define MEDIOCRE_TEST_COUNT 24

#ifdef noexcept
#error "noexcept keyword redefined as macro"
#endif

#ifdef __cplusplus
extern "C" {
#else
#define noexcept // C / C++ compatibility hack.
#endif

// C wrapper around C++ Mersenne Twister object.
struct Random;

// Create a new Random generator with a random seed.
struct Random* new_random() noexcept;

// Create a new Random generator using the specified seed.
struct Random* new_random1(uint64_t seed) noexcept;

// Advance the Random generator's state, returning a random uint32_t.
uint32_t random_u32(struct Random* generator) noexcept;

// Advance the Random generator's state, returning a random uint32_t
// in the range [min_inclusive, max_inclusive].
uint32_t random_dist_u32(
    struct Random*, uint32_t min_inclusive, uint32_t max_inclusive) noexcept;

// Get the seed used to initialize the generator.
uint64_t get_seed(struct Random const* generator) noexcept;

// Shuffle an array of bin_count 32-bit unsigned integers, using
// entropy from the random generator.
void shuffle_u32(struct Random*, uint32_t* array, size_t bin_count) noexcept;

// Destroy the random generator, freeing its resources.
void delete_random(struct Random* generator) noexcept;

// Sort floats in an array of the specified size.
void sort_floats(float* array, size_t size) noexcept;

// Return the difference between the current time and the timeb passed as an
// argument (in milliseconds). Ignores the timezone and dstflag.
static inline long ms_elapsed(struct timeb before) noexcept {
    struct timeb now;
    ftime(&now);
    long before_ms = 1000L * before.time + before.millitm;
    long now_ms = 1000L * now.time + now.millitm;
    return now_ms - before_ms;
}

static inline void print_timer_elapsed(struct timeb before, size_t item_count) {
    long ms = ms_elapsed(before);
    double ns_per_item = ms * 1e6 / item_count;
    printf("%lims elapsed (%4.2fns per item).", ms, ns_per_item);
}

/*  Canary page structure useful for detecting buffer overrun bugs.
 *  
 *  A Canary page is structured into four parts: a guard page, a portion  of
 *  canary  bytes,  the  data  portion, and an unused portion (for alignment
 *  reasons). The user is expected to only read  and  write  from  the  data
 *  portion, which can be accessed through the .ptr member of the CanaryPage
 *  structure. The data portion has alignment based on the size of the  data
 *  and canary parts: ensure that both the canary and the data portions have
 *  sizes that are multiples of the alignment needed by the data type  being
 *  stored  (or,  more  generally, that the canary and data sizes _sum_ to a
 *  multiple of the alignment needed). If the user writes past  the  end  of
 *  the  data  portion,  the canary bytes will be overwritten, which will be
 *  detected by the check_canary_page function. If the user reads or  writes
 *  so  far past the end of the data buffer that they pass all of the canary
 *  bytes, the user will receive a segmentation fault due to the guard page.
 *  When  completed, free the canary page by calling free_canary_page on the
 *  entire structure.
 */
struct CanaryPage {
    void* ptr;
    // Users should not modify the stuff under this line.
    void* mapped_;
    size_t mapped_length_;
    unsigned char* canary_data_;
    size_t canary_length_;
};

/*  Initialize a canary page with space for data_size bytes of  data  and  a
 *  canary  of  canary_size bytes. The canary is optional and is useful only
 *  for substituting segfaults with softer errors. If the canary is set to 0
 *  bytes,  all  overruns  will  immediately result in a hard crash. Get the
 *  pointer to your data array by getting the .ptr  member  of  the  struct.
 *  Returns -1 if the struct could not be initialized, 0 if all is well.
 */
int init_canary_page(
    struct CanaryPage* out,
    size_t data_size,
    size_t canary_size
) noexcept;

/*  Returns -1 if the canary bytes don't match, 0  if  they  do,  or  if  no
 *  canary bytes were allocated in the first place.
 */
int check_canary_page(struct CanaryPage) noexcept;

// Frees the memory used by a canary page. Always returns 0.
int free_canary_page(struct CanaryPage cp) noexcept;

#ifdef __cplusplus
}
#endif

#undef noexcept
#endif

