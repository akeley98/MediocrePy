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

#ifndef MediocrePy_LOADERTHREAD_H_
#define MediocrePy_LOADERTHREAD_H_

#include <assert.h>
#include <errno.h>
#include <immintrin.h>
#include <pthread.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

struct MediocreLoaderThread;

static inline void* MISSING_FUNCTION(size_t size, size_t alignment) {
    void* result;
    posix_memalign(&result, size, alignment);
    return result;
}

typedef void (*mediocre_combine_function)(
    __m256* output,
    __m256* chunks,
    size_t group_size,      // Equivalent to array count.
    size_t subarray_count,
    __m256d sigma_lower,
    __m256d sigma_upper,
    size_t max_iter,
    __m256* scratch
);

/*  Launch a new loader thread that will start waiting for commands. Returns
 *  null  in  case of a failure to launch the new thread, and a pointer that
 *  can be used to issue commands using the other functions  declared  below
 *  if  sucessful.  Each time a command is received, the function pointed to
 *  by the function pointer is called  with  a  MediocreLoaderArg  structure
 *  initialized  with  a  copy  of the MediocreInputData structure passed to
 *  this function and a copy of the specific command received. The  function
 *  should  return  0  on success and non-zero on failure (in which case the
 *  function  should  also  set  errno,  and  the  loader  thread  will   be
 *  terminated).
 *  
 *  The input_data structure contains void pointers for the array and  extra
 *  data. It is up to the user to ensure that the function pointer passed to
 *  this function casts the void pointers back to the same original  pointer
 *  type  as  was  used  to  initialize the input_data structure. The loader
 *  thread also cannot free any resources on exit. It is up to  the  calling
 *  thread  to  free  any resources used by the data pointed to by array and
 *  extra if needed after the loader thread exits.
 */
struct MediocreLoaderThread* mediocre_new_loader(
    struct MediocreInputData input_data,
    int (*function)(struct MediocreLoaderArg)
);

/*  Waits for the loader thread to finish the last command issued,  if  any,
 *  and  sends  it  a  command  to  load command.bin_count groups of numbers
 *  starting  from  the  index  command.start_index  in  each  target  array
 *  (specified  when the loader thread was created). The output is stored in
 *  chunk format in command.output. Returns 0 on  success  (indicating  that
 *  the  command  was  issued  successfully;  the loader may later report an
 *  error executing the  command).  Returns  -1  on  failure  to  issue  the
 *  command.
 */
int mediocre_loader_begin(
    struct MediocreLoaderThread*, struct MediocreLoaderCommand command
);

/*  Waits for the loader thread to finish its previously issued command.  If
 *  it is not currently working on any command, returns immediately. Returns
 *  0 if the loader finished executing the command  sucessfully,  -1  if  it
 *  failed  to.  If  it failed to execute its command then the loader thread
 *  was terminated, and errno is set to the  errno  value  reported  by  the
 *  loader thread if it was nonzero.
 */
int mediocre_loader_finish(struct MediocreLoaderThread*);

/*  Terminates the loader thread if it is still alive and releases resources
 *  used  by  the control structure. This function should still be called to
 *  free resources even if the thread terminated  abnormally.  The  function
 *  always  sucessfully  frees  resources;  however, an error return code is
 *  still included to report the status of the previous command  issued.  If
 *  the previous command issued was not successfully executed and that error
 *  was not already reported in a call to another loader function, then this
 *  function returns -1 and sets errno. Otherwise, the function returns 0.
 */
int mediocre_delete_loader(struct MediocreLoaderThread*);

static int mediocre_convert_m256(
    void* output,
    int output_type_code,
    size_t output_offset,
    __m256 const* input,
    size_t count
) {
    extern int load_u16_from_m256(uint16_t*, __m256 const*, size_t);
    switch (output_type_code) {
      default:
        fprintf(stderr, "mediocre: Unknown type code %i.\n", output_type_code);
        return -1;
      break; case 0xF: // float
        memcpy(
            (float*)output + output_offset,
            input,
            sizeof(float) * count
        );
      break; case 116: // uint16_t
        return load_u16_from_m256(
            (uint16_t*)output + output_offset,
            input,
            count
        );
    }
    return 0;
}  

// TODO explan this somehow.
static inline int combine_chunks(
    void* output,
    int output_type_code,
    struct MediocreInputData input,
    mediocre_loader_function loader_fn,
    mediocre_combine_function combine,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    if (input.array_count == 0) {
        fprintf(stderr, "mediocre: No input pointers.\n");
        errno = EINVAL;
        return -1;
    } else if (input.array_length == 0) {
        fprintf(stderr, "mediocre: Empty arrays passed.\n");
        errno = EINVAL;
        return -1;
    } else if (sigma_lower < 1. || sigma_upper < 1.) {
        fprintf(stderr,
            "mediocre: Invalid sigma bounds (bounds should be >= 1.0).\n");
        errno = EINVAL;
        return -1;
    } else if (input.array_count > 1000000) {
        fprintf(stderr, "mediocre: Too many input pointers.\n");
        errno = E2BIG;
        return -1;
    }
    
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
        + (2 * input.array_count * chunk_subarray_count)
        + (chunk_subarray_count)
        + (input.array_count);
    
    __m256* workspace = (__m256*)MISSING_FUNCTION(
        sizeof(__m256), workspace_vector_count * sizeof(__m256)
    );
    
    if (workspace == NULL) {
        assert(errno == ENOMEM);
        return -1;
    }
    // Assign different regions of the allocated workspace to each array.
    __m256* workspace_end = workspace + workspace_vector_count;
    __m256* loader_output =
        workspace_end - input.array_count*chunk_subarray_count;
    __m256* combine_input =
        loader_output - input.array_count*chunk_subarray_count;
    __m256* combine_output =
        combine_input - chunk_subarray_count;
    __m256* scratch =
        combine_output - input.array_count;
    
    assert(workspace == scratch);
    
    struct MediocreLoaderThread* mthr = mediocre_new_loader(input, loader_fn);
    
    if (mthr == NULL) {
        perror("mediocre: could not launch loader thread");
        free(workspace);
        return -1;
    }
    
    const __m256d sigma_lower_vector = _mm256_set1_pd(sigma_lower);
    const __m256d sigma_upper_vector = _mm256_set1_pd(sigma_upper);
    
    const size_t chunk_group_count = chunk_subarray_count * 8;
    const size_t chunk_count = (input.array_length - 1) / chunk_group_count;
    
    // First chunk to be combined may have fewer subarrays because the number
    // of groups of numbers to be combined (array_bin_count) may not be a
    // perfect multiple of the number of groups in a full chunk.
    size_t current_group_count =
        input.array_length - chunk_count * chunk_group_count;
    size_t current_subarray_count = (current_group_count + 7) / 8;
    mediocre_loader_begin(
        mthr,
        (struct MediocreLoaderCommand) {
            loader_output,
            chunk_count * chunk_group_count,
            current_group_count
        }
    );
    size_t current_chunk = chunk_count;
    do {
        __m256* temp = loader_output;
        loader_output = combine_input;
        combine_input = temp;
        
        if (mediocre_loader_finish(mthr) != 0) {
            perror("mediocre loader thread error");
            goto fail_delete_loader;
        }
        if (current_chunk == 0) {
            if (mediocre_delete_loader(mthr) != 0) {
                perror("mediocre loader thread error");
                goto fail;
            }
        } else {
            // Load the chunk before the chunk being combined.
            struct MediocreLoaderCommand command = {
                loader_output,
                (current_chunk-1) * chunk_group_count,
                chunk_group_count
            };
            if (mediocre_loader_begin(mthr, command) != 0) {
                perror("mediocre loader thread error");
                goto fail_delete_loader;
            }
        }
        combine(
            combine_output,
            combine_input,
            input.array_count,
            current_subarray_count,
            sigma_lower_vector,
            sigma_upper_vector,
            max_iter,
            scratch
        );
        
        // Convert the combined floats to the output format specified
        // and write it at the appropriate position in the output array.
        int convert_error = mediocre_convert_m256(
            output,
            output_type_code,
            current_chunk * chunk_group_count,
            combine_output,
            current_group_count
        );
        if (convert_error != 0) {
            perror("mediocre float to output conversion error");
            goto fail_delete_loader;
        }
        
        // All chunks will have the same number of subarrays, except for
        // the first one processed (at the END of the input).
        current_subarray_count = chunk_subarray_count;
        current_group_count = chunk_group_count;
        
    } while (current_chunk-- != 0);
    
    free(workspace);
    return 0;
    
    int saved_errno;
  fail_delete_loader:
    saved_errno = errno;
    mediocre_delete_loader(mthr);
    free(workspace);
    errno = saved_errno;
    return -1;
  fail:
    saved_errno = errno;
    free(workspace);
    errno = saved_errno;
    return -1;
}

#endif

