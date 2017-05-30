/*  An aggresively average SIMD combine library.
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

#ifndef MediocrePy_MEDIOCRE_H_
#define MediocrePy_MEDIOCRE_H_

#include <errno.h>
#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

/*  Opaque  structures   that   the   implementor   of   MediocreInput   and
 *  MediocreFunctor  instances will be passed a pointer to. These structures
 *  are your masters; you must follow their commands or the library will not
 *  function correctly. You don't need to worry about this if you are just a
 *  user of the library not trying to extend it with  your  own  combine  or
 *  input algorithms.
 */
struct mediocre_input_control;
typedef struct mediocre_input_control MediocreInputControl;

struct mediocre_functor_control;
typedef struct mediocre_functor_control MediocreFunctorControl;

/*  Structure used to keep track of the size of arrays to be  combined.  The
 *  naming  is  a  bit  awkward  but  was the best that I could come up with
 *  without causing too much  confusion.  combine_count  is  the  number  of
 *  arrays  that  are  to be combined, and width is the number of entries in
 *  each of those arrays that are to be combined. mediocre_combine  combines
 *  [width] groups of [combine_count] numbers from [combine_count] arrays of
 *  size [width] down into a single array of size [width]. (combine_count is
 *  so-named  because  it  represents  the  count  of  numbers  that will be
 *  combined at once).
 */
typedef struct mediocre_dimension {
    size_t combine_count;
    size_t width;
} MediocreDimension;

/*  See the README for discussion on the  chunk  format  and  discussion  on
 *  these  two structures. They are essential for understanding the mediocre
 *  library.
 */
typedef struct mediocre_input {
    int (*loop_function)(
        MediocreInputControl* control,
        void const* user_data,
        MediocreDimension maximum_request
    );
    void (*destructor)(void* user_data);
    void const* user_data;          // Will be passed to the loop_function.
    MediocreDimension dimension;    // Array count and array sizes.
    
    int nonzero_error;              // MediocreInput implementor should set to
                                    // zero if okay, nonzero to indicate failure
                                    // to construct MediocreInput instance.
} MediocreInput;

typedef struct mediocre_functor {
    int (*loop_function)(
        MediocreFunctorControl* control,
        void const* user_data,
        MediocreDimension maximum_request
    );
    void (*destructor)(void* user_data);
    void const* user_data;          // The same user_data pointer will be
                                    // passed to and shared by all threads
                                    // running the loop_function.
                                    
    int nonzero_error;              // MediocreFunctor implementor should set to
                                    // zero if okay, nonzero to indicate failure
                                    // to construct MediocreFunctor instance.
} MediocreFunctor;



/*  Run the destructor that the implementor of this  MediocreInput  instance
 *  supplied  on  this  MediocreInput  instance,  freeing  any  resources it
 *  holds.
 */
static inline void mediocre_input_destroy(MediocreInput arg) {
    arg.destructor((void*)arg.user_data);
}

static inline int mediocre_input_okay(MediocreInput arg) {
    return arg.nonzero_error == 0;
}

/*  Run the destructor that the implementor of this MediocreFunctor instance
 *  supplied  on  this  MediocreFunctor  instance,  freeing any resources it
 *  holds.
 */
static inline void mediocre_functor_destroy(MediocreFunctor arg) {
    arg.destructor((void*)arg.user_data);
}

static inline int mediocre_functor_okay(MediocreFunctor arg) {
    return arg.nonzero_error == 0;
}

/*  Returns the size in bytes of  the  output  array  needed  to  store  the
 *  mediocre_combine output for the specified input.
 */
static inline size_t mediocre_output_sizeof(MediocreInput input) {
    return input.dimension.width * sizeof(float);
}

/*  Allocates  an  array  of  sufficient  size  to  store  the   output   of
 *  mediocre_combine  when  run on the specified input. The function returns
 *  NULL on error (and sets errno) and the returned pointer can be passed to
 *  the standard library free function.
 *  
 *  Note: mediocre_combine does not require that the output array be aligned
 *  to  a 32 byte boundary. We use posix_memalign instead of malloc here for
 *  (potential) performance gains, not because we have to.
 */
static inline float* mediocre_output_alloc(MediocreInput input) {
    void* result;
    size_t bytes = mediocre_output_sizeof(input);
    bytes = (bytes + 31) & ~31; // round up to multiple of 32.
    int status = posix_memalign(&result, 32, bytes);
    if (status != 0) {
        errno = status;
        return NULL;
    } else {
        return (float*)result;
    }
}

/*  Runs the specified combine functor on the  specified  input.  The  input
 *  argument  contains  the  dimension  of the input arrays (array width and
 *  array count [combine_count]). The output pointer must point  to  a  flat
 *  array  of  floats  that  is large enough to hold [input.dimension.width]
 *  floats. thread_count is the number of threads used by  the  function  to
 *  run  the  combine function; thread_count must be positive, and the total
 *  number of threads used by the function is  one  more  than  thread_count
 *  (because the calling thread is used to run the input function). errno is
 *  set to the return value of the function, which is zero if no errors were
 *  reported  by  either  the  input  function  or  the combine functor, and
 *  nonzero if there were errors.
 */
int mediocre_combine(
    float* output,
    MediocreInput input,
    MediocreFunctor functor,
    int thread_count
);

/*  Similar to mediocre_combine, except that the destructor  for  the  input
 *  and  functor  arguments  is  automatically run afterwards (regardless of
 *  whether the function succeeds or fails). The user need not and must  not
 *  manually  destroy  the  input  or  functor  arguments, or re-use them in
 *  another call to the mediocre library.
 */
int mediocre_combine_destroy(
    float* output,
    MediocreInput input,
    MediocreFunctor functor,
    int thread_count
);

/*  Inline function wrapper for mediocre_combine that allows the  caller  to
 *  pass flags that specify which, if any, of the input or functor arguments
 *  that should  be  automatically  destroyed  after  the  combine  finishes
 *  (sucessfully  or  not).  All  other  arguments  are  similar as those in
 *  mediocre_combine.
 */
static inline int mediocre_combine2(
    float* output,
    MediocreInput input,
    int destroy_input,
    MediocreFunctor functor,
    int destroy_functor,
    int thread_count
) {
    int status = mediocre_combine(output, input, functor, thread_count);
    if (destroy_input) mediocre_input_destroy(input);
    if (destroy_functor) mediocre_functor_destroy(functor);
    errno = status;
    return status;
}

/*  Define structures and the function used by the mediocre library to  pass
 *  commands  to  user-supplied input loops and combine functor loops. These
 *  user-supplied loop functions underlie the  behavior  of  the  input  and
 *  functor arguments to mediocre_combine.
 */
typedef struct mediocre_input_command {
    size_t _exit;
    size_t offset;          // Always divisible by 8.
    MediocreDimension dimension;
    __m256* output_chunks;  // ALWAYS aligned to 32 byte boundary.
} MediocreInputCommand;

MediocreInputCommand mediocre_input_control_get(MediocreInputControl*);

#define MEDIOCRE_INPUT_LOOP(command, control) \
for (command = mediocre_input_control_get(control); \
    !command._exit; \
    command = mediocre_input_control_get(control))

typedef struct mediocre_functor_command {
    size_t _exit;
    MediocreDimension dimension;
                          // divide width by 8 to get chunk count.
    __m256* input_chunks; // Implementor MAY overwrite input (workspace memory).
                          // ALWAYS aligned to 32 byte boundary.
    
    float* output;        // The portion of the array that the caller of
                          // mediocre_combine passed that should hold the
                          // combine output currently requested. Might NOT
                          // be aligned to a 32 byte boundary. See
                          // mediocre_functor_aligned_temp.
} MediocreFunctorCommand;

MediocreFunctorCommand mediocre_functor_control_get(MediocreFunctorControl*);

#define MEDIOCRE_FUNCTOR_LOOP(command, control) \
for (command = mediocre_functor_control_get(control); \
    !command._exit; \
    command = mediocre_functor_control_get(control))

/*  The output pointer provided in a command to a combine  functor  loop  is
 *  just a pointer to a portion of the float array provided by the caller of
 *  mediocre_combine. As such, the pointer may not be  that  convenient  for
 *  use  in  a  vectorized  algorithm:  it may not be aligned and it is only
 *  guaranteed (if the mediocre_combine caller did not make  a  mistake)  to
 *  point  to enough space for command.dimension.width floats, which may not
 *  be divisible by 4 or 8. This library provides these helper functions  to
 *  assist implementors of vectorized combine functors.
 *  
 *  Call mediocre_functor_aligned_temp with the command  just  received  and
 *  the  pointer  to the functor control struct for this thread to obtain 32
 *  byte aligned storage that is large enough to hold 8 *  ceil(width  /  8)
 *  floats  (so it is guaranteed to be safe to write all output using __m256
 *  pointers even if the requested output width is not a multiple of 8). The
 *  function  returns  NULL  (and  sets  errno)  if there is an error. After
 *  writing the output (in the format of a flat array of floats, just as the
 *  final    output   through   the   command.output   pointer   is),   call
 *  mediocre_functor_write_temp to move the data to the output pointer.
 *  
 *  Combine functor implementors are by  no  means  required  to  use  these
 *  functions: they may write through the output pointer directly as long as
 *  they are careful not to assume alignment and to not write past  the  end
 *  of the array.
 *  
 *  Note that the pointer returned by this function  may  match  the  output
 *  pointer  specified  by the command if the output pointer already matches
 *  the requirements for the return pointer  guaranteed  by  this  function.
 *  Implementors   may   call   mediocre_functor_write_temp   in  this  case
 *  regardless; they do not need to check for this condition.
 */
__m256* mediocre_functor_aligned_temp(
    MediocreFunctorCommand, MediocreFunctorControl*
);

static inline void mediocre_functor_write_temp(
    MediocreFunctorCommand command, __m256 const* aligned_temp
) {
    if ((void*)aligned_temp != (void*)command.output) {
        memcpy(
            command.output,
            aligned_temp,
            sizeof(float) * command.dimension.width
        );
    }
}

/*  Function to help humans deal with the chunk format. The chunk format  is
 *  designed the way that it is for a reason: algorithms using this function
 *  may not be the most optimal functions for working  with  data  in  chunk
 *  format.  Anyway,  callers provide a pointer to chunks, the combine_count
 *  of the arrays whose data is now  in  the  chunks  (combine_count  =  the
 *  number  of  arrays  =  the number of __m256 vectors in a chunk), and the
 *  coordinates of the data they want along the combine axis and  the  width
 *  axis, which specifies which array's data desired and the position within
 *  the array of the data desired,  respectively.  The  function  returns  a
 *  pointer to the float data requested.
 */
static inline float* mediocre_chunk_ptr(
    __m256* chunks, size_t combine_count, size_t combine_axis, size_t width_axis
) {
    // Each chunk is sizeof(__m256) * combine_count bytes, because it consists
    // of 8 lanes of combine_count vectors to be combined. The index of the
    // chunk we want is width_axis / 8, as 8 items per array are stored
    // within each chunk.
    __m256* chunk_ptr = chunks + ((width_axis / 8) * combine_count);
    // Now we want the __m256 vector corresponding to the specific original
    // array requested (combine_axis). Each vector in a chunk corresponds to
    // data from one of the combine_count arrays that were to be combined.
    __m256* vector_ptr = chunk_ptr + combine_axis;
    // Get the correct lane within the vector.
    return ((float*)vector_ptr) + (width_axis % 8);
}

/*  Same as mediocre_chunk_ptr, but rather than returning a pointer  to  the
 *  data with the specified coordinates, it returns the data itself.
 */
static inline float mediocre_chunk_data(
    __m256 const* chunks, size_t combine_count,
    size_t combine_axis, size_t width_axis
) {
    __m256* ptr = (__m256*)chunks;
    return *mediocre_chunk_ptr(ptr, combine_count, combine_axis, width_axis);
}

MediocreFunctor mediocre_mean_functor();

MediocreFunctor mediocre_clipped_mean_functor2(
    double sigma_lower, double sigma_upper, size_t max_iter
);

static inline MediocreFunctor mediocre_clipped_mean_functor(
    double sigma, size_t max_iter
) {
    return mediocre_clipped_mean_functor2(sigma, sigma, max_iter);
}


MediocreFunctor mediocre_scaled_mean_functor2(
    float const* scale_factors,
    size_t scale_count,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
);

static inline MediocreFunctor mediocre_scaled_mean_functor(
    float const* scale_factors,
    size_t scale_count,
    double sigma,
    size_t max_iter
) {
    return mediocre_scaled_mean_functor2(
        scale_factors, scale_count, sigma, sigma, max_iter
    );
}


MediocreFunctor mediocre_median_functor();

MediocreFunctor mediocre_clipped_median_functor2(
    double sigma_lower, double sigma_upper, size_t max_iter
);

static inline MediocreFunctor mediocre_clipped_median_functor(
    double sigma, size_t max_iter
) {
    return mediocre_clipped_median_functor2(sigma, sigma, max_iter);
}

/*  Functions for creating MediocreInput instances that load  data  from  1D
 *  arrays.  There  are  MediocreDimension.combine_count  arrays,  each with
 *  MediocreDimension.width entries. The functions all take a pointer to  an
 *  array  of  pointers  to  arrays.  The array of pointers has its contents
 *  copied into the MediocreInput returned, so that array may be freed after
 *  the  function  returned.  However,  the  data pointed to by the pointers
 *  within the array of pointers is NOT copied; it must not be freed as long
 *  as the returned MediocreInput is in use.
 *  
 *  The destructor for the MediocreInput returned here only frees  resources
 *  created  for the MediocreInput instance created by the call; it does not
 *  free the array of pointers passed nor  any  data  pointed  to  by  those
 *  pointers. That is the caller's responsibility.
 */
MediocreInput mediocre_i8_input(int8_t const* const*, MediocreDimension);
MediocreInput mediocre_i16_input(int16_t const* const*, MediocreDimension);
MediocreInput mediocre_i32_input(int32_t const* const*, MediocreDimension);
MediocreInput mediocre_i64_input(int64_t const* const*, MediocreDimension);
MediocreInput mediocre_u8_input(uint8_t const* const*, MediocreDimension);
MediocreInput mediocre_u16_input(uint16_t const* const*, MediocreDimension);
MediocreInput mediocre_u32_input(uint32_t const* const*, MediocreDimension);
MediocreInput mediocre_u64_input(uint64_t const* const*, MediocreDimension);
MediocreInput mediocre_float_input(float const* const*, MediocreDimension);
MediocreInput mediocre_double_input(double const* const*, MediocreDimension);

// Workaround for stupid C rules about T const* const* to T* const* conversions.
static inline MediocreInput
mediocre_mi8_input(int8_t* const* ptr, MediocreDimension dim) {
    return mediocre_i8_input((int8_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mi16_input(int16_t* const* ptr, MediocreDimension dim) {
    return mediocre_i16_input((int16_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mi32_input(int32_t* const* ptr, MediocreDimension dim) {
    return mediocre_i32_input((int32_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mi64_input(int64_t* const* ptr, MediocreDimension dim) {
    return mediocre_i64_input((int64_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mu8_input(uint8_t* const* ptr, MediocreDimension dim) {
    return mediocre_u8_input((uint8_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mu16_input(uint16_t* const* ptr, MediocreDimension dim) {
    return mediocre_u16_input((uint16_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mu32_input(uint32_t* const* ptr, MediocreDimension dim) {
    return mediocre_u32_input((uint32_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mu64_input(uint64_t* const* ptr, MediocreDimension dim) {
    return mediocre_u64_input((uint64_t const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mfloat_input(float* const* ptr, MediocreDimension dim) {
    return mediocre_float_input((float const* const*)ptr, dim);
}
static inline MediocreInput
mediocre_mdouble_input(double* const* ptr, MediocreDimension dim) {
    return mediocre_double_input((double const* const*)ptr, dim);
}

// Type codes (see below). These shouldn't ever change.
static const int
    mediocre_i8_code = 8,
    mediocre_i16_code = 16,
    mediocre_i32_code = 32,
    mediocre_i64_code = 64,
    mediocre_u8_code = 108,
    mediocre_u16_code = 116,
    mediocre_u32_code = 132,
    mediocre_u64_code = 164,
    mediocre_float_code = 0xF,   // 15
    mediocre_double_code = 0xD ; // 13

/*  Structure intended for  holding  a  borrowed  pointer  to  a  2D  array.
 *  (Borrowed  in  the  sense that the structure does not manage/free the 2D
 *  array, and depends on others to ensure that the array is not deleted too
 *  early,  leaving  a  dangling  pointer). The data type of the 2D array is
 *  specified at runtime through the type_code variable, which must  be  one
 *  of  the  valid  type  codes  declared  above.  For a row major 2D array,
 *  major_width and major_stride will be the row count and distance in bytes
 *  between  rows,  and  minor_width  and minor_stride will be the number of
 *  items per row and the distance in bytes between items in the same row.
 */
typedef struct mediocre_2D {
    void const* data;
    uintptr_t type_code;
    uintptr_t major_width;
    uintptr_t major_stride;
    uintptr_t minor_width;
    uintptr_t minor_stride;
} Mediocre2D;

/*  Pair of 2D arrays that represent a rectangle of data and  a  rectangular
 *  mask  for  the data. Each entry of coordinate (x,y) in the mask 2D array
 *  specifies whether the corresponding entry of  coordinate  (x,y)  in  the
 *  data  array  is  good or bad. The user will. specify elsewhere whether a
 *  zero mask entry or a nonzero mask entry indicates a bad data entry.  The
 *  data and mask arrays should have the same major and minor width, but may
 *  have different strides and type codes.
 */
typedef struct mediocre_masked_2D {
    Mediocre2D data_2D, mask_2D;
} MediocreMasked2D;

/*  Create a MediocreInput instance that loads & masks data from an array of
 *  [count]  MediocreMasked2D  instances. The array of MediocreMasked2D will
 *  be copied to the MediocreInput instance's internal  storage;  the  array
 *  passed  may  be  freed at any time after calling this function. However,
 *  the data pointed to by the MediocreMasked2D instances is NOT copied, and
 *  must  not  be  freed  for  the  duration  of  the returned MediocreInput
 *  instance's existence.
 *  
 *  The destructor does NOT free the data pointed to by the MediocreMasked2D
 *  instances. The destructor only deletes the internal copy of the array of
 *  MediocreMasked2D instances.
 *  
 *  The user specifies through the nonzero_means_bad variable whether a zero
 *  or  nonzero  entry  in  a  mask  array  specifies  a  bad  value  in the
 *  corresponding data array.
 */
MediocreInput mediocre_2D_masked_input(
    MediocreMasked2D const* masked_arrays,
    size_t count,
    int nonzero_means_bad
);

/*  Create a MediocreInput instance that loads data from an array of [count]
 *  Mediocre2D  instances.  The  array  of  Mediocre2D will be copied to the
 *  MediocreInput instance's internal storage; the array passed may be freed
 *  any  time  after  calling this function. However, the data pointed to by
 *  the Mediocre2D instances is NOT copied, and must not be  freed  for  the
 *  duration of the returned MediocreInput instance's existence.
 *  
 *  The destructor for the MediocreInput instance returned does NOT free the
 *  data pointed to by the Mediocre2D instances. The destructor only deletes
 *  the internal copy of the array of Mediocre2D instances.
 */
MediocreInput mediocre_2D_input(Mediocre2D const* arrays, size_t count);

/*  Functions for wrapping  arrays  of  different  shapes  (row-major  2D  C
 *  arrays:  c2d,  colmun-major  2D  Fortran arrays: f2d, and 1D arrays) and
 *  different types (i8 int8_t, u64 uint64_t, etc.) as Mediocre2D instances.
 *  For  Fortran  arrays  the  output of mediocre_combine will be a 1D array
 *  packed in C order; if both the input and output should be fortran arrays
 *  then use the c2d functions, not the f2d. Two wrongs make a right in that
 *  case. As mentioned, the Mediocre2D instance just borrows the pointer.
 *  
 *  For 2D arrays that are not packed (i.e. have gaps so  that  the  strides
 *  are  not  what  we'd  expect  for  either  C  or  Fortran  arrays), just
 *  initialize a Mediocre2D instance yourself with your pointer, the correct
 *  type code, and the major and minor widths and strides.
 */
static inline Mediocre2D as_mediocre_2D_i8_c2d(
    int8_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int8_t);
    Mediocre2D result = {ptr, 8, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i8_f2d(
    int8_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int8_t);
    Mediocre2D result = {ptr, 8, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i8(
    int8_t const* ptr, size_t count
) {
    size_t sz = sizeof(int8_t);
    Mediocre2D result = {ptr, 8, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i16_c2d(
    int16_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int16_t);
    Mediocre2D result = {ptr, 16, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i16_f2d(
    int16_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int16_t);
    Mediocre2D result = {ptr, 16, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i16(
    int16_t const* ptr, size_t count
) {
    size_t sz = sizeof(int16_t);
    Mediocre2D result = {ptr, 16, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i32_c2d(
    int32_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int32_t);
    Mediocre2D result = {ptr, 32, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i32_f2d(
    int32_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int32_t);
    Mediocre2D result = {ptr, 32, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i32(
    int32_t const* ptr, size_t count
) {
    size_t sz = sizeof(int32_t);
    Mediocre2D result = {ptr, 32, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i64_c2d(
    int64_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int64_t);
    Mediocre2D result = {ptr, 64, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i64_f2d(
    int64_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(int64_t);
    Mediocre2D result = {ptr, 64, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_i64(
    int64_t const* ptr, size_t count
) {
    size_t sz = sizeof(int64_t);
    Mediocre2D result = {ptr, 64, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u8_c2d(
    uint8_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint8_t);
    Mediocre2D result = {ptr, 108, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u8_f2d(
    uint8_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint8_t);
    Mediocre2D result = {ptr, 108, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u8(
    uint8_t const* ptr, size_t count
) {
    size_t sz = sizeof(uint8_t);
    Mediocre2D result = {ptr, 108, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u16_c2d(
    uint16_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint16_t);
    Mediocre2D result = {ptr, 116, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u16_f2d(
    uint16_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint16_t);
    Mediocre2D result = {ptr, 116, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u16(
    uint16_t const* ptr, size_t count
) {
    size_t sz = sizeof(uint16_t);
    Mediocre2D result = {ptr, 116, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u32_c2d(
    uint32_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint32_t);
    Mediocre2D result = {ptr, 132, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u32_f2d(
    uint32_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint32_t);
    Mediocre2D result = {ptr, 132, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u32(
    uint32_t const* ptr, size_t count
) {
    size_t sz = sizeof(uint32_t);
    Mediocre2D result = {ptr, 132, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u64_c2d(
    uint64_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint64_t);
    Mediocre2D result = {ptr, 164, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u64_f2d(
    uint64_t const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(uint64_t);
    Mediocre2D result = {ptr, 164, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_u64(
    uint64_t const* ptr, size_t count
) {
    size_t sz = sizeof(uint64_t);
    Mediocre2D result = {ptr, 164, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_float_c2d(
    float const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(float);
    Mediocre2D result = {ptr, 0xf, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_float_f2d(
    float const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(float);
    Mediocre2D result = {ptr, 0xf, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_float(
    float const* ptr, size_t count
) {
    size_t sz = sizeof(float);
    Mediocre2D result = {ptr, 0xf, 1, count*sz, count, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_double_c2d(
    double const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(double);
    Mediocre2D result = {ptr, 0xd, rows, columns*sz, columns, sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_double_f2d(
    double const* ptr, size_t rows, size_t columns
) {
    size_t sz = sizeof(double);
    Mediocre2D result = {ptr, 0xd, columns, sz, rows, columns*sz};
    return result;
}
static inline Mediocre2D as_mediocre_2D_double(
    double const* ptr, size_t count
) {
    size_t sz = sizeof(double);
    Mediocre2D result = {ptr, 0xd, 1, count*sz, count, sz};
    return result;
}

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // end include guard.

