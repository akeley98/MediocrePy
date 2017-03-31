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

#ifndef MediocrePy_LOADERFUNCTION_H_
#define MediocrePy_LOADERFUNCTION_H_

#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// There's a limit to the maximum number of arrays because floats are used
// as indices all over the place in the code, but only along the array_count
// axis (so array_length can be very large). This could be something like
// 8388608, I think (actually, in the median, indices come in .5 increments),
// but I'll keep it at a million for now since it's easy to remember and
// gives me some wiggle room for the future.
static const size_t mediocre_max_array_count = (size_t)1e6;

static const int
    mediocre_double_code = 0xD,
    mediocre_float_code = 0xF,
    mediocre_i8_code = 8,
    mediocre_i16_code = 16,
    mediocre_i32_code = 32,
    mediocre_u8_code = 108,
    mediocre_u16_code = 116;

// Structures used for communication between loader thread and calling thread.
struct MediocreInputData {
    void const* arrays;
    size_t array_count;
    size_t array_length;
    void const* extra;
};

struct MediocreLoaderCommand {
    __m256* output;
    size_t start_index;
    size_t length;
};

struct MediocreLoaderArg {
    struct MediocreInputData input;
    struct MediocreLoaderCommand command;
};

typedef int (*mediocre_loader_function)(struct MediocreLoaderArg);

/*  Debug function useful for testing the  correct  operation  of  a  loader
 *  function. For a given invocation of a loader function with the specified
 *  MediocreLoaderArg, the return value of this function  should  match  the
 *  data from input array number which_array at index which_index.
 */
static inline float mediocre_chunk_get(
    struct MediocreLoaderArg arg, size_t which_array, size_t which_index
) {
    float* chunks = (float*)arg.command.output;
    size_t offset = which_array * 8;
    offset += (which_index / 8) * (8 * arg.input.array_count);
    offset += which_index % 8;
    return chunks[offset];
}

#ifdef __cplusplus
}
#endif

#endif

