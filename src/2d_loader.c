
#include <stddef.h>
#include <stdint.h>

#include "mediocre.h"

typedef struct mediocre_2D {
    void const* data;
    uintptr_t type_code;
    uintptr_t major_width;
    uintptr_t major_stride;
    uintptr_t minor_width;
    uintptr_t minor_stride;
} Mediocre2D;

#define ALWAYS_INLINE __attribute__((always_inline))

ALWAYS_INLINE
static inline void load_impl(
    __m256* output_chunks,
    Mediocre2D data,
    Mediocre2D mask,
    MediocreDimension request_dimension,
    __m256 (*m256_from_data)(
        const void*, const void*, const void*, const void*, 
        const void*, const void*, const void*, const void*
    ),
    __m256 (*m256_from_mask)(
        const void*, const void*, const void*, const void*, 
        const void*, const void*, const void*, const void*
    )
) {
    __m256* out = output_chunks;
    
    
}

