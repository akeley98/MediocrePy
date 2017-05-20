#ifndef MediocrePy_MEDIOCRE_H_
#define MediocrePy_MEDIOCRE_H_

#include <errno.h>
#include <immintrin.h>
#include <stddef.h>
#include <string.h>

#ifdef __cplusplus
extern "C" {
#endif

/*  Opaque  structures   that   the   implementor   of   MediocreInput   and
 *  MediocreFunctor  instances will be passed a pointer to. These structures
 *  are your masters; you must follow their commands or the library will not
 *  function correctly.
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


typedef struct mediocre_input {
    void (*loop_function)(
        MediocreInputControl* control,
        void const* user_data,
        MediocreDimension dimesion
    );
    void (*destructor)(void* user_data);
    void const* user_data;          // Will be passed to the loop_function.
    MediocreDimension dimension;    // Array count and array sizes.
    
    int nonzero_error;              // MediocreInput implementor should set to
                                    // zero if okay, nonzero to indicate failure
                                    // to construct MediocreInput instance.
} MediocreInput;

typedef struct mediocre_functor {
    void (*loop_function)(
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
 *  array  of floats that is large enough to [input.dimension.width] floats.
 *  thread_count is the number of threads used by the function  to  run  the
 *  combine function; thread_count must be positive, and the total number of
 *  threads used by the function is one more than thread_count (because  the
 *  calling  thread  is used to run the input function). errno is set to the
 *  return value of the function, which is zero if no errors  were  reported
 *  by  either  the  input  function  or the combine functor, and nonzero if
 *  there were errors.
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
 *  commands to user-supplied input loops and combine functor loops, and for
 *  the user to report failures to follow the commands back to the  mediocre
 *  library. These user-supplied loop functions underlie the behavior of the
 *  input and functor arguments to mediocre_combine.
 */
typedef struct mediocre_input_command {
    size_t _exit;
    size_t offset;          // Always divisible by 8.
    MediocreDimension dimension;
    __m256* output_chunks;  // ALWAYS aligned to 32 byte boundary.
} MediocreInputCommand;

MediocreInputCommand mediocre_input_control_get(MediocreInputControl*);

void mediocre_input_error(MediocreInputControl*, int error_code);

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
                          // be aligned to a 32 byte boundary.
} MediocreFunctorCommand;

MediocreFunctorCommand mediocre_functor_control_get(MediocreFunctorControl*);

void mediocre_functor_error(MediocreFunctorControl*, int error_code);

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
 *  Call mediocre_functor_aligned_temp to obtain  32  byte  aligned  storage
 *  that  is  large  enough  to  hold  8  * ceil(width / 8) floats (so it is
 *  guaranteed to be safe to write all output using __m256 pointers even  if
 *  the requested output width is not a multiple of 8). The function returns
 *  NULL (and sets errno) if there is an error. After writing the output (in
 *  the  format  of a flat array of floats, just as the final output through
 *  the command.output pointer is), call mediocre_functor_write_temp to move
 *  the data to the output pointer.
 *  
 *  Combine functor implementors are by  no  means  required  to  use  these
 *  functions: they may write through the output pointer directly as long as
 *  they are careful not to assume alignment and to not write past  the  end
 *  of the array.
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

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // end include guard.

