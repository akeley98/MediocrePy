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

#include "mediocre.h"
#include "testing.h"

static int u16_input_loop(
    MediocreInputControl* control,
    void const* user_data,
    MediocreDimension dimension
) {
    MediocreInputCommand command;
    uint16_t const* const* input_pointers = (uint16_t const* const*)user_data;
    
    (void)dimension;
    
    MEDIOCRE_INPUT_LOOP(command, control) {
        __m256* chunks = command.output_chunks;
        const size_t offset = command.offset;
        size_t array_count = command.dimension.combine_count;
        size_t width = command.dimension.width;
        
        for (size_t array_i = 0; array_i != array_count; ++array_i) {
            uint16_t const* offset_array = input_pointers[array_i] + offset;
            
            for (size_t n = 0; n != width; ++n) {
                float* p = mediocre_chunk_ptr(chunks, array_count, array_i, n);
                
                *p = (float)offset_array[n];
            }
        }
    }
    
    return 0;
}

static void no_op(void* ignored) {
    (void)ignored;
}

static MediocreInput u16_input(
    uint16_t const* const* input_pointers,
    size_t combine_count,
    size_t width
) {
    MediocreInput result;
    
    result.loop_function = u16_input_loop;
    result.destructor = no_op;
    result.user_data = input_pointers;
    result.dimension.combine_count = combine_count;
    result.dimension.width = width;
    result.nonzero_error = 0;
    
    return result;
}

static struct Random* generator;
static struct timeb timer_begin;

static const size_t max_offset = 15;           // Array can be offset to test
static const size_t min_array_count =   1;     // for alignment bugs.
static const size_t max_array_count = 600;
static const size_t min_bin_count = 1;
static const size_t max_bin_count = 500000;
static const uint32_t min_max_iter = 0;
static const uint32_t max_max_iter = 15;
static const int max_thread_count = 15;

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
        &output_page, sizeof(float) * bin_count, offset1 * sizeof(float)
    );
    float* output_pointer = output_page.ptr;    
    
    // Randomize the data in each input array.
    const uint32_t base = random_dist_u32(generator, 0, 3071);
    for (size_t i = 0; i < array_count; ++i) {
        random_fill(input_pointers[i], bin_count, base);
    }
    
    int thread_count = (int)random_dist_u32(generator, 1, max_thread_count);
    
    // Now test the clipped mean function.
    printf("sigma[-%f, %f] max_iter %zi\n", sigma_lower, sigma_upper, max_iter);
    printf("thread_count = %i\n", thread_count);
    ftime(&timer_begin);
    
    
    
    int status = mediocre_combine_destroy(
        output_pointer,
        u16_input(
            (uint16_t const* const*)input_pointers,
            array_count,
            bin_count),
        mediocre_clipped_mean_functor2(sigma_lower, sigma_upper, max_iter),
        thread_count
    );
    
    printf("\33[36m\33[1mclipped mean: ");
    print_timer_elapsed(timer_begin, array_count * bin_count);
    printf("\33[0m\n");
    
    if (status != 0) {
        perror("mediocre_clipped_mean_u16 failed");
        exit(1);
    }
    
    size_t i = bin_count;
    do {
        --i;
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
        if (clipped_mean != output_pointer[i]) {
            printf("[%zi] %f != %f\n[", i, clipped_mean, output_pointer[i]);
            for (size_t a = 0; a < array_count; ++a) {
                printf(" %u", input_pointers[a][i]);
            }
            printf(" ]\n");
            exit(1);
        }
    } while (i != 0);
    
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

