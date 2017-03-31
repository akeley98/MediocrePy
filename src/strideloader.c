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
#include "strideloader.h"

#include <errno.h>
#include <stdint.h>
#include <stdio.h>

#include "loaderfunction.h"

#define LOAD_ARRAY(T) \
do { \
    const struct MediocreStride2Array stride_array = arrays[a]; \
    T* data = (T*)stride_array.data; \
    size_t ls_index = arg.command.start_index % stride_array.ls_item_count; \
    size_t ms_index = arg.command.start_index / stride_array.ls_item_count; \
    size_t read_count = 0; \
    float* float_ptr = (float*)(arg.command.output + a); \
    const char* byte_ptr = (const char*)data; \
    byte_ptr += ls_index * stride_array.ls_stride_bytes; \
    byte_ptr += ms_index * stride_array.ms_stride_bytes; \
    int going = 1; \
    while (going) { \
        const char* row_ptr = byte_ptr; \
        while (ls_index != stride_array.ls_item_count) { \
            *float_ptr = (float)*(T*)byte_ptr; \
            read_count++; \
            ++ls_index; \
            byte_ptr += stride_array.ls_stride_bytes; \
            if (read_count == arg.command.length) { \
                going = 0; \
                break; \
            } else if (read_count % 8 == 0) { \
                float_ptr += 8 * arg.input.array_count - 7; \
            } else { \
                ++float_ptr; \
            } \
        } \
        ls_index = 0; \
        byte_ptr = row_ptr + stride_array.ms_stride_bytes; \
    } \
} while (0)

int MediocreStride2Array_loader(struct MediocreLoaderArg arg) {
    struct MediocreStride2Array const* arrays =
        (struct MediocreStride2Array const*)arg.input.arrays;
    
    for (size_t a = 0; a < arg.input.array_count; ++a) {
        switch ((int)arrays[a].type_code) {
          default:
            fprintf(
                stderr, 
                "MediocreStride2Array_loader unknown type code %i.\n",
                (int)arrays[a].type_code
            );
            errno = EINVAL;
            return -1;
          break; case 0xD:
            LOAD_ARRAY(double);
          break; case 0xF:
            LOAD_ARRAY(float);
          break; case 32:
            LOAD_ARRAY(int32_t);
          break; case 16:
            LOAD_ARRAY(int16_t);
          break; case 8:
            LOAD_ARRAY(int8_t);
          break; case 132:
            LOAD_ARRAY(uint32_t);
          break; case 116:
            LOAD_ARRAY(uint16_t);
          break; case 108:
            LOAD_ARRAY(uint8_t);
        }
    }
    return 0;
}

