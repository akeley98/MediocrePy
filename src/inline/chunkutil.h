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

#ifndef MediocrePy_INLINE_CHUNKUTIL_H_
#define MediocrePy_INLINE_CHUNKUTIL_H_

#if __STDC_VERSION__ < 201112L || defined(__STDC_NO_THREADS__)
#error "No support for threads.h"
#endif

#include <assert.h>
#include <errno.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <immintrin.h>

#include "convert.h" // Replace later to support non-uint16_t input.

struct MediocreLoaderThread;

struct MediocreLoaderThread* mediocre_create_loader_thread(
    void const* input_pointers,
    uintptr_t input_type_code,
    size_t input_pointer_count
);

void mediocre_loader_load_chunk(
    struct MediocreLoaderThread*,
    __m256* output,
    size_t start_bin_index,
    size_t end_bin_index
);

void mediocre_loader_wait(struct MediocreLoaderThread*);

void mediocre_delete_loader_thread(struct MediocreLoaderThread*);

// TODO explan this somehow.
static inline int process_chunks(
    void* output,
    uintptr_t output_type_code,
    void const* input_pointers,
    uintptr_t input_type_code,
    void (*combine_chunk_function) (
        __m256* chunk_out,
        __m256* chunk_in2D,
        size_t  group_size,
        size_t  subarray_count,
        __m256d sigma_lower,
        __m256d sigma_upper,
        __m256* scratch
    ),
    size_t input_pointer_count,
    size_t array_bin_count,
    size_t max_iter
) {
    // XXX Rewrite later to support ALL types, not just uint16_t.    
    assert(output_type_code == 116);
    assert(input_type_code == 116);
    
    if (input_pointer_count == 0) {
        fprintf(stderr, "No input pointers.\n");
        errno = EINVAL;
        return -1;
    } else if (array_bin_count == 0) {
        fprintf(stderr, "Empty arrays passed.\n");
        errno = EINVAL;
        return -1;
    } else if (sigma_lower < 1. || sigma_upper < 1.) {
        fprintf(stderr, "Invalid sigma bounds (bounds should be >= 1.0).\n");
        errno = EINVAL;
        return -1;
    } else if (input_pointer_count > 1000000) {
        fprintf(stderr, "Too many input pointers.\n");
        errno = E2BIG;
        return -1;
    }
    
    int err = 0;
    const __m256d sigma_lower_vec = _mm256_set1_pd(sigma_lower);
    const __m256d sigma_upper_vec = _mm256_set1_pd(sigma_upper);
    const size_t chunk_subarray_count = 2048;
    
    __m256* workspace = (__m256*)aligned_alloc(
        sizeof(__m256),
        (2 + 2 * input_pointer_count) * chunk_subarray_count * sizeof(__m256)
    );
    
    if (workspace == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    __m256* loader_output = workspace;
    __m256* combine_input =
        workspace + (input_pointer_count * chunk_subarray_count);
    __m256* combine_output =
        workspace + (2 * input_pointer_count * chunk_subarray_count);
    __m256* scratch =
        workspace + (1 + 2 * input_pointer_count) * chunk_subarray_count;
    
    struct MediocreLoaderThread* loader = mediocre_create_loader_thread(
        input_pointers,
        input_type_code,
        input_pointer_count
    );
    
    if (loader == NULL) {
        free(workspace);
        return -1;
    }
    
    const __m256d sigma_lower_vector = _mm256_set1_pd(sigma_lower);
    const __m256d sigma_upper_vector = _mm256_set1_pd(sigma_upper);
    
    const size_t chunk_group_count = chunk_subarray_count * 8;
    const size_t chunk_count = (array_bin_count - 1) / chunk_group_count;
    
    // First chunk to be combined may have fewer subarrays because the number
    // of groups of numbers to be combined (array_bin_count) may not be a
    // perfect multiple of the number of groups in a full chunk.
    size_t current_group_count =
        array_bin_count - chunk_count * chunk_group_count
    size_t current_subarray_count = (current_group_count + 7) / 8;
    mediocre_loader_load_chunk(
        loader,
        loader_output,
        chunk_count * chunk_group_count,
        current_group_count
    );
    do {
        __m256* temp = loader_output;
        loader_output = combine_input;
        combine_input = temp;
        
        mediocre_loader_wait(loader);
        
        if (--chunk_count == 0) {
            mediocre_delete_loader_thread(loader);
        } else {
            // Load the chunk before the chunk being combined.
            mediocre_loader_load_chunk(
                loader,
                loader_output,
                (chunk_count-1) * chunk_group_count,
                chunk_group_count
            );
        }
        combine_chunk_function(
            combine_output,
            combine_input,
            input_pointer_count,
            subarray_count,
            sigma_lower_vector,
            sigma_upper_vector,
            max_iter,
            scratch
        );
        
        // Again, rewrite the output to be to any type, not just uint16_t.
        assert(output_type_code == 116);
        load_u16_from_m256(
            (uint16_t*)output + chunk_count * chunk_group_count,
            combine_output,
            current_group_count
        );
        // All chunks will have the same number of subarrays, except for the
        // first one processed (at the END of the input).
        current_subarray_count = chunk_subarray_count;
        current_group_count = chunk_group_count;
        
    } while (chunk_count != 0);
    
    free(workspace);
    return err;
}

#endif

