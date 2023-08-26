/*  An aggresively average SIMD combine library
 *  Copyright (C) 2017 David Akeley
 *  
 *  Tests for the kinds of MediocreInput implemented by the library.
 *  Compare the fast input algorithms of the library with the slower, simpler
 *  input algorithms here to check for correctness. We use the mean combine
 *  functor as part of the test, so if something goes wrong it could also be
 *  its fault, but mean is the simplest functor so it's probably 100% correct.
 *  
 *  XXX masked input not checked. Try checking it in Python tests?
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/timeb.h>
#include <memory>
#include <utility>
#include <vector>
#include <type_traits>

#include "mediocre.hpp"
#include "testing.h"

static const uint32_t min_axis_size = 2049;
static const uint32_t max_axis_size = 4096;
static const uint32_t min_combine_count = 5;
static const uint32_t max_combine_count = 12;

static struct Random* generator;
static uint64_t seed;
MediocreFunctor mean_functor = mediocre_mean_functor();

static std::vector<float> mean(MediocreInput input) {
    return mediocre::combine(input, mean_functor, 2);
}

struct Testing2DBase {
    virtual float get(size_t x, size_t y) const = 0;
    virtual Mediocre2D as_mediocre_2D() const = 0;
    virtual ~Testing2DBase() { }
    virtual std::pair<size_t, size_t> strides() const = 0;
};

template <typename T>
class Testing2D : public Testing2DBase {
    struct CanaryPage canary_page;
    const size_t x_size, y_size;
    const size_t x_stride, y_stride;
    
    void set(size_t x, size_t y, T t) {
        char* char_ptr = static_cast<char*>(canary_page.ptr);
        T* t_ptr = reinterpret_cast<T*>(char_ptr + x*x_stride + y*y_stride);
        *t_ptr = t;
    }
  public:
    Testing2D(
        std::pair<size_t, size_t> size,
        std::pair<size_t, size_t> strides,
        struct Random* rand
    ) :
        x_size(size.first), y_size(size.second),
        x_stride(strides.first), y_stride(strides.second)
    {
        size_t bytes = (x_size-1)*x_stride + (y_size-1)*y_stride + sizeof(T);
        
        if (init_canary_page(&canary_page, bytes, 0) != 0) {
            perror("Testing2D::Testing2D init_canary_page");
            exit(1);
        }
        for (size_t x = 0; x < x_size; ++x) {
            for (size_t y = 0; y < y_size; ++y) {
                if (std::is_integral<T>::value) {
                    set(x, y, T(137 * random_u32(rand)));
                } else {
                    set(x, y, T(137.035999139 * random_u32(rand)));
                }
            }
        }
    }
    // Constructor with randomized strides.
    Testing2D(std::pair<size_t, size_t> size, struct Random* rand)
    : Testing2D(
        size,
        {
            sizeof(T) * (size.second + random_dist_u32(rand, 0, 15)),
            sizeof(T) * (1 + random_dist_u32(rand, 0, 15))
        },
        rand
    ) { }
    
    ~Testing2D() override {
        free_canary_page(canary_page);
    }
    
    T const* data() const {
        return static_cast<T const*>(canary_page.ptr);
    }
    
    float get(size_t x, size_t y) const override {
        char* char_ptr = static_cast<char*>(canary_page.ptr);
        T* t_ptr = reinterpret_cast<T*>(char_ptr + x*x_stride + y*y_stride);
        return static_cast<float>(*t_ptr);
    }
    
    Mediocre2D as_mediocre_2D() const override {
        return {
            canary_page.ptr,
            uintptr_t(mediocre::type_code(static_cast<T*>(canary_page.ptr))),
            x_size, x_stride,
            y_size, y_stride
        };
    }
    
    std::pair<size_t, size_t> strides() const override {
        return { x_stride, y_stride };
    }
};

template <typename T>
class TestingArray {
    struct CanaryPage canary_page;
    const size_t size;
    
    void set(size_t x, T t) {
        static_cast<T*>(canary_page.ptr)[x] = t;
    }
  public:
    TestingArray(size_t size_arg, struct Random* rand) : size(size_arg) {
        if (init_canary_page(&canary_page, size*sizeof(T), 0) != 0) {
            perror("TestingArray::TestingArray init_canary_page");
            exit(1);
        }
        for (size_t x = 0; x < size; ++x) {
            if (std::is_integral<T>::value) {
                set(x, T(137 * random_u32(rand)));
            } else {
                set(x, T(137.035999139 * random_u32(rand)));
            }
        }
    }
    
    ~TestingArray() {
        free_canary_page(canary_page);
    }
    
    T const* data() const {
        return static_cast<T const*>(canary_page.ptr);
    }
    
    float get(size_t x) const {
        return static_cast<T const*>(canary_page.ptr)[x];
    }
};

// Test input of stack of contiguous arrays, all with the same datatype T.
template <typename T>
inline void test_contiguous(const char* type_label) noexcept {
    size_t const combine_count = random_dist_u32(
        generator, min_combine_count, max_combine_count
    );
    size_t const rows =
        random_dist_u32(generator, min_axis_size, max_axis_size);
    size_t const columns =
        random_dist_u32(generator, min_axis_size, max_axis_size);
    size_t const total_size = rows * columns;
    
    std::vector<std::unique_ptr<TestingArray<T>>> arrays(combine_count);
    std::vector<T const*> data_ptrs(combine_count);
    std::vector<Mediocre2D> mediocre_arrays(combine_count);
    std::vector<Mediocre2D> c2d_mediocre_arrays(combine_count);
    std::vector<Mediocre2D> f2d_mediocre_arrays(combine_count);
    
    // Set up our stack of [combine_count] homogeoneous contiguous arrays.
    for (size_t i = 0; i < combine_count; ++i) {
        TestingArray<T>* arr = new TestingArray<T>(total_size, generator);
        arrays[i].reset(arr);
        
        using namespace mediocre;
        data_ptrs[i] = arr->data();
        mediocre_arrays[i] = array_as_mediocre_2D(arr->data(), total_size);
        c2d_mediocre_arrays[i] = c2d_as_mediocre_2D(arr->data(), rows, columns);
        f2d_mediocre_arrays[i] = f2d_as_mediocre_2D(arr->data(), rows, columns);
    }
    
    // Calculate the expected result of the mean combine of these arrays.
    std::vector<float> expected_result(total_size);
    for (size_t x = 0; x < total_size; ++x) {
        float total = 0.0;
        for (size_t i = 0; i < combine_count; ++i) {
            total += arrays[i]->get(x);
        }
        expected_result[x] = total / float(combine_count);
    }
    
    printf("\tSeed = %zi\n", size_t(seed));
    printf("\tAveraging %zi contiguous %s arrays of width %zi\n",
        combine_count, type_label, total_size
    );
    struct timeb begin_time;
    
    // Use the homogeneous 1D input objects in calculating the mean.
    MediocreInput input = mediocre::make_input(
        data_ptrs, { combine_count, total_size } 
    );
    ftime(&begin_time);
    std::vector<float> result = mean(input);
    printf("\x1b[32m\x1b[1m%s homogeneous input: ", type_label);
    print_timer_elapsed(begin_time, total_size*combine_count);
    printf("\x1b[0m\n");
    mediocre_input_destroy(input);
    
    for (size_t x = 0; x < total_size; ++x) {
        if (result[x] != expected_result[x]) {
            printf("[%zi] %f != %f\n", x, result[x], expected_result[x]);
            exit(1);
        }
    }
    
    // Use the Mediocre2D input describing the input arrays as 1D arrays.
    input = mediocre_2D_input(mediocre_arrays.data(), combine_count);
    ftime(&begin_time);
    result = mean(input);
    printf("\x1b[33m\x1b[1m%s Mediocre2D input [1D]: ", type_label);
    print_timer_elapsed(begin_time, total_size*combine_count);
    printf("\x1b[0m\n");
    mediocre_input_destroy(input);
    
    for (size_t x = 0; x < total_size; ++x) {
        if (result[x] != expected_result[x]) {
            printf("[%zi] %f != %f\n", x, result[x], expected_result[x]);
            exit(1);
        }
    }
    
    // Use the Mediocre2D input describing the input arrays as 2D C arrays.
    input = mediocre_2D_input(c2d_mediocre_arrays.data(), combine_count);
    ftime(&begin_time);
    result = mean(input);
    printf("\x1b[34m\x1b[1m%s Mediocre2D input [C order]: ", type_label);
    print_timer_elapsed(begin_time, total_size*combine_count);
    printf("\x1b[0m\n");
    mediocre_input_destroy(input);
    
    // The output is in C order, which matches the expected_result vector.
    for (size_t r = 0; r < rows; ++r) {
        for (size_t c = 0; c < columns; ++c) {
            float this_result = result[r*columns + c];
            float this_expected = result[r*columns + c];
            if (this_result != this_expected) {
                printf("[%zi %zi] %f != %f\n",r, c, this_result, this_expected);
                exit(1);
            }
        }
    }
    
    // Use the Mediocre2D input describing the arrays as 2D Fortran arrays.
    input = mediocre_2D_input(f2d_mediocre_arrays.data(), combine_count);
    ftime(&begin_time);
    result = mean(input);
    printf("\x1b[35m\x1b[1m%s Mediocre2D input [Fortran order]: ", type_label);
    print_timer_elapsed(begin_time, total_size*combine_count);
    printf("\x1b[0m\n\n\n");
    mediocre_input_destroy(input);
    
    for (size_t r = 0; r < rows; ++r) {
        for (size_t c = 0; c < columns; ++c) {
            float total = 0.0f;
            
            for (size_t i = 0; i < combine_count; ++i) {
                total += arrays[i]->get(r + c*rows);
            }
            
            float this_result = result[r*columns + c];
            float this_expected = total / float(combine_count);
            if (this_result != this_expected) {
                printf("[%zi %zi] %f != %f\n",r, c, this_result, this_expected);
                exit(1);
            }
        }
    }
}

// Test input of 2D arrays with different data types and unusual strides.
static void test_2D() noexcept {
    size_t const combine_count = random_dist_u32(
        generator, min_combine_count, max_combine_count
    );
    size_t const rows =
        random_dist_u32(generator, min_axis_size, max_axis_size);
    size_t const columns =
        random_dist_u32(generator, min_axis_size, max_axis_size);
    size_t const total_size = rows * columns;
    
    std::vector<std::unique_ptr<Testing2DBase>> arrays(combine_count);
    std::vector<Mediocre2D> mediocre_arrays(combine_count);
    std::pair<size_t, size_t> strides;
    Testing2DBase* new_array = nullptr;
    
    printf("  Seed = %zi\n", size_t(seed));
    printf("  Averaging these arrays:\n\n");
    
    // Set up our stack of [combine_count] homogeoneous contiguous arrays.
    for (size_t i = 0; i < combine_count; ++i) {
        switch(random_dist_u32(generator, 0, 9)) {
          default:
            assert(0);
          break; case 0:
            new_array = new Testing2D<int8_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tint8_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 1:
            new_array = new Testing2D<int16_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tint16_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 2:
            new_array = new Testing2D<int32_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tint32_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 3:
            new_array = new Testing2D<int64_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tint64_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 4:
            new_array = new Testing2D<uint8_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tuint8_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 5:
            new_array = new Testing2D<uint16_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tuint16_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 6:
            new_array = new Testing2D<uint32_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tuint32_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 7:
            new_array = new Testing2D<uint64_t>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tuint64_t array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 8:
            new_array = new Testing2D<float>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tfloat array with strides (%zi, %zi)\n",
                strides.first, strides.second);
          break; case 9:
            new_array = new Testing2D<double>({rows, columns}, generator);
            arrays[i].reset(new_array);
            mediocre_arrays[i] = new_array->as_mediocre_2D();
            strides = new_array->strides();
            printf("\tdouble array with strides (%zi, %zi)\n",
                strides.first, strides.second);
        }
    }
    
    // Calculate the expected result of combining the 2D arrays in C order.
    std::vector<float> expected_result(total_size);
    
    for (size_t r = 0; r < rows; ++r) {
        for (size_t c = 0; c < columns; ++c) {
            float total = 0.0f;
            for (size_t i = 0; i < combine_count; ++i) {
                total += arrays[i]->get(r, c);
            }
            expected_result[r*columns + c] = total / float(combine_count);
        }
    }
    
    struct timeb begin_time;
    MediocreInput input =
        mediocre_2D_input(mediocre_arrays.data(), combine_count);
    
    ftime(&begin_time);
    std::vector<float> result = mean(input);
    printf("\x1b[36m\x1b[1mHeterogeneous Mediocre2D input: ");
    print_timer_elapsed(begin_time, total_size*combine_count);
    printf("\x1b[0m\n\n\n");
    mediocre_input_destroy(input);
    
    for (size_t r = 0; r < rows; ++r) {
        for (size_t c = 0; c < columns; ++c) {
            float this_result = result[r*columns + c];
            float this_expected = expected_result[r*columns + c];
            if (this_result != this_expected) {
                printf("[%zi %zi] %f != %f\n",r, c, this_result, this_expected);
                exit(1);
            }
        }
    }
}

int main() {
    generator = new_random();
    seed = get_seed(generator);
    for (int i = 0; i < 80; ++i) {
        for (int j = 0; j < 12; ++j) {
            test_2D();
        }
        test_contiguous<int8_t>("int8_t");
        test_contiguous<int16_t>("int16_t");
        test_contiguous<int32_t>("int32_t");
        test_contiguous<int64_t>("int64_t");
        test_contiguous<uint8_t>("uint8_t");
        test_contiguous<uint16_t>("uint16_t");
        test_contiguous<uint32_t>("uint32_t");
        test_contiguous<uint64_t>("uint64_t");
        test_contiguous<float>("float");
        test_contiguous<double>("double");
    }
}

