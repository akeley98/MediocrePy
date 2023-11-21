# mediocre and MediocrePy

An aggressively average SIMD combine library (single-precision float array averages with sigma clipping), and Python 2 and Python 3 interfaces for it. The library includes the mean, median, and sigma-clipped mean array combine algorithms, can handle 1-or-2 dimensional input arrays (including Fortran order and non-contiguous arrays) of any primitive data type (8/16/32/64 bit signed/unsigned integer, 32/64 bit float), and is designed with parallelism and extensibility in mind.

## Building

I provided a makefile that uses clang as the C and C++ compiler. I used `clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)` in development. You can change the compiler in the makefile, but this program is not exactly the most portable program: if you switch the compiler, be aware that the program uses Intel compiler style intrinsics (`__mm256_frobnicate_epu32`). Also, this program depends on `pthread` and `posix_memalign`. It's not designed with non-Unix systems in mind. Running `make` in the root directory for the project should create the library `bin/mediocre.so` for the project.

There's only one header file for C programs for this library: `include/mediocre.h`. The header file is well-documented (I hope!) and can be used as a reference while using this library. Feel free to statically link the four files `bin/mean.s bin/median.s bin/input.s bin/combine.s` into your program if you don't want to depend on a `.so` library.

If you are planning to use this library in a Python program, first build the C library (run `make` from the terminal in the root directory for the project), then copy the entire directory into your project. The root directory serves as the module's directory (i.e., `import MediocrePy` should work when run in the directory that holds the root directory that you just copied). This README describes the purpose and usage of the library mainly from a C programmer's perspective: the Python documentation is provided in docstrings of the Python module. I used `Python 2.7.12 (default, Nov 19 2016, 06:48:10) [GCC 5.4.0 20160609] on linux2` and `numpy 1.11.0` (required dependency) in development. I tested the Python 3 port with `Python 3.6.7 (default, Oct 22 2018, 11:32:17) [GCC 8.2.0] on linux`.

## First, a word of warning

Internally, the library uses 256-bit vector types everywhere. This will require the FMA3 and AVX2 instruction sets (most >= 2014 Intel/AMD CPUs). If your computer has a CPU older than this, or a non-x64 CPU (e.g. Apple Silicon), it won't be able to run this code (not because the CPU is too slow, but because it won't understand the instructions used in the program. It would be like reading Dr. Seuss to your goldfish).

Keep in mind that compilers are often no help when it comes to memory alignment for such vector data types, so be vigilant. If you are a user of the library just looking to use the default combine and input methods, you don't have to worry about alignment all that much.

Please be cautious when using this library on overclocked computers or poorly-cooled laptops! AVX instructions are known to produce more heat than typical instructions. A computer that appears stable because it can handle "100%" CPU load may have latent instability revealed by a program like this one, which really comes much closer to using 100% of the CPU.

## Introduction (skip to here when you tire of reading the warning!)

This library was written to solve the problem of writing high-performance combine routines using vectorization. A combine routine takes a stack of identically-sized input arrays and combines it into a single output array of the same size, where each entry of the output array (with index `I`) ideally depends only on the data stored at index `I` of each input array. Let me draw you a picture to illustrate:

        input 0: w0, w1, w2, w3, w4, w5
        input 1: x0, x1, x2, x3, x4, x5
        input 2: y0, y1, y2, y3, y4, y5
        input 3: z0, z1, z2, z3, z4, z5
        
        output : a0, a1, a2, a3, a4, a5
    
where `a0` is `f(w0, x0, y0, z0)`, `a1` is `f(w1, x1, y1, z1)`, and so on. `f` could be the mean function, median function, or some more sophisticated function. Here, we say that `combine_count` is 4 (because we are combining 4 input arrays into a single output array) and that `width` is 6 (because each array is 6 entries wide). I tend to refer to a group of numbers that is combined into a single value in the output as a 'column' of data.

This library aims to solve this combine problem (for single precision, 32 bit floats) by doing two things: first, by providing a collection of default input functions and high-performance combine functions , and second, by providing an interface through which programmers can implement their own vectorized combine and input functions that are compatible with those provided by the library. The library specifies a chunk format, which is how the input and combine functions communicate with each other.

This is a good time for me to point out that different parts of the README are relevant for you to read depending on your needs. If you are interested in the library mainly for the first thing it provides, the default combine methods, then you shouldn't have to listen to me blather on about chunk format: skip ahead to and read just the "High Level Description" section. If however you are interested in implementing your own combine algorithm or a new method of data input, or you are interested in how the library itself is organized and implemented, read onwards.

Input arrays can come in lots of different shapes and sizes, can take a long time to load, and generally are not in formats convenient for writing vectorized code. The input could be from a bunch of fortran-order arrays of 36 bit integers. It could be coming from a memory mapped FITS file stored on Neptune. It could be from a human-readable list of numbers written out in Yiddish. (Implementing these input methods is left as an exercise for the reader). We want to make it so that one combine algorithm can be run on any input, we want that combine algorithm to be supplied with input in a format designed with vectorization in mind, and we want the combine algorithm to spend as little time as possible stalled waiting on input. To this end, the library separates the responsibility of loading input from the responsibility of combining the input, the library specifies the vectorization-friendly chunk format as the method in which input algorithms provide data to combine algorithms, and it runs input algorithms on a separate thread from combine algorithms.

I provided an Input & Combine Implementors' Guide that you should read to learn how to implement function compatible with the library. I also wrote some brief design notes if you are interested in the library implementation itself (I should expand them later). In any case, also consider skimming the following high level description and reading the first part of the Implementors' guide to see documentation on chunks.

## High Level Description

It was a bit inaccurate for me to say that the library allows for programmers to implement input and combine functions. What's really being implemented are input structures and combine functor structures (Known as MediocreInput and MediocreFunctor in the code). You need to create one instance of each in order to start combining. Consider the following example:
        
    #include <stdio.h>
    #include "mediocre.h"
    // Average three arrays of [array_width] floats into one array
    // of [array_width] floats. Returns 0 if successful, a nonzero
    // error code if not successful.
    int mean_three_arrays(
        float* output,
        float const* input0,
        float const* input1,
        float const* input2,
        size_t array_width
    ) {
        int err;

        // Part 1
        float const* input_pointers[3] = { input0, input1, input2 };
        MediocreDimension dim;
        dim.combine_count = 3;      // We are combining 3 arrays.
        dim.width = array_width;    // Each array is this wide.
        MediocreInput input = mediocre_float_input(input_pointers, dim);
        
        // Part 3a
        if (input.nonzero_error != 0) {
            fprintf(stderr, "MediocreInput not constructed.\n");
            return -1;
        }
        
        // Part 2
        MediocreFunctor combine_functor = mediocre_mean_functor();
        
        // Part 3b
        if (combine_functor.nonzero_error != 0) {
            fprintf(stderr, "MediocreFunctor not constructed.\n");
            mediocre_input_destroy(input);
            return -1;
        }
        
        // Part 4
        err = mediocre_combine(output, input, combine_functor, 2);

        // Part 5
        mediocre_functor_destroy(combine_functor);
        mediocre_input_destroy(input);
        
        return err;
    }

    // Simple test program.
    int main() {
        float input0[12] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };
        float input1[12] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
        float input2[12] = { 0, 300, 0, 300, 0, 300, 0, 300, 0, 300, 0, 300 };
        
        float output[12];
        
        int err = mean_three_arrays(output, input0, input1, input2, 12);
        
        printf("Error code %i\n", err);
        for (int i = 0; i < 12; ++i) {
            printf("[%2i] = %f\n", i, output[i]);
        }
        return 0;
    }

In part 1 we create a MediocreInput instance that describes the data that we want combined, including the dimensions of the data we want to combine (as a MediocreDimension structure). In this case, we call `mediocre_float_input`, one of the default functions for creating MediocreInput instances provided by the library; this creates a MediocreInput instance describing input from a list of 1D C arrays of floats. Keep in mind that, in general, MediocreInput instances only describe data; they don't contain them. This means that it may be unsafe to free data passed to such functions while the MediocreInput they've returned is in use. Each function returning MediocreInput instances should document their exact requirements.

In part 2 we create a MediocreFunctor instance that describes the combine algorithm we want to run. In this case we want to take the mean of each column of data. `mediocre_mean_functor` returns a functor that does just that. Other functions returning MediocreFunctor instances may take arguments; this one doesn't. The library also includes more sophisticated combine algorithms such as the median and sigma clipped mean algorithms.

In part 3 we check the error field of the input and functor instances to see any function failed to initialize the structure they were supposed to. `IN THIS LIBRARY, ZERO ALWAYS MEANS SUCCESS AND NON-ZERO INDICATES AN ERROR`. You don't have to check this; `mediocre_combine` will also check for an error code, forwarding any error codes and cancelling the combine if needed.

While we're talking about conventions, I may as well mention that if you prefer to write out structure types with the `struct` prefix and `all_lowercase` names in traditional C style, all (user-visible) structure types with typedef names of the form `MediocreFooBar` in the library can also be referred to in the form `struct mediocre_foo_bar`.

In part 4 we actually run the combine algorithm. Call `mediocre_combine` to do this. It takes a pointer to an array of floats where the output will be stored, one instance each of MediocreInput and MediocreFunctor, and the count of the number of threads to run combine algorithms on. The output will always be written as a flat, continuous C array of floats regardless of the format of the input. `mediocre_combine` will forward a nonzero error code if any errors are reported by the input algorithm or combine algorithm.

The MediocreInput and MediocreFunctor instances may hold resources. In part 5 we release those resorces held by the MediocreInput instance and MediocreFunctor instance by calling `mediocre_functor_destroy` and `mediocre_input_destroy` respectively. These functions, and the functions supplied by MediocreInput and MediocreFunctor implementors that are called to free resources, are expected to never fail when used properly (i.e. called exactly once for each initialized MediocreInput / MediocreFunctor instance).

Some convenience functions are defined in the library. `mediocre_output_sizeof` and `mediocre_output_alloc` help with allocating space for holding combine outputs. `mediocre_combine_destroy` and `mediocre_combine2` can automatically free resources held by MediocreInput and MediocreFunctor instances after the combine is finished. For now their documentation is in the header file `mediocre.h`; look around in there to find out more. Note also that all data is loaded as single precision floating point data regardless of the format and data type of the input data. The functions returning MediocreInput instances describing double-precision data are provided for convenience only; they don't indicate any support for double-precision levels of accuracy.

## Input & Combine Implementors' Guide (a.k.a. A treatise on chunk format)

Now I will describe the terrifying chunk format that I've been hinting at for so long. The chunk format is designed to make computers happy at the expense of humans. Once again I will draw a picture first, in order to illustrate how input arrays are packed into chunk format, but first I'd like to point out that `__m256` is a vector of 8 single precision floats, if you didn't already know.
        
        combine_count = 4    width = 11
        input is 4 conceptual arrays that will be loaded by MediocreInput.
        
        input 0: w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10
        input 1: x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10
        input 2: y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10
        input 3: z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10
        
        chunks (__m256): [ w0, w1, w2, w3, w4, w5, w6, w7 ]  (CHUNK 0)
                         [ x0, x1, x2, x3, x4, x5, x6, x7 ]
                         [ y0, y1, y2, y3, y4, y5, y6, y7 ]
                         [ z0, z1, z2, z3, z4, z5, z6, z7 ]
                         [ w8, w9, w10, -,  -,  -,  -,  - ]  (CHUNK 1)
                         [ x8, x9, x10, -,  -,  -,  -,  - ]
                         [ y8, y9, y10, -,  -,  -,  -,  - ]
                         [ z8, z9, z10, -,  -,  -,  -,  - ]
        
In words, a group of input arrays is converted to chunk format by packing 8 columns of the input arrays at a time into a chunk. Each chunk consists of `combine_count __m256` vectors, with each vector holding 8 entries from exactly one of the input arrays. Chunk `N` holds data from columns `N*8` to `N*8 + 7`, with vector `V` of the chunk holding input from input array `V`.

        BTW, _mm256_set_ps has its arguments in backwards order for some reason.

The chunk format is a bit confusing because it's neither row-major nor column-major. Instead it's sort of this 3D layout where both the most and least significant dimensions correspond to the width axis. It'll make more sense once I explain the reason it's designed this way: it makes it possible for vectorized combine algorithms to combine 8 columns of data at a time while reading as small a portion of memory as possible. You can see how easily chunk 0 can be combined into the output `[a0, a1, a2, a3, a4, a5, a6, a7]`, and how chunk 1 can be combined into `[a8, a9, a10, 0, 0, 0, 0, 0]`. A vectorized combine algorithm can calculate 8 results at a time (1 for each lane of the 8 lanes in a vector) just by reading in `combine_count` vectors at a time (4 in this case), with all computation for a single column of data confined to a single lane of a vector. The functions `mediocre_chunk_ptr` and `mediocre_chunk_data` may be helpful for dealing with the chunk format: they let you index chunk data more-or-less like it were a normal 2D array.

A MediocreInput instance will be tasked with converting data into chunk format. You may wish to implement a new kind of MediocreInput in order to allow the library to process new kinds of arrays, with the work of loading data from arrays being done in parallel with the combine work, rather than strictly before the combine work (as would occur if you converted those arrays to a format already known to the library before calling `mediocre_combine` - a totally valid solution if it is acceptably efficient).

A MediocreFunctor instance will be tasked with combining data in chunk format. You may wish to implement a new kind of MediocreFunctor if you want to design a new algorithm for combining data while taking advantage of the parallelism and asynchronous input loading capabilities provided by the mediocre library.

As an aspiring MediocreInput or MediocreFunctor implementor, you will write a factory function that will return 5 or 4 things to the user through a MediocreInput or MediocreFunctor structure:

A loop function that will poll for and execute commands (load or combine data) given by the mediocre library. It should return nonzero if it encounters an error and zero if it is successful. I'll explain the structure and requirements on this function later. For now just know that this is where most of the behavior for your new input or combine algorithm will be implemented.

A void pointer to "user data", which holds data you need to do your job. This could be, for example, a structure of arguments that customize the behavior of your algorithm (e.g., for the library's sigma-clipped algorithms, user_data stores sigma bounds and maximum iterations). This pointer will be passed to and should be cast to the actual type of the user data in the functions that you implement.

A destructor function that frees resources held by the user data. This is what gets called by `mediocre_input_destroy` and `mediocre_functor_destroy`. The prototype matches the prototype of `free`, so `free` can be used as the destructor if the only resource held by the user data is the memory it occupies.

An error code that should be nonzero if the factory function failed to properly initialize the MediocreInput or MediocreFunctor structure. In this case, you should set up the structure such that it is still safe to call `mediocre_input_destroy` or `mediocre_functor_destroy` on it once.

Finally, MediocreInput instances also store the dimension of the input as a MediocreDimension structure. This will most likely just be copied from whatever the user specified.

Prototypes and structure layouts:

        int MediocreInput.loop_function(MediocreInputControl*, void const*, MediocreDimension)
        int MediocreFunctor.loop_function(MediocreFunctorControl*, void const*, MediocreDimension)
        
        MediocreInput: { loop_function, destructor, user_data, dimension, nonzero_error }
        MediocreFunctor: { loop_function, destructor, user_data, nonzero_error }

As mentioned the job of the loop function is to follow commands given by the mediocre library. The loop function will be launched with a pointer to a control structure that gives commands, the pointer to the user data mentioned earlier, and a MediocreDimension that specifies the maximum amount of data that the loop function will ever be requested to load or combine at once. Here's the pseudocode for a loop function:
        
        loop_function(control_struct, user_data, maximum_request):
            cast user_data from void* to pointer to correct type
            perform initialization needed, such as allocating temporary storage
            maximum_request can be helpful for this
            
            while control_struct has a new command:
                follow that command
                if there is an error
                    de-initialize
                    return a nonzero error code
                
            de-initialize
            return 0

The mediocre library provides `MediocreInputCommand` and `MediocreFunctorCommand` types as well as `MEDIOCRE_INPUT_LOOP` and `MEDIOCRE_FUNCTOR_LOOP` macros that correspond to the `while control_struct has a new command` part of the above pseudocode. Within a loop function, the loop macro should be called with the name of a command variable to store commands in and the pointer to the control structure, and can be used in place of a for statement, like so:
        
        MediocreFunctorCommand command;
        MEDIOCRE_FUNCTOR_LOOP(command, control_struct) {
            execute_command(command);
            if (disaster) return error_code;
        }

You can break or return out of the loop, and can continue to the next command, just like in an ordinary for loop (because the macro _is_ a for statement).

You don't have to use a macro; you can manually write a loop that does what the macro does. All the loop does every iteration is call `mediocre_input_control_get` or `mediocre_functor_control_get` with the control structure as the argument. The function returns a command, and the loop terminates immediately if the command's _exit field is true. The get command function should not be called again until the loop has completely finished the previous command.

`loop_function` inside `src/median.c` provides a good, relatively simple example of how a loop function should be written. You don't have to understand `clipped_median_chunk_m256`. Just know that it combines an array of `chunk_count` chunks of `combine_count __m256` vectors into an array of `chunk_count __m256` vectors stored in `temp_output` (see picture). But first, read some of the specifics below on implementing either an input loop function or a combine functor loop function.

        clipped_median_chunk_m256 example (combine_count = 3, chunk_count = 2)
        No sigma clipping for this example.
        
        input+0   [18, 21, 35, 42, 56, 66, 78, 82]    # Chunk 0
             +32  [17, 26, 35, 40, 52, 63, 77, 83]
             +64  [12, 21, 32, 46, 58, 69, 78, 89]
             +96  [37, 46, 57, 65, 70, 80, 90, 106]   # Chunk 1
             +128 [32, 44, 54, 60, 71, 83, 92, 100]
             +160 [31, 45, 57, 68, 70, 82, 92, 103]
        
        output+0  [17, 21, 35, 42, 56, 66, 78, 83]    # Median of chunk 0
              +32 [32, 45, 57, 65, 70, 82, 92, 103]   # Median of chunk 1

## Specifics of MediocreInput loop_function

A complete MediocreInput.loop_function implementation will look something like this:

        static int loop_function(
            MediocreInputControl* control,
            void const* user_data,
            MediocreDimension maximum_request
        ) {
            MyUserDataType* data = (MyUserDataType*)user_data;
            size_t array_count = maximum_request.combine_count;
            
            MediocreInputCommand command;
            MEDIOCRE_INPUT_LOOP(command, control) {
                if (something_is_wrong()) {
                    return nonzero_error_code();
                }
                
                size_t offset = command.offset;
                
                // Method 1 (treating output as 2D array using mediocre_chunk_ptr)
                for (size_t a = 0; a < array_count; ++a) {
                    MyArrayType* array = get_array(a, data);
                    for (size_t x = 0; x < command.dimension.width; ++x) {
                        float number = index_array(offset + x, array);
                        *mediocre_chunk_ptr(command.output_chunks, array_count, a, x) = number;
                    }
                }
                
                // Method 2 (interacting with chunk format directly)
                // chunk count is ceil(requested width / 8)
                size_t chunk_count = (command.dimension.width + 7) / 8;
                for (size_t c = 0; c < chunk_count; ++c) {
                    // Each chunk is array_count vectors wide.
                    __m256* this_chunk = command.output_chunks + array_count*c;
                    for (size_t a = 0; a < chunk_count; ++a) {
                        MyArrayType* array = get_array(a, data);
                        __m256 vector = _mm256_set_ps(
                            safe_index_array(c*8 + 7, array),
                            safe_index_array(c*8 + 6, array),
                             /* ... */
                            safe_index_array(c*8,     array)
                        );
                        // safe_index_array is a stand in for a function that does bounds-
                        // checking before returning data at the requested index. (Needed because
                        // the requested width may not be divisible by 8).
                        
                        // Entry a in a chunk corresponds to data from array number a.
                        this_chunk[a] = vector;
                    }
                }
            }
            return 0;
        }
            
The `MediocreInputCommand` you receive in each iteration contains three pertinent variables: the `dimension` of the request, the `offset` into the arrays that your are expected to load from, and the location you are expected to write input in chunk format to: `output_chunks`.

Each time a command is received, the input loop function should load columns `offset` to `offset + dimension.width - 1` of the input arrays into the `__m256` array `output_chunks`. The columns should be loaded in chunk format, with chunk 0 corresponding to columns `offset` to `offset + 7`, chunk 1 corresponding to `offset + 8` to `offset + 15`, and so on (see above for chunk format).

`offset` will always be divisible by 8.

`dimension.combine_count` equals `maximum_request.combine_count`

`dimension.width` will not exceed `maximum_request.width`. It might not be divisible by 8.

`output_chunks` points to 32-byte aligned storage large enough to store the number of chunks requested (`ceil(dimension.width / 8)`).

The loop function will be run one one thread only: the one that called `mediocre_combine`. This should simplify dealing with locked data structures, but means that the input function may be a bottleneck.



## Specifics of MediocreFunctor loop_function

The command supplied each iteration specifies a `dimension`, `input_chunks`, and an `output` pointer. The chunks hold data from `dimension.width` columns of data. Each column `N` should be combined with its data written to `output[N]`. As mentioned earlier, this can be done by combining 8 columns at a time and writing 8 outputs at a time by combining one chunk of data at a time. But, there is a catch that I will mention shortly.

`dimension.combine_count` equals `maximum_request.combine_count`.

`dimension.width` will not exceed `maximum_request.width`.

`input_chunks` points to 32-byte aligned storage that stores the number of chunks needed to store the columns of data you are to combine (`ceil(dimension.width / 8)`.

`output` points to an array of floats wide enough to store `dimension.width` floats.

There are few guarantees on the `output` pointer because it directly points to a portion of the output array passed by the caller of `mediocre_combine`, and we place few constraints on the caller of `mediocre_combine`. Notice that `output` may not be aligned to 32 bytes and it is only wide enough to store `dimension.width` floats, which may not be divisible by 8. Thus, even if you write the output vectors using unaligned store instructions, you still run the risk of overflowing the buffer. If you're writing a combine functor, the functions `mediocre_functor_aligned_temp` and `mediocre_functor_write_temp` are your new best friends. Call `mediocre_functor_aligned_temp` with the command received and a pointer to your control structure in order to received an `__m256` pointer that points to 32 byte aligned storage wide enough to store `ceil(command.dimension.width / 8) __m256` vectors. You can then safely write your output to this temporary array using `__m256` pointers. Just remember to call `mediocre_functor_write_temp` to copy the temporary buffer to the real output pointer. You should check for a NULL result from `mediocre_functor_aligned_temp`, and MUST NOT free the memory received.

`mediocre_combine` will call your loop function once for each thread that it launches. The combine work will be split among the different threads. It is very important then that the loop function is thread safe.

## mediocre_combine implementation

_Two years later, and it doesn't look like I'm ever going to write these design notes, but I doubt that anyone was interested in the first place. If you are curious about the library's implementation though, I am happy to have a chat with you over it. Maybe we can even go for some lemon cookies and crysanthemum tea!_

If you want to figure out how the library really works (good luck!), the answer lies somewhere in `src/combine.c`. The other source files implement MediocreInput and MediocreFunctor instances; `src/combine.c` is what actually enables them to work together. Basically, what we do is launch a bunch of threads (`thread_count` of them) that run the MediocreFunctor's `loop_function`, so that they're all waiting for commands from the library. We then pass control to the MediocreInput `loop_function`. We trick the user into doing work for us by adapting that input `loop_function` as the "main loop" for the entire combine operation. To do this, we have the `MediocreInputControl` structure do some bookkeeping on how much of the arrays we have processed so far (so we know how far we are in the iteration) and some bookkeeping on the MediocreFunctor threads launched for us. In each iteration of the MediocreInput's `loop_function`, we do some extra work when the MediocreInput asks for a command in each iteration (since the function `mediocre_input_control_get` accesses the `MediocreInputControl` structure); this work includes giving commands to the MediocreFunctor `loop_function`s running in the launched threads and updating the `MediocreInputControl` bookkeeping.

I should write some better design notes later. For now, consider setting the global variable `mediocre_combine_verbose` to true and running `mediocre_combine`. Stare at the output and the many comments in `src/combine.c` and you may achieve nirvana.


