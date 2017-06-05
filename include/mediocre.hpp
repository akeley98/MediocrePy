/*  An aggresively average SIMD combine library.
 *  Copyright (C) 2017 David Akeley
 *  
 *  C++ interface XXX document later
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

#ifndef MediocrePy_MEDIOCRE_HPP_
#define MediocrePy_MEDIOCRE_HPP_

#include <string.h>
#include <memory>
#include <stdexcept>
#include <vector>

#include "mediocre.h"

namespace mediocre {

class error : std::runtime_error {
    int error_code_;
  public:
    error(int error_code) :
        std::runtime_error(strerror(error_code)),
        error_code_(error_code) { }
    
    int error_code() const {
        return error_code_;
    }
};

constexpr uintptr_t type_code(int8_t const volatile*) { return 8; }
constexpr uintptr_t type_code(int16_t const volatile*) { return 16; }
constexpr uintptr_t type_code(int32_t const volatile*) { return 32; }
constexpr uintptr_t type_code(int64_t const volatile*) { return 64; }
constexpr uintptr_t type_code(uint8_t const volatile*) { return 108; }
constexpr uintptr_t type_code(uint16_t const volatile*) { return 116; }
constexpr uintptr_t type_code(uint32_t const volatile*) { return 132; }
constexpr uintptr_t type_code(uint64_t const volatile*) { return 164; }
constexpr uintptr_t type_code(float const volatile*) { return 0xF; }
constexpr uintptr_t type_code(double const volatile*) { return 0xD; }

static inline MediocreInput
make_input(int8_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_i8_input(ptrs, dim);
}
static inline MediocreInput
make_input(int16_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_i16_input(ptrs, dim);
}
static inline MediocreInput
make_input(int32_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_i32_input(ptrs, dim);
}
static inline MediocreInput
make_input(int64_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_i64_input(ptrs, dim);
}
static inline MediocreInput
make_input(uint8_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_u8_input(ptrs, dim);
}
static inline MediocreInput
make_input(uint16_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_u16_input(ptrs, dim);
}
static inline MediocreInput
make_input(uint32_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_u32_input(ptrs, dim);
}
static inline MediocreInput
make_input(uint64_t const* const* ptrs, MediocreDimension dim) {
    return mediocre_u64_input(ptrs, dim);
}
static inline MediocreInput
make_input(float const* const* ptrs, MediocreDimension dim) {
    return mediocre_float_input(ptrs, dim);
}
static inline MediocreInput
make_input(double const* const* ptrs, MediocreDimension dim) {
    return mediocre_double_input(ptrs, dim);
}

template <typename T>
inline MediocreInput
make_input(std::vector<T*> const& ptrs, MediocreDimension dim) {
    return make_input(ptrs.data(), dim);
}

template <typename T>
inline Mediocre2D array_as_mediocre_2D(T const* ptr, size_t count) {
    size_t sz = sizeof(T);
    return { ptr, type_code(ptr), 1, count*sz, count, sz };
}

template <typename T>
inline Mediocre2D
c2d_as_mediocre_2D(T const* ptr, size_t rows, size_t columns) {
    size_t sz = sizeof(T);
    return { ptr, type_code(ptr), rows, columns*sz, columns, sz };
}

template <typename T>
inline Mediocre2D
f2d_as_mediocre_2D(T const* ptr, size_t rows, size_t columns) {
    size_t sz = sizeof(T);
    return { ptr, type_code(ptr), rows, sz, columns, rows*sz };
}

static inline std::vector<float> combine(
    MediocreInput input, MediocreFunctor functor, int thread_count
) {
    size_t float_count = mediocre_output_sizeof(input) / sizeof(float);
    std::vector<float> result(float_count);
    
    int status = mediocre_combine(
        result.data(),
        input,
        functor,
        thread_count
    );
    if (status != 0) {
        throw error(status);
    }
    
    return result;
}

} // end namespace

#endif

