
#include <assert.h>
#include <math.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "median.h"
#include "testing.h"

static struct Random* generator;
static struct timeb timer_begin;

static const size_t max_offset = 15;           // Array can be offset to test
static const size_t min_array_count = 200;     // for alignment bugs.
static const size_t max_array_count = 200;
static const size_t min_bin_count = 190000;
static const size_t max_bin_count = 200000;
static const uint32_t min_max_iter = 0;
static const uint32_t max_max_iter = 15;

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

static void test_median(
    size_t array_count,
    size_t bin_count,
    size_t offset0,
    size_t offset1,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    printf("Seed = %llu\n", (unsigned long long)get_seed(generator));
    printf("\tMedian of %zi arrays of %zi integers.\n", array_count, bin_count);
    printf("\tinput offset %zi output offset %zi.\n", offset0, offset1);
    printf("sigma[-%f, %f] max_iter %zi\n", sigma_lower, sigma_upper, max_iter);
    
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
    
    // Test the clipped median function.
    ftime(&timer_begin);
    int status = mediocre_clipped_median_mu16(
        output_pointer, input_pointers, array_count, bin_count,
        sigma_lower, sigma_upper, max_iter
    );
    printf("\33[32m\33[1mmedian:       ");
    print_timer_elapsed(timer_begin, array_count * bin_count);
    printf("\33[0m\n");
    
    if (status != 0) {
        perror("mediocre_clipped_median_u16 failed");
        exit(1);
    }
    
    static float sorted[max_array_count];
    
    for (size_t b = 0; b < bin_count; ++b) {
        for (size_t a = 0; a < array_count; ++a) {
            sorted[a] = (float)input_pointers[a][b];
        }
        sort_floats(sorted, array_count);
        size_t current_count = array_count;
        
        float median = 0.5f * (
            sorted[array_count / 2] + sorted[(array_count-1) / 2]
        );
        float lower_bound = -1.f/0.f, upper_bound = 1.f/0.f;
        
        for (size_t iter = 0; iter != max_iter; ++iter) {
            double ss = 0.0;
            for (size_t c = 0; c < current_count; ++c) {
                float n = sorted[c];
                if (n >= lower_bound && n <= upper_bound) {
                    double dev = n - median;
                    ss += dev * dev;
                }
            }
            double sd = sqrt(ss / current_count);
            float new_lb = (float)(median - sigma_lower*sd);
            float new_ub = (float)(median + sigma_upper*sd);
            
            lower_bound = (new_lb < lower_bound) ? lower_bound : new_lb;
            upper_bound = (new_ub > upper_bound) ? upper_bound : new_ub;
            
            size_t new_count = 0;
            for (size_t c = 0; c < current_count; ++c) {
                float n = sorted[c];
                if (n >= lower_bound && n <= upper_bound) {
                    sorted[new_count++] = n;
                }
            }
            current_count = new_count;
            
            median = 0.5f * (
                sorted[current_count / 2] + sorted[(current_count-1) / 2]
            );
        }
        uint16_t median_u16 = (uint16_t)nearbyintf(median);
        if (median_u16 != output_pointer[b]) {
            printf("[%zi] %u != %u\n[", b, median_u16, output_pointer[b]);
            for (size_t a = 0; a < array_count; ++a) {
                printf("%u,", input_pointers[a][b]);
            }
            printf(" ]\n");
            exit(1);
        }
    }
    
    if (check_canary_page(output_page) != 0) {
        printf("Output buffer overrun.\n");
        exit(1);
    }
    
    free_canary_page(input_page);
    free_canary_page(output_page);
}

int main() {
    generator = new_random1(1337);
    
    for (size_t i = 0; i < 60; ++i) {
        size_t array_count = random_dist_u32(
            generator, min_array_count, max_array_count
        );
        size_t bin_count = random_dist_u32(
            generator, min_bin_count, max_bin_count
        );
        size_t offset0 = random_dist_u32(generator, 0, max_offset);
        size_t offset1 = random_dist_u32(generator, 0, max_offset);
        double sigma_lower = 1.0f + 0.25f * random_dist_u32(generator, 0, 12);
        double sigma_upper = 1.0f + 0.25f * random_dist_u32(generator, 0, 12);
        size_t max_iter = random_dist_u32(
            generator, min_max_iter, max_max_iter
        );
        test_median(
            array_count, bin_count, offset0, offset1,
            sigma_lower, sigma_upper, max_iter
        );
    }
}

