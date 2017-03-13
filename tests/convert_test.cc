/*  An aggresively average SIMD python module
 *  Test for the functions in convert.c
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

#include "convert.h"

#include "math.h"
#include "stdio.h"
#include "stdlib.h"
#include "random"
#include "sys/timeb.h"

namespace my_stuff {

static time_t seed;
std::mt19937 random { seed = time(0) };

static struct timeb timer_begin;

static void print_timer_elapsed() {
    struct timeb now;
    ftime(&now);
    
    printf("%li ms elapsed\n",
        1000L * (now.time - timer_begin.time) + 
        (now.millitm - timer_begin.millitm)
    );
}

static void test_load_u16(size_t count, bool is_aligned, bool expect_okay) {
    printf("Converting %zi floats to uint16_t (%s).\n",
        count, is_aligned ? "aligned" : "not aligned");
    
    // count rounded up to nearest multiple of 8.
    size_t rounded_count = ((count + 7) & ~7);
    
    __m256* m256_array = (__m256*)aligned_alloc(
        32, rounded_count * sizeof(float));
    uint16_t* aligned_u16 = (uint16_t*)aligned_alloc(
        16, rounded_count * sizeof(uint16_t) + 48);
    
    // Allocate 48 bytes extra for 16 intentional misalignment bytes
    // and 32 extra bytes for the canaries.
    
    // If is_aligned is false, intentionally misalign the array.
    // We allocated extra bytes just for this purpose.
    uint16_t* u16_array = aligned_u16 + (is_aligned ? 0 : 1 + random() % 7);
    float* m256_as_float = (float*)m256_array;

    printf("floats @ %p, uint16_t @ %p expecting %s.\n",
        m256_array, u16_array, expect_okay ? "no error" : "an error");
    
    // Randomize the floats.
    for (size_t i = 0; i < count; ++i) {
        m256_as_float[i] = float(uint32_t(random()) / 65536.6f);
    }
    
    // Add canaries to the end of the u16_array. We expect them not to change.
    for (size_t i = 0; i < 16; ++i) {
        u16_array[i + count] = uint16_t(1000 + i);
    }
    
    // If we expect an error, randomly select one of the floats to replace
    // with an out-of-range float.
    float bad_float = 0.0f;
    size_t bad_float_index = size_t(-1);
    if (!expect_okay) {
        bad_float = int32_t(random() - 0x80000000) * 0.5f;
        if (-0.6 < bad_float && bad_float < 65536.0) {
            bad_float = -13.37;
        }
        printf("%f (bad float)\n", bad_float);
        m256_as_float[bad_float_index = uint32_t(random()) % count] = bad_float;
    }
    
    ftime(&timer_begin);
    bool okay = load_u16_from_m256(u16_array, m256_array, count);
    print_timer_elapsed();
    
    for (size_t i = 0; i < count; ++i) {
        if (u16_array[i] != uint16_t(nearbyintf(m256_as_float[i]))) {
            if (i != bad_float_index) {
                printf("[%zi] %i != %f\n", i, u16_array[i], m256_as_float[i]);
                exit(1);
            }
        }
    }
    
    for (size_t i = 0; i < 16; ++i) {
        if (u16_array[i + count] != uint16_t(1000 + i)) {
            printf("[%zi] Wrote past end of output buffer.\n", i + count);
            exit(1);
        }
    }
    
    if (okay != expect_okay) {
        if (!expect_okay) {
            printf("[%zi] %f should have triggered overflow error.\n",
                bad_float_index, bad_float);
        } else {
            printf("load_u16_from_m256 returned unexpected error.\n");
        }
        exit(1);
    }
    
    free(aligned_u16);
    free(m256_array);
}

static void test_load_m256(size_t count, bool is_aligned) {
    printf("Converting %zi uint16_t to floats (%s).\n",
        count, is_aligned ? "aligned" : "not aligned");
    
    // count rounded up to nearest multiple of 8.
    size_t rounded_count = ((count + 7) & ~7);
    
    __m256* m256_array = (__m256*)aligned_alloc(
        32, rounded_count * sizeof(float));
    uint16_t* aligned_u16 = (uint16_t*)aligned_alloc(
        16, rounded_count * sizeof(uint16_t) + 32);
    
    // If is_aligned is false, intentionally misalign the array.
    // We allocated extra bytes just for this purpose.
    uint16_t* u16_array = aligned_u16 + (is_aligned ? 0 : 1 + random() % 7);
    float* m256_as_float = (float*)m256_array;
    
    printf("floats @ %p, uint16_t @ %p\n", m256_array, u16_array);
    
    // Randomize u16_array.
    for (size_t i = 0; i < count; ++i) {
        u16_array[i] = uint16_t(random());
    }
    
    ftime(&timer_begin);
    load_m256_from_u16(m256_array, u16_array, count);
    print_timer_elapsed();
    
    // Check that the arrays are equal.
    for (size_t i = 0; i < count; ++i) {
        if (u16_array[i] != m256_as_float[i]) {
            printf("[%zi] %i != %f.\n", i, u16_array[i], m256_as_float[i]);
            exit(1);
        }
    }
    
    free(aligned_u16);
    free(m256_array);
}

} // end namespace

int main() {
    using namespace my_stuff;
    using my_stuff::random;
    
    printf("seed = %li\n", long(seed));
    
    for (size_t i = 0; i < 128; ++i) {
        size_t count = 95000000 + random() % 1000000;
        
        test_load_u16(count, random() & 1, random() & 1);
        test_load_m256(count, random() & 1);
    }
}

