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

#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "mean.h"
#include "testing.h"

static struct Random* generator;
static struct timeb timer_begin;

static void print_timer_elapsed(struct timeb before, size_t item_count) {
    long ms = ms_elapsed(before);
    double ns_per_item = ms * 1e6 / item_count;
    printf("%lims elapsed (%4.2fns per item).", ms, ns_per_item);
}

static const size_t max_offset = 15;           // Array can be offset to test
static const size_t min_array_count = 1;       // for alignment bugs.
static const size_t max_array_count = 20;
static const size_t min_bin_count = 12000000;
static const size_t max_bin_count = 13000000;
static const uint32_t min_max_iter = 0;
static const uint32_t max_max_iter = 5;

static uint16_t input_data[(max_array_count * max_bin_count) + max_offset + 1];

// Returns reference to static array[0...max_array_count-1] of shuffled numbers
// in range [0, max_array_count).
static const uint32_t* get_shuffled_array_counts() {
    static uint32_t numbers[max_array_count];
    static bool init = false;
    
    if (!init) {
        init = true;
        for (uint32_t i = 0; i < (uint32_t)max_array_count; ++i) {
            numbers[i] = i;
        }
    }
    shuffle_u32(generator, numbers, max_array_count);
    return numbers;
}

static void random_fill(uint16_t* out, size_t bin_count, uint32_t base) {
    for (size_t i = 0; i < bin_count; ++i) {
        uint32_t r = random_u32(generator);
        uint32_t s = random_u32(generator);
        
        uint16_t a = 8 * (uint16_t)r % 1024;
        r /= 1024;
        a += 7 * (uint16_t)r % 1024;
        r /= 1024;
        a += 5 * (uint16_t)r;
        
        a += 7 * (uint16_t)s % 1024;
        s /= 1024;
        a += 7 * (uint16_t)s % 1024;
        s /= 1024;
        a += 3 * (uint16_t)s;
        
        out[i] = a + base;
    }
}

static void test_mean(
    size_t array_count,
    size_t bin_count,
    size_t offset0,
    size_t offset1,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    printf("Seed = %llu\n", (unsigned long long)get_seed(generator));
    printf("\tAveraging %zi arrays of %zi integers.\n", array_count, bin_count);
    printf("\tinput offset %zi output offset %zi.\n", offset0, offset1);    
    
    assert(min_array_count <= array_count && array_count <= max_array_count);
    assert(min_bin_count <= bin_count && bin_count <= max_bin_count);
    assert(offset0 <= max_offset);
    assert(offset1 <= max_offset);
    
    uint16_t* input_pointers[max_array_count];
    for (size_t i = 0; i < max_array_count; ++i) {
        input_pointers[i] = NULL;
    }
    // Assign a random chuck (bin_count uint16_t's wide) of the static 
    // input_data array to each pointer in input_pointers (up to array_count).
    // misalign it by offset0 (* sizeof(uint16_t)) bytes.
    const uint32_t* shuffled = get_shuffled_array_counts();
    for (size_t i = 0; i < array_count; ++i) {
        input_pointers[i] = input_data + (shuffled[i] * bin_count) + offset0;
    }
    
    struct CanaryPage input_page, output_page;
    // Randomly select one array to be replaced by the input canary page array.
    // This tests for overruns occuring while reading.
    if (init_canary_page(&input_page, sizeof(uint16_t) * bin_count, 0) != 0) {
        perror("test_mean init_canary_page");
        exit(1);
    }
    input_pointers[random_dist_u32(generator, 0, array_count - 1)]
        = input_page.ptr;
    
    // The output pointer will also be on a canary page.
    init_canary_page(
        &output_page, sizeof(uint16_t) * bin_count, offset1 * sizeof(uint16_t)
    );
    uint16_t* output_pointer = output_page.ptr;    
    
    // Randomize the data in each input array.
    const uint32_t base = random_dist_u32(generator, 0, 3071);
    for (size_t i = 0; i < array_count; ++i) {
        random_fill(input_pointers[i], bin_count, base);
    }
    
    // First test the normal mean function.
    ftime(&timer_begin);
    int status = mediocre_mean_mu16(
        output_pointer, input_pointers, array_count, bin_count);
    printf("\33[36m\33[1mmean:         ");
    print_timer_elapsed(timer_begin, array_count * bin_count);
    printf("\33[0m\n");
    
    if (status < 0) {
        perror("mediocre_mean_u16 failed");
        exit(1);
    }
    
    for (size_t i = 0; i < bin_count; ++i) {
        float total = 0.0f;
        for (size_t a = 0; a < array_count; ++a) {
            total += (float)input_pointers[a][i];
        }
        uint16_t avg = (uint16_t)nearbyintf(total / (float)array_count);
        if (avg != output_pointer[i]) {
            printf("[%zi] %u != %u\n", i, avg, output_pointer[i]);
            exit(1);
        }
    }
    
    if(check_canary_page(output_page) < 0) {
        printf("Output buffer overrun.\n");
        exit(1);
    }
    memset(output_pointer, 42, bin_count * sizeof(uint16_t));
    
    // Now test the clipped mean function.
    printf("sigma[-%f, %f] max_iter %zi\n", sigma_lower, sigma_upper, max_iter);
    ftime(&timer_begin);
    status = mediocre_clipped_mean_mu16(
        output_pointer, input_pointers, array_count, bin_count,
        sigma_lower, sigma_upper, max_iter
    );
    printf("\33[36m\33[1mclipped mean: ");
    print_timer_elapsed(timer_begin, array_count * bin_count);
    printf("\33[0m\n");
    
    if (status < 0) {
        perror("mediocre_clipped_mean_u16 failed");
        exit(1);
    }
    
    for (size_t i = 0; i < bin_count; ++i) {
        float lower_bound = 0.0f, upper_bound = 65536.0f, clipped_mean;
        for (size_t it = 0; it != max_iter + 1; ++it) {
            float sum = 0.0f, count = 0.0f;
            for (size_t a = 0; a < array_count; ++a) {
                float n = (float)input_pointers[a][i];
                if (n >= lower_bound && n <= upper_bound) {
                    count += 1.0f;
                    sum += n;
                }
            }
            clipped_mean = sum / count;
            double ss = 0.0;
            for (size_t a = 0; a < array_count; ++a) {
                float n = (float)input_pointers[a][i];
                if (n >= lower_bound && n <= upper_bound) {
                    double dev = n - clipped_mean;
                    ss += dev * dev;
                }
            }
            double sd = sqrt(ss / count);
            float new_lb = (float)(clipped_mean - sigma_lower*sd);
            float new_ub = (float)(clipped_mean + sigma_upper*sd);
            
            lower_bound = (new_lb < lower_bound) ? lower_bound : new_lb;
            upper_bound = (new_ub > upper_bound) ? upper_bound : new_ub;
        }
        uint16_t result = (uint16_t)nearbyintf(clipped_mean);
        if (result != output_pointer[i]) {
            printf("[%zi] %u != %u\n[", i, result, output_pointer[i]);
            for (size_t a = 0; a < array_count; ++a) {
                printf(" %u", input_pointers[a][i]);
            }
            printf(" ]\n");
            exit(1);
        }
    }
    
    if(check_canary_page(output_page) < 0) {
        printf("Output buffer overrun.\n");
        exit(1);
    }
    
    free_canary_page(input_page);
    free_canary_page(output_page);
}

int main() {
    generator = new_random();
    
    for (size_t i = 0; i < 24; ++i) {
        size_t array_count = random_dist_u32(
            generator, min_array_count, max_array_count);
        size_t bin_count = random_dist_u32(
            generator, min_bin_count, max_bin_count);
        
        size_t offset0 = random_dist_u32(generator, 0, max_offset);
        size_t offset1 = random_dist_u32(generator, 0, max_offset);
        double sigma_lower = 1.0f + 0.25f * random_dist_u32(generator, 0, 12);
        double sigma_upper = 1.0f + 0.25f * random_dist_u32(generator, 0, 12);
        size_t max_iter = random_dist_u32(
            generator, min_max_iter, max_max_iter
        );
        test_mean(
            array_count, bin_count, offset0, offset1,
            sigma_lower, sigma_upper, max_iter
        );
    }
}
