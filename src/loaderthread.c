
#include "loaderfunction.h"
#include "loaderthread.h"

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

struct MediocreLoaderThread {
    int command_pipe[2];
    int status_pipe[2];
    struct MediocreInputData input;
    int (*function)(struct MediocreLoaderArg);
    atomic_int status;
    int is_alive;
    pthread_t thread_id;
};

static const int busy = 0, do_read_status = 1, ready = 2;

static void exit_with_errno(struct MediocreLoaderThread* mthr) {
    int error = errno;
    if (error == 0) {
        fprintf(stderr, "mediocre loader thread exit with 'Success' errno.\n");
        error = -1;
    }
    assert(sizeof error <= PIPE_BUF);
    if (write(mthr->status_pipe[1], &error, sizeof error) != sizeof error) {
        perror("mediocre internal error exit_with_errno write");
        abort();
    }
    if (atomic_load(&mthr->status) == do_read_status) {
        fprintf(stderr, "mediocre internal error exit_with_errno status.\n");
        abort();
    }
    atomic_store(&mthr->status, do_read_status);
    pthread_exit(0);
}

static void* start_function(void* mediocre_loader_thread_pv) {
    struct MediocreLoaderThread* mthr =
        (struct MediocreLoaderThread*)mediocre_loader_thread_pv;
    
    int (*function)(struct MediocreLoaderArg) = mthr->function;
    
    struct MediocreLoaderArg arg;
    
    arg.input = mthr->input;
    
    while (1) {
        ssize_t bytes = read(
            mthr->command_pipe[0],
            &arg.command,
            sizeof arg.command
        );
        if (bytes != sizeof arg.command) {
            perror("mediocre internal error start_function read");
            if (errno == EINTR) {
                exit_with_errno(mthr);
            } else {
                abort();
            } 
        }
        
        // Null pointer in command.output indicates request for thread exit.
        if (arg.command.output == NULL) {
            return NULL;
        }
        assert(arg.command.start_index + arg.command.length
            <= arg.input.array_length
        );
        int err = function(arg);
        if (err != 0) {
            exit_with_errno(mthr);
            fprintf(stderr, "mediocre internal error start_function.\n");
            abort();
        }
        
        atomic_store(&mthr->status, do_read_status);
        int zero = 0;
        assert (sizeof zero <= PIPE_BUF);
        bytes = write(mthr->status_pipe[1], &zero, sizeof zero);
        if (bytes != sizeof zero) {
            perror("mediocre internal error start_function write");
            abort();
        }
    }
}

struct MediocreLoaderThread* mediocre_new_loader(
    struct MediocreInputData input_data,
    int (*function)(struct MediocreLoaderArg)
) {
    struct MediocreLoaderThread* mthr =
        (struct MediocreLoaderThread*)malloc(sizeof *mthr);
    
    if (mthr == NULL) {
        assert(errno == ENOMEM);
        return NULL;
    }
    
    int err = pipe(mthr->command_pipe);
    if (err == -1) {
        free(mthr);
        return NULL;
    }
    err = pipe(mthr->status_pipe);
    if (err == -1) {
        close(mthr->command_pipe[0]);
        close(mthr->command_pipe[1]);
        free(mthr);
        return NULL;
    }
    
    mthr->input = input_data;
    mthr->function = function;
    mthr->is_alive = 1;
    atomic_store(&mthr->status, ready);
    
    err = pthread_create(&mthr->thread_id, NULL, start_function, mthr);
    
    if (err != 0) {
        close(mthr->status_pipe[0]);
        close(mthr->status_pipe[1]);
        close(mthr->command_pipe[0]);
        close(mthr->command_pipe[1]);
        free(mthr);
        return NULL;
    }
    return mthr;
}

int mediocre_loader_begin(
    struct MediocreLoaderThread* mthr, struct MediocreLoaderCommand command
) {
    // Command with null pointer reserved to mean exit command.
    if (command.output == NULL) {
        fprintf(stderr, "mediocre internal error "
            "mediocre_loader_begin null pointer\n");
        abort();
    }
    int err = mediocre_loader_finish(mthr);
    if (err != 0) {
        return err;
    }
    // This won't work if writing a command struct to a pipe is not atomic.
    assert(sizeof command <= PIPE_BUF);
    atomic_store(&mthr->status, busy);
    err = write(mthr->command_pipe[1], &command, sizeof command);
    if (err != sizeof command) {
        perror("mediocre_loader_begin failed could not write to pipe");
        return -1;
    }
    return 0;
}

int mediocre_loader_finish(struct MediocreLoaderThread* mthr) {
    if (!mthr->is_alive) {
        fprintf(stderr, "mediocre loader thread no longer alive.\n");
        return -1;
    }
    const int status = atomic_load(&mthr->status);
    int errno_return;
    ssize_t bytes;
    switch (status) {
      default:
        fprintf(stderr, "mediocre internal error "
            "mediocre_loader_finish switch(%i)\n", status);
        abort();
      break; case ready:
      break; case busy: case do_read_status:
        bytes = read(mthr->status_pipe[0], &errno_return, sizeof errno_return);
        if (bytes != sizeof errno_return) {
            perror("mediocre internal error mediocre_loader_finish read");
            if (errno == EINTR) {
                return -1;
            } else {
                abort();
            }
        }
        atomic_store(&mthr->status, ready);
        if (errno_return != 0) {
            errno = errno_return;
            mthr->is_alive = 0;
            return -1;
        }
    }
    return 0;
}

int mediocre_delete_loader(struct MediocreLoaderThread* mthr) {
    int err = 0;
    int saved_errno = 0;
    if (mthr->is_alive) {
        err = mediocre_loader_finish(mthr);
        saved_errno = errno;
        
        // Null pointer in command.output indicates request for thread exit.
        struct MediocreLoaderCommand command = { NULL };
        assert (sizeof command <= PIPE_BUF);
        if (
            write(mthr->command_pipe[1], &command, sizeof command)
            != sizeof command
        ) {
            perror("mediocre internal error mediocre_delete_loader write");
            abort();
        }
    }
    
    if (pthread_join(mthr->thread_id, NULL) != 0) {
        perror("mediocre internal error mediocre_delete_loader pthread_join");
        abort();
    }
    
    int fd;
    
    if (close(fd = mthr->status_pipe[0]) != 0) goto fail_abort;
    if (close(fd = mthr->status_pipe[1]) != 0) goto fail_abort;
    if (close(fd = mthr->command_pipe[0]) != 0) goto fail_abort;
    if (close(fd = mthr->command_pipe[1]) != 0) goto fail_abort;
    free(mthr);
    
    fprintf(stderr, "debug: \x1b[33mdeleted loader thread.\x1b[0m\n");
    
    errno = saved_errno;
    return err;
    
  fail_abort:
    perror("mediocre internal error mediocre_delete_loader close");
    fprintf(stderr, "close(%i)\n", fd);
    abort();
}

