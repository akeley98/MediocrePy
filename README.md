# mediocre and MediocrePy

An aggressively average SIMD combine library (single-precision float array averages with sigma clipping), 

## First, a word of warning

Internally, the library uses 256-bit single precision floating point vectors everywhere. This will require the AVX instruction set, introduced in 2011 (Sandy Bridge or later for Intel, Bulldozer or later for AMD, I think). If your computer has a CPU older than this, it won't be able to run this code (not because the CPU is too slow, but because it won't understand the instructions used in the program. It would be like reading Dr. Seuss to your goldfish). Computers with crippled Intel processors (Celerons and Pentiums) also won't be able to run the code, because Intel are run by losers who will happily hold back the march of progress in order to make an extra buck. If you wanted an inexpensive CPU that was actually good, you should have bought an AMD. Not that I only have good things to say about AMD. It turns out that their FX processors have a bug that can slow vectorized memory access down by something like 10000%, so this code may not perform as well as I'd hoped on those processors. At least Zen's here to save us from 5 years of faildozer.

Keep in mind that compilers are often no help when it comes to memory alignment for such vector data types, so be vigilant. If you are a user of the library just looking to use the default combine and input methods, you don't have to worry about alignment all that much.

## Introduction (skip to here when you tire of reading the warning!)

This library was written to solve the problem of writing high-performance combine routines using vectorization. A combine routine takes a stack of identically-sized input arrays and combines it into a single output array of the same size, where each entry of the output array (with index I) ideally depends only on the data stored at index I of each input array. Let me draw you a picture to illustrate:

        input 0: w0, w1, w2, w3, w4, w5
        input 1: x0, x1, x2, x3, x4, x5
        input 2: y0, y1, y2, y3, y4, y5
        input 3: z0, z1, z2, z3, z4, z5
        
        output : a0, a1, a2, a3, a4, a5
    
where a0 is f(w0, x0, y0, z0), a1 is f(w1, x1, y1, z1), and so on. Here, we say that combine_count is 4 (because we are combining 4 input arrays into a single output array) and that the width is 6 (because each array is 6 entries wide). I tend to refer to a group of numbers that is combined into a single value in the output as a 'column'.

This library aims to solve this combine problem (for single precision, 32 bit floats) by doing two things: first, by providing a collection of default input functions and high-performance combine functions , and second, by providing an interface through which programmers can implement their own vectorized combine and input functions that are compatible with those provided by the library. The library specifies a chunk format, which is how the input and combine functions communicate with each other.

This is a good time for me to point out that different parts of the README are relevant for you to read depending on your needs. If you are interested in the library mainly for the first thing it provides, the default combine methods, then you shouldn't have to listen to me blather on about chunk format: skip ahead to and read just the "High Level Description" section. If however you are interested in implementing your own combine algorithm or a new method of data input, or you are interested in how the library itself is organized and implemented, read onwards.

Iinput arrays can come in lots of different shapes and sizes, can take a long time to load, and generally are not in formats convenient for writing vectorized code. The input could be from a bunch of fortran-order arrays of 36 bit integers. It could be coming from a memory mapped FITS file stored on Neptune. It could be from a human-readable list of numbers written out in Yiddish. We want to make it so that one combine algorithm can be run on any input, we want that combine algorithm to be supplied with input in a format designed with vectorization in mind, and we want the combine algorithm to spend as little time as possible waiting for input. To this end, the library divides separates the responsibility of loading input from the responsibility of combining the input, the library specifies the vectorization-friendly chunk format as the method in which input algorithms provide data to combine algorithms, and it runs input algorithms on a separate thread from combine algorithms.

Also consider reading the following high level description.

## High Level Description

It was a bit inaccurate for me to say that the library allows for programmers to implement input and combine functions. What's really being implemented are input structures and combine functor structures (Known as MediocreInput and MediocreFunctor in the code). You need to create one instance of each in order to start combining. Consider the following example:
        
        // Average three arrays of [array_width] floats into one array
        // of [array_width] floats.
        int mean_three_arrays(
            float* output,
            float const* input0,
            float const* input1,
            float const* input2,
            size_t array_width
        ) {
            // Part 1
            float const* input_pointers[3] = { input0, input1, input2 };
            MediocreDimension dim;
            dim.combine_count = 3;      // We are combining 3 arrays.
            dim.width = array_width;    // Each array is this wide.
            MediocreInput input = mediocre_float_input(input_pointers, dim);
            
            // Part 2
            MediocreFunctor combine_functor = mediocre_mean_functor();
            
            // Part 3
            if (input.nonzero_error != 0) {
                fprintf(stderr, "MediocreInput not constructed.\n");
                return -1;
            }
            if (combine_functor.nonzero_error != 0) {
                fprintf(stderr, "MediocreFunctor not constructed.\n");
                return -1;
            }
            
            // Part 4
            int err = mediocre_combine(output, input, combine_functor, 2);

            // Part 5
            mediocre_functor_destroy(combine_functor);
            mediocre_input_destroy(input);
            
            return err;
        }

In part 1 we create a MediocreInput instance that describes the data that we want combined, including the dimensions of the data we want to combine (as a MediocreDimension structure). In this case, we call `mediocre_float_input`, one of the default functions for creating MediocreInput instances provided by the library; this creates a MediocreInput instance describing input from a list of 1D C arrays of floats. Keep in mind that, in general, MediocreInput instances only describe data; they don't contain them. This means that it may be unsafe to free data passed to such functions until after the MediocreInput they've returned is used. Each function returning MediocreInput instances should document their exact requirements.

In part 2 we create a MediocreFunctor instance that describes the combine algorithm we want to run. In this case we just want to take the mean of each column of data. `mediocre_mean_functor` returns a functor that does this. Other functions returning MediocreFunctor instances may take arguments; this one doesn't.

In part 3 we check the error field of the input and functor instances to see any function failed to initialize the structure they were supposed to. `IN THIS LIBRARY, ZERO ALWAYS MEANS SUCCESS AND NON-ZERO INDICATES AN ERROR`. You don't have to check this; mediocre_combine will also check for an error code, forwarding any error codes and cancelling the combine if needed.

In part 4 we actually run the combine algorithm. Call `mediocre_combine` to do this. It takes a pointer to an array of floats where the output will be stored, one instance each of MediocreInput and MediocreFunctor, and the count of the number of threads to run combine algorithms on. The output will always be written as a flat, continuous C array of floats regardless of the format of the input. `mediocre_combine` will forward a nonzero error code if any errors are reported by the input algorithm or combine algorithm.

The MediocreInput and MediocreFunctor instances may hold resources. In part 5 we release those resorces held by the MediocreInput instance and MediocreFunctor instance by calling `mediocre_functor_destroy` and `mediocre_input_destroy` respectively. These functions, and the functions supplied by MediocreInput and MediocreFunctor implementors that are called to free resources, are expected to never fail.

Some convenience functions are defined in the library. `mediocre_output_sizeof` and `mediocre_output_alloc` help with allocating space for holding combine outputs. `mediocre_combine_destroy` and `mediocre_combine2` can automatically free resources held by MediocreInput and MediocreFunctor instances after the combine is finished. For now their documentation is in the header file `mediocre.h`; look around in there to find out more. Note also that all data is loaded as single precision floating point data regardless of the format and data type of the input data. The functions returning MediocreInput instances describing double-precision data are provided for convenience only.

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
                         [ w8, w9, w10, 0,  0,  0,  0,  0 ]  (CHUNK 1)
                         [ x8, x9, x10, 0,  0,  0,  0,  0 ]
                         [ y8, y9, y10, 0,  0,  0,  0,  0 ]
                         [ z8, z9, z10, 0,  0,  0,  0,  0 ]
        
In words, a group of input arrays is converted to chunk format by packing 8 columns of the input arrays at a time into a chunk. Each chunk consists of `combine_count __m256` vectors, with each vector holding 8 entries from exactly one of the input arrays. Chunk `N` holds data from columns `N*8` to `N*8 + 7`, with vector `V` of the chunk holding input from input array `V`. Extra entries in the vectors of the last chunk should be filled with `0`'s (although I suppose it would be unwise to rely on this requirement).

The chunk format is a bit confusing because it's neither row-major nor column-major. Instead it's sort of this 3D layout where both the most and least significant dimensions correspond to the width axis. It'll make more sense once I explain the reason it's designed this way: it makes it possible for vectorized combine algorithms to combine 8 columns of data at a time while reading as small a portion of memory as possible. You can see how easily chunk 0 can be combined into the output `[a0, a1, a2, a3, a4, a5, a6, a7]`, and how chunk 1 can be combined into `[a8, a9, a10, 0, 0, 0, 0, 0]`. The functions `mediocre_chunk_ptr` and `mediocre_chunk_data` may be helpful for dealing with the chunk format.

A MediocreInput instance will be tasked with converting data into chunk format. A MediocreFunctor instance will be tasked with combining data in chunk format. As an aspiring MediocreInput or MediocreFunctor implementor, you will write a factory function that will return 4 things to the user through a MediocreInput or MediocreFunctor structure:

A loop function that will poll the mediocre library for commands to either write or combine data in chunk format. It should return nonzero if it encounters an error and zero if it is successful.

A void pointer to "user data", which holds data you need to do your job. This should be cast to the actual type of the user data.

A destructor function that frees resources held by the user data. This is what gets called by `mediocre_input_destroy` and `mediocre_functor_destroy`. The prototype matches the prototype of `free`, so `free` can be used as the destructor if the only resource held by the user data is the memory it occupies.

An error code that should be nonzero if the factory function failed to properly initialize the MediocreInput or MediocreFunctor structure. In this case, you should set up the structure such that it is still safe to call `mediocre_input_destroy` or `mediocre_functor_destroy` on it once.

(Of course MediocreInput instances also store the dimension of the input as a MediocreDimension structure. This will probably just be copied from whatever the user specified, though).

As mentioned the job of the loop function is to follow commands given by the mediocre library. The loop function will be launched with a pointer to a control structure that gives commands, the pointer to the user data mentioned earlier, and a MediocreDimension that specifies the maximum amount of data that the loop function will ever be requested to load or combine at once. Here's the pseudocode for a loop function:
        
        loop_function(control_struct, user_data, maximum_request):
            cast user_data to the correct type
            perform initialization needed, such as allocating temporary storage
            maximum_request can be used for this
            
            while control_struct has a new command:
                follow that command
                if there is an error
                    de-initialize
                    return an error code
                
            de-initialize
            return 0

The mediocre library provides `MediocreInputCommand` and `MediocreFunctorCommand` types as well as `MEDIOCRE_INPUT_LOOP` and `MEDIOCRE_FUNCTOR_LOOP` macros that correspond to the `while control_struct has a new command` part of the above pseudocode. Within a loop function, the loop macro should be called with the name of a command variable to store commands in and the pointer to the control structure, and can be used in place of a while statement, like so:
        
        MediocreFunctorCommand command;
        MEDIOCRE_FUNCTOR_LOOP(command, control_struct) {
            /* do the thing */
        }

You don't have to use a macro; you can manually write a loop that does what the macro does. All the loop does every iteration is call `mediocre_input_control_get` or `mediocre_functor_control_get` with the control structure as the argument. The function returns a command, and the loop terminates immediately if the command's _exit field is true. The get command function should not be called again until the loop has completely finished the previous command.

`loop_function` inside `src/median.c` provides a good, relatively simple example of how a loop function should be written. You don't have to understand `clipped_median_chunk_m256`. Just know that it combines an array of `chunk_count` chunks into an array of `chunk_count __m256` vectors stored in `temp_output`. But first, read some of the specifics below on implementing either an input loop function or a combine functor loop function.

## Specifics of MediocreInput loop_function

Each time a command is received, the input loop function should load columns `offset` to `offset + dimension.width - 1` of the input arrays into the `__m256` array `output_chunks`. The columns should be loaded in chunk format, with chunk 0 corresponding to columns `offset` to `offset + 7`, chunk 1 corresponding to `offset + 8` to `offset + 15`, and so on (see above for chunk format).

`offset` will always be divisible by 8.
`dimension.combine_count` equals `maximum_request.combine_count`
`dimension.width` will not exceed `maximum_request.width`. It might not be divisible by 8.
`output_chunks` points to 32-byte aligned storage large enough to store the number of chunks requested (`ceil(dimension.width / 8)`).

## Specifics of MediocreFunctor loop_function

The command supplied each iteration specifies a `dimension`, `input_chunks`, and an `output` pointer. The chunks hold data from `dimension.width` columns of data. Each column `N` should be combined with its data written to `output[N]`. As mentioned earlier, this can be done by combining 8 columns at a time and writing 8 outputs at a time by combining one chunk of data at a time. But, there is a catch that I will mention shortly.

`dimension.combine_count` equals `maximum_request.combine_count`.
`dimension.width` will not exceed `maximum_request.width`.
`input_chunks` points to 32-byte aligned storage that stores the number of chunks needed to store the columns of data you are to combine (`ceil(dimension.width / 8)`.
`output` points to an array of floats wide enough to store `dimension.width` floats.

There are few guarantees on the `output` pointer because it directly points to a portion of the output array passed by the caller of `mediocre_combine`, and we place few constraints on the caller of `mediocre_combine`. Notice that `output` may not be aligned to 32 bytes and it is only wide enough to store `dimension.width` floats, which may not be divisible by 8. Thus, even if you write the output vectors using unaligned store instructions, you still run the risk of overflowing the buffer. If you're writing a combine functor, the functions `mediocre_functor_aligned_temp` and `mediocre_functor_write_temp` are your new best friends.

## Structure of the Library

## Confession (Design notes)

