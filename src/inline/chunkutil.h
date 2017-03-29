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

#include <assert.h>
#include <errno.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>  // This should change.
#include <immintrin.h>

#include "convert.h" // Replace later to support non-uint16_t input.

struct MediocreLoaderThread;

struct MediocreLoaderThread* mediocre_create_loader_thread(
    void const* input_pointers,
    uintptr_t input_type_code,
    size_t input_pointer_count
);

void mediocre_loader_begin_load(
    struct MediocreLoaderThread*,
    __m256* output,
    size_t start_bin_index,
    size_t end_bin_index
);

void mediocre_loader_wait(struct MediocreLoaderThread*);

void mediocre_delete_loader_thread(struct MediocreLoaderThread*);

#include "testing.h" // XXX

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
        size_t max_iter,
        __m256* scratch
    ),
    size_t input_pointer_count,
    size_t array_bin_count,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    // XXX Rewrite later to support ALL types, not just uint16_t.    
    assert(input_type_code == 116);
    
    if (input_pointer_count == 0) {
        fprintf(stderr, "mediocre: No input pointers.\n");
        errno = EINVAL;
        return -1;
    } else if (array_bin_count == 0) {
        fprintf(stderr, "mediocre: Empty arrays passed.\n");
        errno = EINVAL;
        return -1;
    } else if (sigma_lower < 1. || sigma_upper < 1.) {
        fprintf(stderr,
            "mediocre: Invalid sigma bounds (bounds should be >= 1.0).\n");
        errno = EINVAL;
        return -1;
    } else if (input_pointer_count > 1000000) {
        fprintf(stderr, "mediocre: Too many input pointers.\n");
        errno = E2BIG;
        return -1;
    }
    
    int err = 0;
    const size_t chunk_subarray_count = 256;
    
    // We need four arrays for temporary storage:
    // * The scratch array used for temporary storage by the combine function.
    //   This must be big enough to fit one __m256 for each input array.
    // * The output array for the combine function. This array must be big
    //   enough to fit one __m256 for each subarray in a full-sized chunk.
    // * The loader_output and combine_input arrays must be big enough
    //   to fit chunk_subarray_count subarrays [0 ... input_pointer_count-1]
    //   of __m256 vectors. For each iteration in which we process a chunk
    //   of data, the loader_output and combine_input arrays swap, such that
    //   the loader thread and combine functions work on separate regions of
    //   memory in each iteration, and the combine function takes as input
    //   the output written in the previous iteration by the loader thread.
    // All four arrays will be created at once by allocating a chunk of memory
    // big enough to fit all four arrays and then dividing the memory up.
    const size_t workspace_vector_count =
        + (2 * input_pointer_count * chunk_subarray_count)
        + (chunk_subarray_count)
        + (input_pointer_count);
    
    __m256* workspace = (__m256*)aligned_alloc(
        sizeof(__m256), workspace_vector_count * sizeof(__m256)
    );
    
    if (workspace == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    // Assign different regions of the allocated workspace to each array.
    __m256* workspace_end = workspace + workspace_vector_count;
    __m256* loader_output =
        workspace_end - input_pointer_count*chunk_subarray_count;
    __m256* combine_input =
        loader_output - input_pointer_count*chunk_subarray_count;
    __m256* combine_output =
        combine_input - chunk_subarray_count;
    __m256* scratch =
        combine_output - input_pointer_count;
    
    assert(workspace == scratch);
    
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
        array_bin_count - chunk_count * chunk_group_count;
    size_t current_subarray_count = (current_group_count + 7) / 8;
    mediocre_loader_begin_load(
        loader,
        loader_output,
        chunk_count * chunk_group_count,
        current_group_count
    );
    size_t current_chunk = chunk_count;
    do {
        __m256* temp = loader_output;
        loader_output = combine_input;
        combine_input = temp;
        
        mediocre_loader_wait(loader);
        
        if (current_chunk == 0) {
            mediocre_delete_loader_thread(loader);
        } else {
            // Load the chunk before the chunk being combined.
            mediocre_loader_begin_load(
                loader,
                loader_output,
                (current_chunk-1) * chunk_group_count,
                chunk_group_count
            );
        }
        combine_chunk_function(
            combine_output,
            combine_input,
            input_pointer_count,
            current_subarray_count,
            sigma_lower_vector,
            sigma_upper_vector,
            max_iter,
            scratch
        );
        
        // Again, rewrite the output to be to any type, not just uint16_t.
        if (output_type_code == 116) {
            load_u16_from_m256(
                (uint16_t*)output + current_chunk*chunk_group_count,
                combine_output,
                current_group_count
            );
        } else if (output_type_code == 0xF) {
            memcpy(
                (float*)output + current_chunk*chunk_group_count,
                combine_output,
                sizeof(float) * current_group_count
            );
        } else {
            // XXX
            fprintf(stderr, "Unknown output type %lu.\n", output_type_code);
            err = -1;
        }
        // All chunks will have the same number of subarrays, except for the
        // first one processed (at the END of the input).
        current_subarray_count = chunk_subarray_count;
        current_group_count = chunk_group_count;
        
    } while (current_chunk-- != 0);
    
    free(workspace);
    return err;
}

#endif

