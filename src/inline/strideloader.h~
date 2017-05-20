#ifndef MediocrePy_STRIDELOADER_H_
#define MediocrePy_STRIDELOADER_H_

#include <stdint.h>

struct MediocreLoaderArg;

struct MediocreStride2Array {
    void const* data;
    uintptr_t type_code;
    uintptr_t ls_item_count;    
    uintptr_t ms_stride_bytes;  // Most significant stride in bytes.
    uintptr_t ls_stride_bytes;  // Least significant stride in bytes.
};

int MediocreStride2Array_loader(struct MediocreLoaderArg arg);

#endif

