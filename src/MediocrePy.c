/*  An aggresively average SIMD python module
 *  Functions directly called through ctypes for the Python module.
 *  There is no corresponding header file for this C file.
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

#include <errno.h>
#include <stdio.h>

#include "loaderfunction.h"
#include "mean.h"
#include "median.h"
#include "strideloader.h"

/*  Combine the input arrays using the clipped mean algorithm.  array_length
 *  is  the  count  of  the  number  of items in each input array; it is not
 *  directly related to the strides of the  arrays.  Returns  errno  if  the
 *  function failed, 0 if the function succeeded.
 */
int MediocrePy_clipped_mean(
    float* output,
    struct MediocreStride2Array const* arrays,
    size_t array_count,
    size_t array_length,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    struct MediocreInputData input = {arrays, array_count, array_length, NULL};
    
    int not_okay = mediocre_clipped_mean(
        output,
        0xF,
        input,
        MediocreStride2Array_loader,
        sigma_lower,
        sigma_upper,
        max_iter
    );
    
    if (not_okay) {
        if (errno == 0) {
            fprintf(stderr, "MediocrePy: function failed but errno not set.\n");
            return -1;
        } else {
            return errno;
        }
    }
    return 0;
}

/*  Combine  the  input  arrays  using   the   clipped   median   algorithm.
 *  array_length is the count of the number of items in each input array; it
 *  is not directly related to the strides of the arrays. Returns  errno  if
 *  the function failed, 0 if the function succeeded.
 */
int MediocrePy_clipped_median(
    float* output,
    struct MediocreStride2Array const* arrays,
    size_t array_count,
    size_t array_length,
    double sigma_lower,
    double sigma_upper,
    size_t max_iter
) {
    struct MediocreInputData input = {arrays, array_count, array_length, NULL};
    
    int not_okay = mediocre_clipped_median(
        output,
        0xF,
        input,
        MediocreStride2Array_loader,
        sigma_lower,
        sigma_upper,
        max_iter
    );
    
    if (not_okay) {
        if (errno == 0) {
            fprintf(stderr, "MediocrePy: function failed but errno not set.\n");
            return -1;
        } else {
            return errno;
        }
    }
    return 0;
}

