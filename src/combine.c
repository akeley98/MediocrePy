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

#include <assert.h>
#include <errno.h>
#include <immintrin.h>
#include <pthread.h>
#include <semaphore.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "mediocre.h"

// Define the control structs declared to the user in mediocre.h
// The convenience typedefs MediocreInputControl and MediocreFunctorControl
// are already in-scope since mediocre.h was included. The control structures
// are all accessed by the user as opaque pointers to allow us to redesign
// the iteration scheme without forcing users to recompile their code.
// Notice how semaphors are used all over the place in the code.
// Since there is only one-way flow of data (input data to input_thread_buffer
// chunks and commands to functor threads to output buffer), there may be more
// efficient ways to redesign this using relaxed memory models.
// Stroustrup: "Doctor! It hurts when I think about relaxed memory models!"

struct functor_buffer {
    // Variables used to pass commands to combine functors.
    MediocreDimension command_dimension;
    float* command_output; // Null to request thread exit.
    
    int nonzero_error;
    
    // The compiler better align this array properly or I WILL FSCKING KILL
    // EVERYONE!!!!1!1!!!!!11!!!!1!1!!!!11!!1!!!!one!
    // This array needs to be big enough to store
    // maximum_request.combine_count * maximum_request.width / 8
    // __m256 vectors. (maximum_request passed as struct mediocre_dimension
    // as an argument to functor.loop_functon).
    __m256 chunk_data[];
};

/*  Structure used to facilitate communication between the input loop thread
 *  and the combine functor threads under its control. There is one instance
 *  of this structure for each running functor thread. There are two buffers
 *  used  to  communicate  data  and commands: one has data written to it in
 *  chunk format by the input loop thread while the functor thread processes
 *  (and  possibly  overwrites) chunk data in the other buffer concurrently.
 *  The two buffers are conceptually swapped  each  time  the  input  thread
 *  issues  another  command  to the functor thread, which only happens when
 *  the functor is ready  to  receive  a  command.  The  input  loop  thread
 *  synchronizes  with  one  of  its  combine  functor loop threads by using
 *  semaphors. When the input loop thread or combine thread is ready to give
 *  or  receive  a new command, it signals either the command_ready semaphor
 *  or  functor_ready  semaphor,  respectively,  and  waits  on  the   other
 *  semaphor. This way neither thread proceeds until the other is ready, and
 *  we avoid having one thread run so fast that it swaps the  buffers  twice
 *  before the other thread has even started (as embarassingly happened with
 *  my original mutex / condition variable based approach).
 */
struct mediocre_functor_control {
    pthread_t thread_id;
    
    sem_t command_ready_sem;
    sem_t functor_ready_sem;
    
    // Variable starts at 0 and set to true once we issue an exit command to
    // the user's combine functor loop (set by functor thread, not input
    // thread). The user is supposed to return 0 on success and nonzero when
    // exiting abnormally. However, users are known to make mistakes: they
    // might return abnormally without finishing their assigned commands but
    // return 0 anyway. If we get 0 back from the user's loop function, we
    // check that this variable is true to ensure that they really returned
    // because we told them to, not because they had an error they're hiding
    // from us.
    int received_exit_command;
    
    // Double-buffering scheme:
    // The two flags here keep track of which buffer is being used for which
    // purpose. They are toggled each time the input function issues the
    // combine functor a new command. If the flags are 1, then this control
    // structure is in the 'odd' state, and the input function should write to 
    // the odd_input_buffer while the combine functor processes data in the
    // even_input_buffer (since the structure must have been in the 'even'
    // state just previously, and that's where the data is). Likewise, in the
    // 'even' state, the input function should write to the even_input_buffer
    // while the combine functor processes data in the odd_input_buffer.
    // Both flags conceptually hold the same information, but each variable
    // is private to each thread, and both threads are responsible for toggling
    // their own variable. This was easier than trying to synchronize a
    // single variable, which doesn't fit in the semaphore synchronization
    // scheme well. There could be some false sharing performance issues.
    size_t functor_odd_flag;
    size_t input_odd_flag;
    
    struct functor_buffer* odd_input_buffer;
    struct functor_buffer* even_input_buffer;
    
    // Temporary aligned storage needed by mediocre_functor_aligned_temp.
    // Initially set to NULL and will be freed by mediocre_combine
    // even though it is allocated in a different thread by a combine functor. 
    // This is ugly for the maintainer (ME) but pretty for the user / extender 
    // of the library.
    __m256* aligned_temp;
    
    // Used to pass data through the pthread start function.
    // (maximum_request also used to allocate aligned_temp).
    int (*functor_loop_function)(
        MediocreFunctorControl* control,
        void const* user_data,
        MediocreDimension maximum_request
    );
    void const* user_data;
    MediocreDimension maximum_request;
};

/*  Helper functions for the double buffer scheme in MediocreFunctorControl.
 *  The input loop thread should call input_buffer  to  get  access  to  the
 *  buffer  it is allowed to read and write from. The combine functor thread
 *  should call functor_buffer to do the same. The two threads will see each
 *  other's buffers when a command is issued and the buffers are swapped.
 */
static inline struct functor_buffer* input_buffer(MediocreFunctorControl* c) {
    return c->input_odd_flag ? c->odd_input_buffer : c->even_input_buffer;
}

static inline struct functor_buffer* functor_buffer(MediocreFunctorControl* c) {
    return c->functor_odd_flag ? c->even_input_buffer : c->odd_input_buffer;
}

/*  Structure used to control and issue commands to the  implementor  of  an
 *  input  loop  thread.  An  array of functor threads is stored within. The
 *  structure also stores the the state of the iteration  inside  the  input
 *  loop,  i.e.,  the  slice of the input that is scheduled next for loading
 *  and combining (current_offset and maximum_request.width: terminates when
 *  current_offset reaches past input_dimension.width), a nonzero error code
 *  if any, and the thread  whose  turn  it  is  to  be  assigned  new  work
 *  (current_thread_index). The threads are assigned new work in a cycle.
 */
struct mediocre_input_control {
    size_t thread_count;
    MediocreDimension input_dimension;
    MediocreDimension maximum_request;
    MediocreFunctorControl* previous_iteration_thread; // Starts as null.
    float* combine_output;  // output pointer passed to mediocre_combine.
    size_t current_thread_index;
    size_t current_offset;
    
    // Initially false: set to true once we issue an exit command to the
    // user's input loop function. After we get control back from the user's
    // function, we check this to see if the user returned successfully
    // or if the user returned early due to an error.
    int received_exit_command;
    
    MediocreFunctorControl functor_threads[];
};

#define CHECK_STATUS_VARIABLE(name) \
    do { \
        if (status != 0) { \
            fprintf(stderr, "%s %s: %s\n", __func__, name, \
                strerror(errno != 0 ? errno : status)); \
            abort(); \
        } \
    } while (0)

// First variable is _exit, the rest don't matter for exit command.
static const MediocreInputCommand input_exit = { 1, 0, { 0, 0 }, NULL };
static const MediocreFunctorCommand functor_exit = { 1, { 0, 0 }, NULL, NULL };

/*  Function that the implementor of an input loop is expected to call  each
 *  iteration  to  get a command. This function will return a command to the
 *  user that includes a pointer to the input thread buffer of  one  of  the
 *  combine  functor  threads  under  the  control  of the input thread. The
 *  command also specifies which subrange of the input that we want the user
 *  to  load  into the buffer in chunk format. In each iteration, we need to
 *  wait for the thread that we ordered the user to load data into  (in  the
 *  previous  iteration)  to  finish  its current workload, and command that
 *  thread to start combining its new input data.
 *  
 *  Precondition: MediocreInputControl must be set up with at least 1 struct
 *  mediocre_functor_control  in  the functor_threads array (thread_count >=
 *  1). Each of those structs must be properly initialized  with  a  running
 *  thread,  and  the semaphores should all be initialized with the value 0.
 *  These preconditions are all handled by mediocre_combine; the user of the
 *  mediocre library doesn't need to worry about this.
 *  
 *  This function is the one chance that we have to do the things we need to
 *  do  each  iteration.  These  are  the things that need to happen in each
 *  iteration:
 *      Choose the next thread after the thread used in the previous iteration.
 *          (Restart with the 0th thread if that last thread was just used).
 *      Load some data into the thread's input thread buffer.
 *      Wait for the thread to complete its previous command.
 *      Command the thread to combine the new data it was just supplied with.
 *  
 *  However, the user is responsible for one of the tasks in the  middle  of
 *  that  list: loading the data into a thread's input buffer. Thus, we need
 *  to re-order the list like this:
 *      Select the thread s that had data loaded into it the previous iteration.
 *      If s exists then
 *          Wait for s to complete its previous command, if any.
 *          Command s to combine the new data in its input thread buffer.
 *      Select the thread t that comes next in the sequence after s.
 *      Command the user to load data into t's input thread buffer.
 *  
 *  Note that with this scheme the input loop will exit as soon as the  last
 *  chunks  of  data  are  loaded. The functor threads under its control may
 *  still be running and not finished writing its data to the output yet. It
 *  is  the  responsibility  of  the mediocre_combine function, when it gets
 *  control back from the user's input loop, to wait for the functor threads
 *  to finish running and join those threads.
 */
MediocreInputCommand
mediocre_input_control_get(MediocreInputControl* control) {
    int status;
    
    // Wait for the previous iteration's thread, if any, to finish working and
    // command it to work on the new data loaded in the last iteration. To do
    // this, we post the semaphore that the functor thread is waiting on and
    // then wait on the semaphore that the functor thread will post when it
    // is ready. Also swap the buffers.
    MediocreFunctorControl* const prev_thr = control->previous_iteration_thread;
    if (prev_thr != NULL) {
        const size_t odd_flag = prev_thr->input_odd_flag;
        
        status = sem_post(&prev_thr->command_ready_sem);
            CHECK_STATUS_VARIABLE("sem_post");
        
        do {
            status = sem_wait(&prev_thr->functor_ready_sem);
        } while (status != 0 && errno == EINTR);
        CHECK_STATUS_VARIABLE("sem_wait");
        
        prev_thr->input_odd_flag = !odd_flag;
        
        // Check for any errors reported by the combine functor thread.
        // This code was reported through the functor thread's buffer, which
        // is now input thread's buffer since the buffers were swapped.
        // If so, the combine functor thread has terminated abnormally and
        // we should order the user's input loop thread to quit as well,
        // as there is no point to continuing computation anymore.
        const int error_code = input_buffer(prev_thr)->nonzero_error;
        if (error_code != 0) {
            control->received_exit_command = 1;
            return input_exit;
        }
    }
    // Get the current index of the thread that should have data written to
    // it in this iteration, then increment that index inside the control
    // structure, or restart at 0 if needed.
    const size_t i = control->current_thread_index;
    control->current_thread_index = i+1 == control->thread_count ? 0 : i+1;
    
    // This is the next thread in the sequence. We want to get data into it.
    // Also store its address so that it will be commanded to run the next
    // time that this function is called.
    MediocreFunctorControl* const thr = &control->functor_threads[i];
    control->previous_iteration_thread = thr;
    
    // Figure out which part of the input we want to have the user load next.
    const MediocreDimension input_dim = control->input_dimension;
    MediocreDimension request_dim;
    request_dim.combine_count = input_dim.combine_count;
    
    const size_t offset = control->current_offset;
    status = (int)(offset % 8);
    assert(offset % 8 == 0);
    
    // If the current offset is greater than or equal to the width of the
    // input, then we're all out of input. Order the input loop to exit.
    // We don't have any other work that we need to do; we already ordered
    // the last thread with input written to it to run.
    
    if (offset >= control->input_dimension.width) {
        control->received_exit_command = 1;
        return input_exit;
    } else {
        // Always give the user the maximum request that we promised we'd give,
        // unless we're at the end of the input and there's not enough left.
        const size_t width_left = control->input_dimension.width - offset;
        if (width_left > control->maximum_request.width) {
            request_dim.width = control->maximum_request.width;
        } else {
            request_dim.width = width_left;
        }
        // Increment the current_offset for next time.
        control->current_offset += control->maximum_request.width;
    }
    
    // Write a new command to the functor control struct that will have data
    // written to it. The thread associated with that functor will be ordered
    // to process the data next time we are called (previous_iteration_thread).
    struct functor_buffer* buffer = input_buffer(thr);
    
    // Remember that we need to offset the output pointer so that it matches
    // with whatever portion of data we gave to the functor thread.
    buffer->command_dimension = request_dim;
    buffer->command_output = control->combine_output + offset;
    
    // Now we are finally ready to give the input thread a new command.
    MediocreInputCommand command = {
        0, offset, request_dim, buffer->chunk_data
    };
    return command;
}

/*  Function that the implementor of a combine functor loop is  expected  to
 *  call each iteration to get a command. Cooperates with
 *  mediocre_input_control_get to signal its completion of its command,  and
 *  to ensure that the correct buffer in the double buffer is written to.
 */
MediocreFunctorCommand
mediocre_functor_control_get(MediocreFunctorControl* control) {
    int status;
    
    const size_t odd_flag = control->functor_odd_flag;
    
    status = sem_post(&control->functor_ready_sem);
    CHECK_STATUS_VARIABLE("sem_post");
    
    do {
        status = sem_wait(&control->command_ready_sem);
    } while (status != 0 && errno == EINTR);
    CHECK_STATUS_VARIABLE("sem_wait");
    
    control->functor_odd_flag = !odd_flag;
    
    struct functor_buffer* functor_thread_buffer = functor_buffer(control);
    
    if (functor_thread_buffer->command_output == NULL) {
        control->received_exit_command = 1;
        return functor_exit;
    } else {
        MediocreFunctorCommand command = {
            0,
            functor_thread_buffer->command_dimension,
            functor_thread_buffer->chunk_data,
            functor_thread_buffer->command_output
        };
        return command;
    }
}

static MediocreDimension get_maximum_request(MediocreDimension input_dim) {
    MediocreDimension result = input_dim;
    const size_t n = 160000 / input_dim.combine_count;
    const size_t width = (n + 7) & ~7;
    result.width = width == 0 ? 8 : width;
    return result;
}

/*  Helper function needed for pthread_create. Takes a pointer to  a  struct
 *  mediocre_functor_control  and  launches a functor loop thread using that
 *  structure as the control  structure.  The  function  pointer  and  other
 *  arguments  for  the  functor  loop  function are included in the control
 *  structure. The function then copies the error code returned by the  user
 *  to the control structure, notifying the input loop thread of the functor
 *  thread's abnormal termination if needed.
 */
static void* functor_start_function(void* functor_control_pv) {
    MediocreFunctorControl* functor_control =
        (MediocreFunctorControl*)functor_control_pv;
    
    int error_code = functor_control->functor_loop_function(
        functor_control,
        functor_control->user_data,
        functor_control->maximum_request
    );
    
    if (error_code == 0 && !functor_control->received_exit_command) {
        fprintf(stderr,
        "\x1b[1m\x1b[31mXXX\t\tXXX\t\tXXX\x1b[0m\n"
        "\tmediocre: Warning, a MediocreFunctor loop_function returned 0,\n"
        "\tindicating no error, but it appears to have terminated abnormally.\n"
        "\tThis is not guaranteed to work; please fix the functor loop\n"
        "\tfunction implementation if you can.\n"
        "\tReporting error code -1 instead of 0.\n"
        );
        
        error_code = -1;
    }
    
    // If the error_code is nonzero, then the user's function terminated
    // abnormally and we need to let the input loop thread that may be
    // waiting on us know. Copy the error code to the functor_buffer struct
    // that we have access to and signal the semaphore that unblocks the input
    // thread. This swaps the buffers, and the input thread will read the
    // error code that we reported through the input_buffer.
    if (error_code != 0) {
        int status = 0;
        functor_buffer(functor_control)->nonzero_error = error_code;
        
        status = sem_post(&functor_control->functor_ready_sem);
        CHECK_STATUS_VARIABLE("sem_post");
        
        functor_control->functor_odd_flag = !functor_control->functor_odd_flag;
    }
    
    return NULL;
}

/*  Function  that  prepares  the  environment  expected  by   the   command
 *  functions,   launches   the  functor  threads,  and  passes  control  to
 *  input.loop_function.  The  function  then  cleans  up  the   environment
 *  created, waits for the functor threads to finish running and write their
 *  output, joins those threads,  and  checks  for  and  reports  any  error
 *  conditions.  Zero  return  indicates  no  errors, nonzero indicates that
 *  there was an error. The errno variable will be set to the return value.
 *  
 *  To users of the library, this is the function that allows  them  to  run
 *  any  combine  functor  implementation  on  any  specified  input,  while
 *  specifying the number of threads to be used and the  destination  buffer
 *  as a flat C array of floats.
 */
int mediocre_combine(
    float* output,
    MediocreInput input,
    MediocreFunctor functor,
    int thread_count
) {
    int status;
    
    if (input.dimension.combine_count == 0) {
        fprintf(stderr, "mediocre_combine: input.dimension.combine_count "
            "must not be 0.\n");
        return (errno = EINVAL);
    }
    
    if (output == NULL) {
        fprintf(stderr, "mediocre_combine: cannot have null output.\n");
        return (errno = EFAULT);
    }
    
    if (input.nonzero_error != 0) {
        errno = input.nonzero_error;
        perror("mediocre_combine input not constructed");
        return input.nonzero_error;
    }
    
    if (functor.nonzero_error != 0) {
        errno = functor.nonzero_error;
        perror("mediocre_combine functor not constructed");
        return functor.nonzero_error;
    }
    
    if (thread_count < 1) {
        fprintf(stderr, "mediocre_combine: needed positive thread_count.\n");
        return (errno = ERANGE);
    }
    
    MediocreDimension maximum_request = get_maximum_request(input.dimension);
    
    assert(maximum_request.width % 8 == 0 && maximum_request.width > 0);
    
    // First we need to allocate memory. We need one MediocreInputControl
    // structure, one MediocreFunctorControl for each thread, and two
    // struct functor_buffer instances for each MediocreFunctorControl. We
    // will allocate memory only once in this function using posix_memalign and
    // divide it up. (Note that the aligned_temp buffers inside a functor
    // control struct are not allocated by us since it's up to the implementor
    // whether that temporary storage is needed, but it is freed by us).
    
    // The actual size of each structure we need to allocate is variable
    // because of the flexible array member at the end. Calculate the
    // sizes of the flexible arrays and the sizes of the allocated structs.
    const size_t chunk_data_size =
        maximum_request.width * maximum_request.combine_count * sizeof(float);
    const size_t functor_buffer_size =
        sizeof(struct functor_buffer) + chunk_data_size;
    
    const size_t functor_threads_size =
        sizeof(MediocreFunctorControl) * (size_t)thread_count;
    const size_t mediocre_input_control_size = 
        sizeof(MediocreInputControl) + functor_threads_size;
    
    const size_t bytes_needed = 
        mediocre_input_control_size  // includes MediocreFunctorControl array.
      + (2u * thread_count) * functor_buffer_size;
    
    // Round the needed bytes up to next multiple of 32 for posix_memalign.
    const size_t bytes_allocated =
        (bytes_needed + sizeof(__m256) - 1) & (~(sizeof(__m256) - 1));
    
    void* allocated = NULL;
    status = posix_memalign(&allocated, sizeof(__m256), bytes_allocated);
    
    if (status == ENOMEM) {
        return (errno = ENOMEM);
    }
    CHECK_STATUS_VARIABLE("posix_memalign");
    
    // Get the portion of the allocated memory that is assigned as the array
    // of struct functor_buffer.
    struct functor_buffer* functor_buffers = (struct functor_buffer*)allocated;
    
    // Set up the MediocreInputControl instance. First get the memory for it
    // (which is after the array of struct functor_buffer), and initialize
    // its variables.
    MediocreInputControl* input_control =
        (MediocreInputControl*)(
        (char*)allocated + functor_buffer_size * 2u * thread_count);
    
    input_control->thread_count = (size_t)thread_count;
    input_control->input_dimension = input.dimension;
    input_control->maximum_request = maximum_request;
    input_control->previous_iteration_thread = NULL;
    input_control->combine_output = output;
    input_control->current_thread_index = 0;
    input_control->current_offset = 0;
    input_control->received_exit_command = 0;
    
    // Now initialize the array of MediocreFunctorControl.
    for (int i = 0; i < thread_count; ++i) {
        // Wait until later to start the functor thread.
        MediocreFunctorControl* functor_control =
            &input_control->functor_threads[i];
        
        status = sem_init(&functor_control->command_ready_sem, 0, 0);
            CHECK_STATUS_VARIABLE("sem_init command_ready_sem");
        
        status = sem_init(&functor_control->functor_ready_sem, 0, 0);
            CHECK_STATUS_VARIABLE("sem_init functor_ready_sem");
        
        functor_control->received_exit_command = 0;
        
        functor_control->functor_odd_flag = 0;
        functor_control->input_odd_flag = 0;
        
        // Remember there are twice as many functor_buffers as threads,
        // and that their size depends on the size of the array member.
        // The only initialization we need to do is to set nonzero_error to 0,
        // so that the threads don't immediately exit with an error code.
        functor_control->odd_input_buffer =
            (struct functor_buffer*)
            ((char*)functor_buffers + (2*i) * functor_buffer_size);
        
        functor_control->odd_input_buffer->nonzero_error = 0;
        
        functor_control->even_input_buffer =
            (struct functor_buffer*)
            ((char*)functor_buffers + (2*i + 1) * functor_buffer_size);
        
        functor_control->even_input_buffer->nonzero_error = 0;
        
        functor_control->aligned_temp = NULL;
        
        // Now we can finally launch the thread since the semaphores are ready.
        functor_control->functor_loop_function = functor.loop_function;
        functor_control->user_data = functor.user_data;
        functor_control->maximum_request = maximum_request;
        
        status = pthread_create(
            &functor_control->thread_id,
            NULL,
            functor_start_function,
            functor_control
        );
        // We try to be failure-tolerant if a thread fails to start due to
        // lack of resources (EAGAIN). In that case we destroy the semaphores
        // created for this thread and report the issue to the user.
        // We then change thread_count to the loop index to record how many
        // threads we actually have, so that the input loop still works
        // correctly and we don't accidentally clean up more functor control
        // structs than we created when the cleanup phase happens.
        if (status == EAGAIN) {
            status = sem_destroy(&functor_control->functor_ready_sem);
                CHECK_STATUS_VARIABLE("EAGAIN sem_destroy functor_ready_sem");
            
            status = sem_destroy(&functor_control->command_ready_sem);
                CHECK_STATUS_VARIABLE("EAGAIN sem_destroy command_ready_sem");
            
            if (i == 0) {
                perror("mediocre_combine could not start threads");
                free(allocated);
                return (errno = EAGAIN);
            } else {
                thread_count = i;
                input_control->thread_count = thread_count;
                const char* format =
                    "mediocre_combine: could only start %i threads";
                char str[sizeof format + 10];
                sprintf(str, format, thread_count);
                perror(str);
                break;
            }
        } else {
            CHECK_STATUS_VARIABLE("pthread_create");
        }
    }
    
    // We are trading some understandability for speed (and resource safety)
    // by only doing one memory allocation for all of the structures that we
    // need. Check that we allocated enough for all of our things. The input_
    // control structure is the last structure allocated in memory, and it ends
    // with the flexible array member input_control->functor_threads.
    assert((const char*)allocated + bytes_allocated >=
           (const char*)
           (input_control->functor_threads + input_control->thread_count));
    
    // We can finally pass control to the user's input loop.
    int error_code =
        input.loop_function(input_control, input.user_data, maximum_request);
    
    // Signal each thread to exit, then join the threads and reclaim
    // resources used in each MediocreFunctorControl structure.
    for (int i = 0; i < thread_count; ++i) {
        // Wait for completion and join thread.
        MediocreFunctorControl* control = &input_control->functor_threads[i];
        
        // Send command to functor thread to quit.
        input_buffer(control)->command_output = NULL;
        
        status = sem_post(&control->command_ready_sem);
            CHECK_STATUS_VARIABLE("sem_post");
        
        control->input_odd_flag = !control->input_odd_flag;
        
        status = pthread_join(control->thread_id, NULL);
            CHECK_STATUS_VARIABLE("pthread_join");
        
        // Destroy the resources used by the control structure.
        // thread_id already reclaimed by the join.
        status = sem_destroy(&control->functor_ready_sem);
            CHECK_STATUS_VARIABLE("sem_destroy functor_ready_sem");
        
        status = sem_destroy(&control->command_ready_sem);
            CHECK_STATUS_VARIABLE("sem_destroy command_ready_sem");
        
        // Memory for input_thread_buffer and functor_thread_buffer will be
        // freed when the memory we allocated for everything is freed.
        // We do however have to free aligned_temp; its memory did not come
        // from the large buffer we allocated.
        free(control->aligned_temp);
        
        // user_data will be freed by the user-supplied destructor, not us.
    }
    
    // Check for errors in either the input loop or any of the functor threads.
    if (error_code == 0 && !input_control->received_exit_command) {
        fprintf(stderr,
        "\x1b[1m\x1b[31mXXX\t\tXXX\t\tXXX\x1b[0m\n"
        "\tmediocre: Warning, a MediocreInput loop_function returned 0,\n"
        "\tindicating no error, but appears to have terminated\n"
        "\tabnormally. This is not guaranteed to work. Please fix\n"
        "\tthe input loop function if you can.\n"
        "\tReporting error code -1 instead of 0.\n"
        );
        
        error_code = -1;
    }
    
    for (int i = 0; i < thread_count; ++i) {
        // I'm not really sure what state my slimy double buffer implementation
        // will be in at this point so I'm checking both buffers for nonzero
        // error codes. You are welcome to hate me for this :(.
        MediocreFunctorControl* control = &input_control->functor_threads[i];
        
        if (error_code == 0) {
            error_code = control->odd_input_buffer->nonzero_error;
        }
        if (error_code == 0) {
            error_code = control->even_input_buffer->nonzero_error;
        }
    }
    
    free(allocated);
    return (errno = error_code);
}

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
) {
    int status = mediocre_combine(output, input, functor, thread_count);
    mediocre_input_destroy(input);
    mediocre_functor_destroy(functor);
    errno = status;
    return status;
}

/*  Convenience function for implementors of combine functor loops. Used  to
 *  acquire  a  32  byte aligned buffer suitable for temporarily writing the
 *  output of a combine function. The temporary output can then be copied to
 *  the      unaligned      command.output      pointer      by      calling
 *  mediocre_functor_write_temp (implemented as  an  inline  function).  The
 *  function  works  by  first checking if we need to use a temporary buffer
 *  anyway: if the output pointer already happens  to  be  aligned  and  the
 *  requested width happens to be a multiple of 8, then we can just cast the
 *  output  pointer  to  __m256*  and  give  it  back  to  the   user.   The
 *  implementation of mediocre_functor_write_temp checks for this and avoids
 *  copying the data if this is the case, since no temporary buffer was used
 *  in  the first place. Otherwise, the function checks for a cached aligned
 *  buffer inside the control structure (the structure is exclusively  owned
 *  by  this running functor thread) and returns it to the user. If it isn't
 *  there, we allocate it (with the allocation being wide  enough  to  store
 *  maximum_request.width  floats, where maximum_request.width is guaranteed
 *  to be divisible by 8). This might be much more memory than  we  promised
 *  the  caller  but  should  never  be less, since the command passed as an
 *  argument should have been created by the control structure passed, which
 *  will  never  create  a  command  with  a  dimension  field  greater than
 *  control->maximum_request. This buffer will be freed by  mediocre_combine
 *  when it joins all the functor threads.
 */
__m256* mediocre_functor_aligned_temp(
    MediocreFunctorCommand command, MediocreFunctorControl* control
) {
    if (
        command.dimension.width % 8 == 0 &&
        (uintptr_t)command.output % sizeof(__m256) == 0
    ) {
        return (__m256*)command.output;
    }
    
    MediocreDimension dim = command.dimension;
    assert(dim.width <= control->maximum_request.width);
    assert(dim.combine_count <= control->maximum_request.combine_count);
    
    if (control->aligned_temp == NULL) {
        void* ptr;
        const size_t bytes = sizeof(float) * control->maximum_request.width;
        assert(bytes % sizeof(__m256) == 0);
        int status = posix_memalign(&ptr, sizeof(__m256), bytes);
        
        if (status != 0) {
            errno = status;
            return NULL;
        }
        
        return (control->aligned_temp = (__m256*)ptr);
    }
    return control->aligned_temp;
}

