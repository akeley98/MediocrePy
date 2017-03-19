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

#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "convert.h"
#include "testing.h"

static struct timeb timer_begin;
static struct Random* generator;

static void print_timer_elapsed(struct timeb before, size_t item_count) {
    long ms = ms_elapsed(before);
    double ns_per_item = (double)ms * 1e6 / (double)item_count;
    printf("        %lims elapsed (%4.2fns per item).\n", ms, ns_per_item);
}

static void test_load_u16(size_t count, bool is_aligned, bool expect_okay) {
    printf("Converting %zi floats to uint16_t (%s).\n",
        count, is_aligned ? "aligned" : "not aligned");
    
    // count rounded up to nearest multiple of 8.
    size_t rounded_count = ((count + 7) & ~7);
    
    struct CanaryPage m256_page, u16_page;
    
    // Use the canary bytes to force alignment for the u16 test page. If we
    // want aligment, make the canary size exactly the amount that we have to
    // add to the size of the u16 array to make it a multiple of 16 bytes.
    // (CanaryPage aligns based on the total data+canary size requested). If
    // we want it not aligned, request a bit more or less than this number.
    size_t canary_size;
    if (is_aligned) {
        canary_size = (rounded_count - count) * sizeof(uint16_t);
    } else {
        size_t aligned_u16_needed = rounded_count - count;
        size_t x = (aligned_u16_needed + random_dist_u32(generator, 1, 7)) % 8;
        canary_size = x * sizeof(uint16_t);
    }
    if (init_canary_page(&u16_page, count*sizeof(uint16_t), canary_size) < 0) {
        perror("test_load_u16");
        exit(1);
    }
    if (init_canary_page(&m256_page, rounded_count*sizeof(float), 0) < 0) {
        perror("test_load_u16");
        exit(1);
    }
    
    __m256* m256_array = (__m256*)m256_page.ptr;
    float* m256_as_float = (float*)m256_array;
    uint16_t* u16_array = (uint16_t*)u16_page.ptr;
    
    // Touch the arrays to reduce influence of memory slowness on timings.
    memset(m256_array, 42, rounded_count * sizeof(float));
    memset(u16_array, 42, count * sizeof(uint16_t));

    printf("floats @ %p, uint16_t @ %p expecting %s.\n",
        m256_array, u16_array, expect_okay ? "no error" : "an error");
    
    // Randomize the floats.
    for (size_t i = 0; i < count; ++i) {
        m256_as_float[i] = random_u32(generator) / 65536.6f;
    }
    
    // If we expect an error, randomly select one of the floats to replace
    // with an out-of-range float.
    float bad_float = 0.0f;
    size_t bad_float_index = (size_t)-1;
    if (!expect_okay) {
        bad_float = (int32_t)(random_u32(generator) - 0x80000000) * 0.5f;
        if (-0.6 < bad_float && bad_float < 65536.0) {
            bad_float = -13.37;
        }
        printf("%f (bad float)\n", bad_float);
        bad_float_index = random_u32(generator) % count;
        m256_as_float[bad_float_index] = bad_float;
    }
    
    ftime(&timer_begin);
    int error_code = load_u16_from_m256(u16_array, m256_array, count);
    print_timer_elapsed(timer_begin, count);
    
    for (size_t i = 0; i < count; ++i) {
        if ((int)(u16_array[i]) != (int)(nearbyintf(m256_as_float[i]))) {
            if (i != bad_float_index) {
                printf("[%zi] %i != %f\n", i, u16_array[i], m256_as_float[i]);
                exit(1);
            }
        }
    }
    
    bool is_okay = error_code == 0;
    if (is_okay != expect_okay) {
        if (!expect_okay) {
            printf("[%zi] %f should have triggered overflow error.\n",
                bad_float_index, bad_float);
        } else {
            printf("load_u16_from_m256 returned unexpected error.\n");
        }
        exit(1);
    }
    
    int fail1 = check_canary_page(m256_page);
    int fail2 = check_canary_page(u16_page);
    
    free_canary_page(m256_page);
    free_canary_page(u16_page);
    
    if (fail1 < 0 || fail2 < 0) {
        printf("Buffer overrun detected.\n");
        exit(1);
    }
}

static void test_load_and_iadd_m256(size_t count, bool is_aligned) {
    printf("Converting %zi uint16_t to floats (%s).\n",
        count, is_aligned ? "aligned" : "not aligned");
    
    // count rounded up to nearest multiple of 8.
    size_t rounded_count = ((count + 7) & ~7);
    
    struct CanaryPage m256_page, u16_page;
    
    // Use the canary bytes to force alignment for the u16 test page. If we
    // want aligment, make the canary size exactly the amount that we have to
    // add to the size of the u16 array to make it a multiple of 16 bytes.
    // (CanaryPage aligns based on the total data+canary size requested). If
    // we want it not aligned, request a bit more or less than this number.
    size_t canary_size;
    if (is_aligned) {
        canary_size = (rounded_count - count) * sizeof(uint16_t);
    } else {
        size_t aligned_u16_needed = rounded_count - count;
        size_t x = (aligned_u16_needed + random_dist_u32(generator, 1, 7)) % 8;
        canary_size = x * sizeof(uint16_t);
    }
    if (init_canary_page(&u16_page, count*sizeof(uint16_t), canary_size) < 0) {
        perror("test_load_u16");
        exit(1);
    }
    if (init_canary_page(&m256_page, rounded_count*sizeof(float), 0) < 0) {
        perror("test_load_u16");
        exit(1);
    }
    
    __m256* m256_array = (__m256*)m256_page.ptr;
    float* m256_as_float = (float*)m256_array;
    uint16_t* u16_array = (uint16_t*)u16_page.ptr;
    
    // Touch the arrays to reduce influence of memory slowness on timings.
    memset(m256_array, 42, rounded_count * sizeof(float));
    memset(u16_array, 42, count * sizeof(uint16_t));
    
    printf("floats @ %p, uint16_t @ %p\n", m256_array, u16_array);
    
    // Randomize u16_array.
    for (size_t i = 0; i < count; ++i) {
        u16_array[i] = (uint16_t)(random_u32(generator));
    }
    
    ftime(&timer_begin);
    load_m256_from_u16(m256_array, u16_array, count);
    print_timer_elapsed(timer_begin, count);
    
    // Check that the arrays are equal.
    for (size_t i = 0; i < count; ++i) {
        if (u16_array[i] != m256_as_float[i]) {
            printf("[%zi] %i != %f.\n", i, u16_array[i], m256_as_float[i]);
            exit(1);
        }
    }
    
    printf("Adding %zi uint16_t to floats.\n", count);
    
    ftime(&timer_begin);
    iadd_m256_by_u16(m256_array, u16_array, count);
    print_timer_elapsed(timer_begin, count);
    
    // Check that the floats are now double the ints' value (a + a = 2a).
    for (size_t i = 0; i < count; ++i) {
        if (u16_array[i] * 2.0f != m256_as_float[i]) {
            printf("[%zi] %i * 2. != %f.\n", i, u16_array[i], m256_as_float[i]);
            exit(1);
        }
    }
    int fail1 = check_canary_page(m256_page);
    int fail2 = check_canary_page(u16_page);
    
    free_canary_page(m256_page);
    free_canary_page(u16_page);
    
    if (fail1 < 0 || fail2 < 0) {
        printf("Buffer overrun detected.\n");
        exit(1);
    }
}

int main() {
    generator = new_random();
    printf("seed = %lli\n", (long long)get_seed(generator));
    
    for (size_t i = 0; i < 32; ++i) {
        size_t count = random_dist_u32(generator, 300000000, 310000000);
        
        uint32_t bits = random_u32(generator);
        test_load_u16(count, bits & 1, bits & 2);
        test_load_and_iadd_m256(count, bits & 4);
    }
    
    delete_random(generator);
}

