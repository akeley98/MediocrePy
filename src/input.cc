
#include <assert.h>
#include <errno.h>
#include <immintrin.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include <algorithm>
#include <new>
#include <type_traits>
#include <utility>
#include <vector>

#include "mediocre.h"

namespace {

/*  The data type of a Mediocre2D object is determined at run  time  through
 *  the  type_code  member,  but  these  templatized functions have the type
 *  they're designed to work  on  determined  at  compile  time.  Call  this
 *  function  within  a  templatized  function  to check that the Mediocre2D
 *  object has the correct runtime type for the chosen template function.
 */
template <typename T>
void check_type_code(Mediocre2D arg) {
    bool is_okay;
    switch (arg.type_code) {
      default:
        is_okay = false;
      break; case 8:
        is_okay = std::is_same<T, int8_t>::value;
      break; case 16:
        is_okay = std::is_same<T, int16_t>::value;
      break; case 32:
        is_okay = std::is_same<T, int32_t>::value;
      break; case 64:
        is_okay = std::is_same<T, int64_t>::value;
      break; case 108:
        is_okay = std::is_same<T, uint8_t>::value;
      break; case 116:
        is_okay = std::is_same<T, uint16_t>::value;
      break; case 132:
        is_okay = std::is_same<T, uint32_t>::value;
      break; case 164:
        is_okay = std::is_same<T, uint64_t>::value;
      break; case 0xF:
        is_okay = std::is_same<T, float>::value;
      break; case 0xD:
        is_okay = std::is_same<T, double>::value;
    }
    
    assert(is_okay);
}

/*  Non-templatized, inefficient function for indexing a  Mediocre2D  array.
 *  coordinates  should  be  a pair of major and minor indices. The function
 *  should only be used in the mask functions for fetching data for  use  in
 *  median filtering; the most important functions for loading from the data
 *  array are templatized on the data array's type and should not  use  this
 *  function.  We  choose  to  handle  the data type of the input at runtime
 *  instead of compile time there because we expect that not so many  pixels
 *  will  be masked out (we only need to access the data array when the mask
 *  array indicates bad pixels), and to avoid having to write mask functions
 *  with  two  template parameters (data and mask type), which would require
 *  instantiating a huge number of template functions.
 */
inline float get_data(
    Mediocre2D data,
    std::pair<size_t, size_t> coordinate
) {
    void const* ptr =
        static_cast<char const*>(data.data)
      + data.major_stride * coordinate.first
      + data.minor_stride * coordinate.second;
    
    assert(coordinate.first < data.major_width);
    assert(coordinate.second < data.minor_width);
    
    switch (data.type_code) {
        default: assert(0); abort();
    
        case 8:   return *static_cast<int8_t const*>(ptr);
        case 16:  return *static_cast<int16_t const*>(ptr);
        case 32:  return *static_cast<int32_t const*>(ptr);
        case 64:  return *static_cast<int64_t const*>(ptr);
        case 108: return *static_cast<uint8_t const*>(ptr);
        case 116: return *static_cast<uint16_t const*>(ptr);
        case 132: return *static_cast<uint32_t const*>(ptr);
        case 164: return *static_cast<uint64_t const*>(ptr);
        case 0xF: return *static_cast<float const*>(ptr);
        case 0xD: return *static_cast<double const*>(ptr);
    }
}

/*  Index a mask 2D array with the given pair of (major, minor) indices  and
 *  return true if the mask array indicates that coordinate has a bad pixel.
 *  People don't seem to agree  whether  a  truthy  (nonzero)  value  should
 *  indicate  a  bad pixel or a falsey value should indicate a bad pixel, so
 *  the function supports both  conventions  through  the  nonzero_means_bad
 *  argument.
 */
template <typename MaskType>
inline bool mask_is_bad_coordinate(
    Mediocre2D mask,
    std::pair<size_t, size_t> coordinate,
    bool nonzero_means_bad
) {
    void const* ptr =
        static_cast<char const*>(mask.data)
      + mask.major_stride * coordinate.first
      + mask.minor_stride * coordinate.second;
    
    assert(coordinate.first < mask.major_width);
    assert(coordinate.second < mask.minor_width);
    
    return (*static_cast<MaskType const*>(ptr) != 0) == nonzero_means_bad;
}

/*  Perform a 5 x 5 median filter on a coordinate given a pair of  data  and
 *  mask  2D  arrays. The arrays should have the same dimensions. We collect
 *  all numbers from the data array that are not  masked  out  by  the  mask
 *  array within a 5 x 5 box centered on the specified coordinate and return
 *  the median of those numbers. If the coordinate  specified  is  within  2
 *  pixels  of  the  edge  of the arrays, the box will be smaller than 5 x 5
 *  (edge pixels are not repeated in this implementation).  Returns  NAN  if
 *  all nearby pixels were masked out.
 */
template <typename MaskType>
inline float median_filter(
    MediocreMasked2D masked_2D,
    std::pair<size_t, size_t> coordinate,
    bool nonzero_means_bad
) {
    check_type_code<MaskType>(masked_2D.mask_2D);
    
    const size_t major_width = masked_2D.mask_2D.major_width;
    const size_t minor_width = masked_2D.mask_2D.minor_width;
    
    const size_t coord_major = coordinate.first;
    const size_t coord_minor = coordinate.second;
    
    // Calculate the bounds of the box of numbers used for the median filter.
    // Normally this is just [x-2, x+2], but we need to check for coordinates
    // near the edge, and shrink the box if needed. We need to worry about
    // underflow but not overflow (size_t is never that large for real data).
    const size_t major_start = coord_major < 2 ? 0 : coord_major - 2;
    const size_t minor_start = coord_minor < 2 ? 0 : coord_minor - 2;
    
    const size_t major_last = coord_major + 2 >= major_width
        ? major_width - 1 : coord_major + 2;
    
    const size_t minor_last = coord_minor + 2 >= minor_width
        ? minor_width - 1 : coord_minor + 2;
    
    // Collect the numbers.
    float numbers[25];
    size_t number_count = 0;
    
    for (size_t major = major_start; major <= major_last; ++major) {
        for (size_t minor = minor_start; minor <= minor_last; ++minor) {
            std::pair<size_t, size_t> current(major, minor);
            bool bad = mask_is_bad_coordinate<MaskType>(
                masked_2D.mask_2D, current, nonzero_means_bad
            );
            if (!bad) {
                numbers[number_count++] = get_data(masked_2D.data_2D, current);
            }
        }
    }
    
    // Sort the portion of the numbers array that hold valid data and
    // calculate the median from that sorted portion.
    assert(number_count <= 25);
    
    if (number_count == 0) {
        return 0.0f / 0.0f;
    } else {
        std::sort(numbers, numbers + number_count);
        return 0.5f * (numbers[(number_count-1)/2] + numbers[number_count/2]);
    }
}

#define LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr) do { \
    ptr = reinterpret_cast<DataType const*>(current_pointer); \
    bool at_row_end = minor+1 >= data.minor_width; \
    minor = at_row_end ? 0 : minor+1; \
    row_pointer = at_row_end ? row_pointer + data.major_stride : row_pointer; \
    current_pointer = \
        at_row_end ? row_pointer : current_pointer + data.minor_stride; \
} while (0)
    
/*  Each time the input loop receives a command, it is expected  to  load  a
 *  portion   of   data   from  N  Mediocre2D  instances,  where  N  is  the
 *  combine_count.  This  function  handles  loading  the  portion  of  data
 *  specified  by the input command from just one Mediocre2D array, and will
 *  be called N times for each command issued. which_array  specifies  which
 *  of  the  N  arrays  should  currently  be  processed, and the Mediocre2D
 *  argument should be that array. The function writes to every  Nth  __m256
 *  vector  starting  from command.output_chunks + which_array, because each
 *  chunk is N vectors wide and the vector indexed by [which_array] within a
 *  single  chunk  is  the  position  corresponding to data from input array
 *  number [which_array].
 */
template <typename DataType>
void load_data(
    MediocreInputCommand command,
    Mediocre2D data,
    size_t which_array
) {
    check_type_code<DataType>(data);
    __m256* current_chunk = command.output_chunks;
    
    const DataType zero = 0;
    
    DataType const* ptr0 = &zero;
    DataType const* ptr1 = &zero;
    DataType const* ptr2 = &zero;
    DataType const* ptr3 = &zero;
    DataType const* ptr4 = &zero;
    DataType const* ptr5 = &zero;
    DataType const* ptr6 = &zero;
    DataType const* ptr7 = &zero;
    
    assert((command.offset + command.dimension.width) / data.minor_width
        <= data.major_width);
    assert((command.offset + command.dimension.width) % data.minor_width
        <= data.minor_width);
    
    // The input loop understands only 1D arrays. Convert the 1D offset
    // we got to 2D coordinates: major and minor indices.
    size_t major = command.offset / data.minor_width;
    size_t minor = command.offset % data.minor_width;
    
    // You have to look at the magic macro to see how this works. I could have
    // used a lambda instead of a macro but I didn't; I'm really only using
    // C++ here for templates, otherwise I would have used C. The Mediocre2D
    // array is indexed by a major index and a minor index. Think of a row
    // as a group of numbers that share the same major index. current_pointer
    // points to the number in the array with the current major and minor
    // indeces of the number to be loaded. row_pointer points to the
    // beginning of the row that the current number is in (i.e. the number
    // with the same major index but zero minor index). Each time the
    // macro is called, the pointer argument is set to the current_pointer,
    // and current_pointer is moved to the next number in the array. Normally
    // the next number is just found by incrementing the minor index (and by
    // extension, incrementing current_pointer by minor_stride), but if we
    // are at the end of a row (minor index == minor_width), then row pointer
    // is set to point to the next row (major index + 1) by incrementing it
    // by major_stride, and current_pointer and the minor index are reset
    // to row_pointer and zero respectively.
    char const* row_pointer = reinterpret_cast<char const*>(data.data)
        + major*data.major_stride;
    
    char const* current_pointer = row_pointer + minor*data.minor_stride;
    
    // Calculate eight data pointers at once. The requested width may
    // not be a multiple of 8: in that case, in the last iteration of
    // this loop the extra pointers will be cleared to &zero by the switch.
    for (size_t i = 0; i < command.dimension.width; i += 8) {
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr0);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr1);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr2);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr3);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr4);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr5);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr6);
        LOAD_DATA_INCREMENT_VARIABLES_GET_PTR(ptr7);
        
        switch (command.dimension.width - i) {
            case 0: assert(0); abort();
            case 1: ptr1 = &zero;
            case 2: ptr2 = &zero;
            case 3: ptr3 = &zero;
            case 4: ptr4 = &zero;
            case 5: ptr5 = &zero;
            case 6: ptr6 = &zero;
            case 7: ptr7 = &zero;
            default: break;
        }
        
        current_chunk[which_array] =_mm256_set_ps(
            *ptr7, *ptr6, *ptr5, *ptr4, *ptr3, *ptr2, *ptr1, *ptr0
        );
        
        current_chunk += command.dimension.combine_count;
    }
}

/*  Follow-up function to load_data to be called if masking is  needed.  The
 *  function  overwrites  only  those positions in the command.output_chunks
 *  array whose data comes  from  pixels  that  were  masked  out.  As  with
 *  load_data,  the  [which_array]  argument  specifies  the offset within a
 *  single chunk of [combine_count] __m256 vectors that corresponds to  data
 *  from this array.
 */
template <typename MaskType>
void mask_data(
    MediocreInputCommand command,
    MediocreMasked2D masked_data,
    size_t which_array,
    bool nonzero_means_bad
) {
    Mediocre2D mask = masked_data.mask_2D;
    check_type_code<MaskType>(mask);
    
    assert(masked_data.data_2D.minor_width == mask.minor_width);
    assert(masked_data.data_2D.major_width == mask.major_width);
    
    size_t major = command.offset / mask.minor_width;
    size_t minor = command.offset % mask.minor_width;
    
    char const* row_pointer = reinterpret_cast<char const*>(mask.data)
        + major*mask.major_stride;
    
    char const* current_pointer = row_pointer + minor*mask.minor_stride;
    
    for (size_t i = 0; i < command.dimension.width; ++i) {
        bool at_row_end = minor+1 >= mask.minor_width;
        
        minor = at_row_end ? 0 : minor+1;
        major += (at_row_end ? 1 : 0);
        row_pointer += (at_row_end ? mask.major_stride : 0);
        current_pointer =
            at_row_end ? row_pointer : current_pointer + mask.minor_stride;
        
        MaskType value = *reinterpret_cast<MaskType const*>(current_pointer);
        if ((value != 0) == nonzero_means_bad) {
            float* value_to_mask = mediocre_chunk_ptr(
                command.output_chunks,
                command.dimension.combine_count,
                which_array,
                i
            );
            
            *value_to_mask = median_filter<MaskType>(
                masked_data, { major, minor }, nonzero_means_bad
            );
        }
    }
}

inline bool array_is_okay(
    Mediocre2D array, size_t major_expected, size_t minor_expected
) {
    switch (array.type_code) {
      default:
        fprintf(stderr, "Unknown type code %zi.\n", array.type_code);
        return false;
        
      case 8:   case 16:  case 32:  case 64:
      case 108: case 116: case 132: case 164:
      case 0xF: case 0xD:
       
        if (array.major_width == major_expected
            && array.minor_width == minor_expected
        ) {
            return true;
        } else {
            fprintf(stderr, "Mediocre2D array sizes don't match.\n"
                "Expected [%zi, %zi], found [%zi, %zi] (major, minor).\n",
                major_expected, minor_expected,
                array.major_width, array.minor_width
            );
            return false;
        }
    }
}

} // end anonymous namespace.

extern "C" {

struct MaskedUserData {
    std::vector<MediocreMasked2D> arrays;
    bool nonzero_means_bad;
};

static int masked_loop_function(
    MediocreInputControl* control,
    void const* user_data_pv,
    MediocreDimension maximum_request
) {
    (void)maximum_request;
    MediocreInputCommand command;
    
    MaskedUserData const* user_data =
        static_cast<MaskedUserData const*>(user_data_pv);
    
    MediocreMasked2D const* masked_2D_arrays = user_data->arrays.data();
    const bool nonzero_means_bad = user_data->nonzero_means_bad;
    
    MEDIOCRE_INPUT_LOOP(command, control) {
        for (size_t i = 0; i < command.dimension.combine_count; ++i) {
            MediocreMasked2D masked_2D = masked_2D_arrays[i];
            Mediocre2D data = masked_2D.data_2D;
            
            switch (data.type_code) {
              default:
                fprintf(stderr, "MediocreMasked2D input loop:\n"
                    "Unknown data type_code %zi (array number [%zi]).\n",
                    data.type_code, i
                );
                return EINVAL;
              break; case 8:
                load_data<int8_t>(command, data, i);
              break; case 16:
                load_data<int16_t>(command, data, i);
              break; case 32:
                load_data<int32_t>(command, data, i);
              break; case 64:
                load_data<int64_t>(command, data, i);
              break; case 108:
                load_data<uint8_t>(command, data, i);
              break; case 116:
                load_data<uint16_t>(command, data, i);
              break; case 132:
                load_data<uint32_t>(command, data, i);
              break; case 164:
                load_data<uint64_t>(command, data, i);
              break; case 0xF:
                load_data<float>(command, data, i);
              break; case 0xD:
                load_data<double>(command, data, i);
            }
            
            switch (masked_2D.mask_2D.type_code) {
              default:
                fprintf(stderr, "MediocreMasked2D input loop:\n"
                    "Unknown mask type_code %zi (array number [%zi]).\n",
                    masked_2D.mask_2D.type_code, i
                );
                return EINVAL;
              break; case 8:
                mask_data<int8_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 16:
                mask_data<int16_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 32:
                mask_data<int32_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 64:
                mask_data<int64_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 108:
                mask_data<uint8_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 116:
                mask_data<uint16_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 132:
                mask_data<uint32_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 164:
                mask_data<uint64_t>(command, masked_2D, i, nonzero_means_bad);
              break; case 0xF:
                mask_data<float>(command, masked_2D, i, nonzero_means_bad);
              break; case 0xD:
                mask_data<double>(command, masked_2D, i, nonzero_means_bad);
            }
        }
    }
    
    return 0;
}

static void masked_user_data_destructor(void* user_data_pv) {
    delete static_cast<MaskedUserData*>(user_data_pv);
}

MediocreInput mediocre_2D_masked_input(
    MediocreMasked2D const* masked_arrays,
    size_t count,
    bool nonzero_means_bad
) {
    MediocreInput result;
    
    result.loop_function = masked_loop_function;
    result.destructor = masked_user_data_destructor;
    result.user_data = nullptr; // Set later.
    result.dimension.combine_count = count;
    result.dimension.width = 0; // Set later.
    result.nonzero_error = 0;
    
    MaskedUserData* masked_user_data = nullptr;
    
    if (count == 0) {
        fprintf(stderr, "mediocre_2D_masked_input:\n"
            "count should not be zero (needs at least one input array).\n"
        );
        result.nonzero_error = EINVAL;
        return result;
    }
    
    size_t major_expected = masked_arrays[0].data_2D.major_width;
    size_t minor_expected = masked_arrays[0].data_2D.minor_width;
    result.dimension.width = major_expected * minor_expected;
    
    for (size_t i = 0; i < count; ++i) {
        MediocreMasked2D const& m = masked_arrays[i];
        if (!array_is_okay(m.data_2D, major_expected, minor_expected)) {
            result.nonzero_error = EINVAL;
            return result;
        }
        if (!array_is_okay(m.mask_2D, major_expected, minor_expected)) {
            result.nonzero_error = EINVAL;
            return result;
        }
    }
    
    try {
        masked_user_data = new MaskedUserData;
        masked_user_data->nonzero_means_bad = nonzero_means_bad;
        masked_user_data->arrays.reserve(count);
        
        for (size_t i = 0; i < count; ++i) {
            masked_user_data->arrays.push_back(masked_arrays[i]);
        }
        result.user_data = masked_user_data;
    } catch (std::bad_alloc&) {
        fprintf(stderr,
            "mediocre_2D_masked_input: Could not allocate memory.\n"
        );
        result.nonzero_error = ENOMEM;
        delete masked_user_data;
        return result;
    } catch (...) {
        fprintf(stderr, "mediocre_2D_masked_input: Unknown error.\n");
        result.nonzero_error = -1;
        delete masked_user_data;
        return result;
    }
    
    return result;
}

} // end extern "C"
        
