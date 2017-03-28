
#include <stdatomic.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "chunkutil.h"
#include "convert.h"    // Todo replace this file to support non-uint16_t input.

struct MediocreLoaderThread {
    pthread_t handle;
    
    atomic_intptr_t start_bin_index;
    atomic_intptr_t output_pointer;
    atomic_intptr_t bin_count; // Wait for this to be nonzero to begin.
    atomic_intptr_t loader_ready_flag;
    
    void const* input_pointers,
    uintptr_t input_type_code,
    size_t input_pointer_count
};

static inline void wait_for_true_atomic(atomic_intptr_t* a) {
    struct timespec t;
    while (!atomic_load(a)) {
        t = { 0, 5000 }; // 5 microseconds.
        nanosleep(&t, &t);
    }
}

static void* loader_start_function(void* thread_data_pv);

struct MediocreLoaderThread* mediocre_create_loader_thread(
    void const* input_pointers,
    uintptr_t input_type_code,
    size_t input_pointer_count
) {
    struct MediocreLoaderThread* thread_data =
        (struct MediocreLoaderThread*)malloc(sizeof *thread_data);
    
    if (thread_data == NULL) {
        assert(errno == ENOMEM);
        fprintf(stderr, "Could not allocate thread_data.\n");
        return NULL;
    }
    memset(s, 0, sizeof *s);
    
    int create_code = pthread_create(
        &thread_data->handle, NULL, loader_start_function, thread_data
    );
    
    if (create_code != 0) {
        free(thread_data);
        perror("Could not create new thread");
        return NULL;
    }
    
    store_atomic(&thread_data->loader_ready_flag, 1);
    thread_data->input_pointers = input_pointers;
    thread_data->input_type_code = input_type_code;
    thread_data->input_pointer_count = input_pointer_count;
    
    return thread_data;
}

/*  Command the loader to load and convert the bin_count entries starting from
 *  start_bin_index from each array pointed to by the input pointers and write
 *  it to the specified output pointer in the chunk format.
 *  
 *  Example:
 *      thread_data->input_pointer_count = 2
 *      start_bin_index = 1,
 *      bin_count = 10
 *  
 *  input_pointers[0]:
 *      -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
 *  input_pointers[1]:
 *      100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112
 *  
 *  after mediocre_loader_wait:
 *  
 *  output:
 *      [  1.0,   2.0,   3.0,   4.0,   5.0,   6.0,   7.0,   8.0],
 *      [101.0, 102.0, 103.0, 104.0, 105.0, 106.0, 107.0, 108.0],
 *      [  9.0,  10.0,   0.0,   0.0,   0.0,   0.0,   0.0,   0.0],
 *      [109.0, 110.0,   0.0,   0.0,   0.0,   0.0,   0.0,   0.0]
 */
void mediocre_loader_load_chunk(
    struct MediocreLoaderThread* thread_data,
    __m256* output,
    size_t start_bin_index,
    size_t bin_count
) {
    wait_for_true_atomic(&thread_data->loader_ready_flag);
    atomic_store(&thread_data->loader_ready_flag, 0);
    
    atomic_store(&thread_data->start_bin_index, start_bin_index);
    atomic_store(&thread_data->output_pointer, (intptr_t)output);
    atomic_store(&thread_data->bin_count, bin_count);
}

/*  Wait for the loader to finish writing out  its  output  the  last  command
 *  issued. Returns immediately if it's not working on any command.
 */
void mediocre_loader_wait(struct MediocreLoaderThread* thread_data) {
    wait_for_true_atomic(&thread_data->loader_ready_flag);
}

void mediocre_delete_loader_thread(struct MediocreLoaderThread* thread_data) {
    int err = pthread_cancel(thread_data->handle);
    if (err != 0) {
        perror("mediocre internal error pthread_cancel");
        abort();
    }
    err = pthread_join(thread_data->handle, NULL);
    if (err != 0) {
        perror("mediocre internal error pthread_join");
        abort();
    }
    
    fprintf(stderr, "Deleted loader thread.\n"); // XXX remove later.
    
    free(thread_data);
}

/*  Function  that  sits   around   until   it   receives   a   command   from
 *  mediocre_loader_load_chunk  (which  modifies  the  atomic variables in the
 *  thread_data struct. The function waits for bin_count to be nonzero,  which
 *  the  commanding function sets last. Once it's given a command, it sets the
 *  loader_ready_flag to zero and loads, converts, and  interleaves  the  data
 *  from  the arrays pointed to by the input pointers and writes it out in the
 *  chunk format to the output buffer specified in the command  (TODO  explain
 *  chunk  format).  The function never returns. It waits to be cancelled when
 *  it nanosleeps while waiting for a command.
 */
static void* loader_start_function(void* thread_data_pv) {
    struct MediocreLoaderThread* thread_data =
        (struct MediocreLoaderThread*)thread_data_pv;
    
    while (1) {
        wait_for_true_atomic(thread_data->end_bin_index);
        
        
    }
}

