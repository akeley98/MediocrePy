/*  An aggresively average SIMD combine library.
 *  Copyright (C) 2017 David Akeley
 *  
 *  Verbose debugging functions for combine.c
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

#ifndef MediocrePy_COMBINEDEBUG_H_
#define MediocrePy_COMBINEDEBUG_H_

static pthread_mutex_t verbose_mtx = PTHREAD_MUTEX_INITIALIZER;
#define LOCK pthread_mutex_lock(&verbose_mtx);
#define UNLOCK pthread_mutex_unlock(&verbose_mtx);

static inline void print_thread(
    MediocreFunctorControl* functor_control
) {
    printf("\x1b[1m\x1b[%dmfunctor thread [%p]\x1b[0m",
        30 + (int)((uintptr_t)functor_control / sizeof(*functor_control) % 7),
        functor_control);
}

static inline void verbose_command_sem_post(
    MediocreFunctorControl* functor_control
) {
    if (mediocre_combine_verbose) {
        LOCK
        printf("\x1b[32mMediocreInput thread:\x1b[0m\n"
            "  Command ready, posting ");
        print_thread(functor_control);
        printf(" command_ready_sem.\n");
        UNLOCK
    }
}

static inline void verbose_command_sem_wait(
    MediocreFunctorControl* functor_control
) {
    if (mediocre_combine_verbose) {
        LOCK
        print_thread(functor_control);
        printf(": waiting for command_ready_sem.\n");
        UNLOCK
    }
}

static inline void verbose_functor_sem_post(
    MediocreFunctorControl* functor_control
) {
    if (mediocre_combine_verbose) {
        LOCK
        print_thread(functor_control);
        printf(": posting functor_ready_sem.\n");
        UNLOCK
    }
}

static inline void verbose_functor_sem_wait(
    MediocreFunctorControl* functor_control
) {
    if (mediocre_combine_verbose) {
        LOCK
        printf("\x1b[32mMediocreInput thread:\x1b[0m\n"
            " waiting for ");
        print_thread(functor_control);
        printf("\n");
        UNLOCK
    }
}

static inline void print_input_buffer(
    MediocreInputControl* input_control,
    __m256* buf
) {
    for (size_t i = 0; i < input_control->thread_count; ++i) {
        MediocreFunctorControl* functor_control =
            &input_control->functor_threads[i];
        
        if (functor_control->odd_input_buffer->chunk_data == buf) {
            print_thread(functor_control);
            printf("\x1b[33m odd buffer [%p]\x1b[0m", buf);
            return;
        } else if (functor_control->even_input_buffer->chunk_data == buf) {
            print_thread(functor_control);
            printf("\x1b[36m even buffer [%p]\x1b[0m", buf);
            return;
        }
    }
    printf("\x1b[1m\x1b[41mUnknown buffer [%p]\x1b[0m", buf);
}

static inline void print_functor_buffer(
    MediocreFunctorControl* functor_control,
    __m256* buf
) {
    if (functor_control->odd_input_buffer->chunk_data == buf) {
        print_thread(functor_control);
        printf("\x1b[33m odd buffer [%p]\x1b[0m", buf);
    } else if (functor_control->even_input_buffer->chunk_data == buf) {
        print_thread(functor_control);
        printf("\x1b[36m even buffer [%p]\x1b[0m", buf);
    } else {
        printf("\x1b[1m\x1b[41mUnknown buffer [%p]\x1b[0m", buf);
    }
}

static inline void print_dimension(MediocreDimension dim) {
    printf("{combine_count=0x%zX, width=0x%zX}", dim.combine_count, dim.width);
}

static inline void verbose_input_command(
    MediocreInputControl* input_control,
    MediocreInputCommand command
) {
    if (mediocre_combine_verbose) {
        LOCK
        if (command._exit) {
            printf("\x1b[32mCommanding input loop_function to exit.\x1b[0m\n");
        } else {
            printf("\x1b[32mIssued input loop_function command:\x1b[0m");
            printf("\n  offset 0x%zX", command.offset);
            printf("\n  dimension ");
            print_dimension(command.dimension);
            printf("\n  output_chunks ");
            print_input_buffer(input_control, command.output_chunks);
            printf("\n");
        }
        UNLOCK
    }
}

static inline void verbose_functor_command(
    MediocreFunctorControl* functor_control,
    MediocreFunctorCommand command
) {
    if (mediocre_combine_verbose) {
        LOCK
        printf("\x1b[35mIssued functor command to\x1b[0m ");
        print_thread(functor_control);
        if (command._exit) {
            printf("  exit command\n");
        } else {
            printf("\n  dimension ");
            print_dimension(command.dimension);
            printf("\n  input_chunks ");
            print_functor_buffer(functor_control, command.input_chunks);
            printf("\n  output %p\n", command.output);
        }
        UNLOCK
    }
}

static inline void verbose_input_control(
    MediocreInputControl* input_control,
    void const* allocated_start,
    void const* allocated_end
) {
    if (mediocre_combine_verbose) {
        LOCK
        printf("Allocated memory [%p, %p)", allocated_start, allocated_end);
        printf("\nMediocreInputControl @ %p", input_control);
        printf("\nthread_count %zi", input_control->thread_count);
        printf("\ninput_dimension ");
        print_dimension(input_control->input_dimension);
        printf("\nmaximum_request ");
        print_dimension(input_control->maximum_request);
        for (size_t i = 0; i < input_control->thread_count; ++i) {
            MediocreFunctorControl* f_control =
                &input_control->functor_threads[i];
            printf("\n  ");
            print_thread(f_control);
            printf("\n\x1b[33m  odd buffer \x1b[0m [struct@%p, chunk_data@%p]",
                f_control->odd_input_buffer,
                &f_control->odd_input_buffer->chunk_data
            );
            printf("\n\x1b[36m  even buffer\x1b[0m [struct@%p, chunk_data@%p]",
                f_control->even_input_buffer,
                &f_control->even_input_buffer->chunk_data
            );
        }
        printf("\n");
        UNLOCK
    }
}

#endif

