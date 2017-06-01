/*  An aggresively average SIMD python module
 *  Utility functions for sigma clipping. Hide ugly code here.
 *  HEADER FILE FOR INTERNAL USE ONLY
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

#ifndef MediocrePy_INLINE_SIGMAUTIL_H_
#define MediocrePy_INLINE_SIGMAUTIL_H_

#include <immintrin.h>

/*  Structure representing eight lower  and  upper  bounds  used  for  sigma
 *  clipping.  Each  of  the  eight  lanes  represents  the bounds for eight
 *  independent positions of the arrays being sigma clipped.
 */
struct ClipBoundsM256 { __m256 lower, upper; };

/*  Return a mask representing whether each float arg[i] (lane i of arg)  is
 *  in  the  clipping  range  represented  by the corresponding lanes of the
 *  vectors in the clipping bounds  (inclusive).  mask[i]  is  all  zero  if
 *  arg[i] was in-range, all ones if it was out of range.
 */
static inline __m256 sigma_mask(__m256 arg, struct ClipBoundsM256 bounds) {
    __m256 const lower_mask = _mm256_cmp_ps(arg, bounds.lower, _CMP_LT_OQ);
    __m256 const upper_mask = _mm256_cmp_ps(arg, bounds.upper, _CMP_GT_OQ);
    // If either bit is 1, it's out-of-range and we should return 1.
    return _mm256_or_ps(lower_mask, upper_mask);
}

/*  Given some data, current clipping bounds calculated by  sigma  clipping,
 *  and  some  parameters,  calculate the new clipping bounds that should be
 *  used  for  the  next  round  of  sigma  clipping.  This  is   calculated
 *  independently for each of the eight lanes of the vectors in the data and
 *  the vectors in the clipping bounds. Each lane of vector_count floats  in
 *  the  data vector array represent a group of numbers to be sigma clipped,
 *  and each lane of the vectors in the result represent  the  new  clipping
 *  bounds of the corresponding group of numbers in the input.
 *  
 *      ** data
 *    array of 8 groups of vector_count floats to be clipped (1 lane per group)
 *      ** vector_count
 *    size of the groups to be clipped, including those out of the bounds
 *      ** bounds
 *  clipping bounds used in the  previous  iteration.  Only  numbers  within
 *  these  bounds  (inclusive)  are  considered  in calculating the standard
 *  deviation and new clipping bounds.
 *      ** center
 *    center used for calculating the new bounds
 *      ** clipped_count
 *  count of numbers in each lane that are within the range defined  by  the
 *  bounds parameter. Although this function could internally determine this
 *  vector, the caller is responsible for calculating this vector  to  speed
 *  up the function.
 *      ** sigma_lower
 *    vector of 4 identical positive doubles
 *      ** sigma_upper
 *    vector of 4 identical positive doubles
 *  
 *  The new clipping range is defined as [center - sigma_lower * s, center +
 *  sigma_upper  *  s],  where  sd  is  calculated as the standard deviation
 *  treating center as the mean of the data (which it doesn't have  to  be).
 *  However,  if  the  new clipping bounds are not entirely contained within
 *  the old clipping bounds (i.e., the new lower bound  is  lower  than  the
 *  previous lower bound or the new upper bound is higher than the new upper
 *  bound), then the new bounds will be  adjusted  to  fit  within  the  old
 *  bounds (using min and max).
 */
static inline struct ClipBoundsM256 get_new_clip_bounds(
    __m256 const* data,
    size_t vector_count,
    struct ClipBoundsM256 bounds,
    __m256 center,
    __m256 clipped_count,
    __m256d sigma_lower,
    __m256d sigma_upper
) {
    // To calculate the standard deviation, we need to first get the
    // sum of the squared deviations. We will do this in double rather
    // than single precision since we will be adding up a lot of
    // large numbers, and we want to minimize rounding error.
    // (Trust me, this was in single precision before I rewrote
    // it using double precision; float wasn't good enough -_-).
    // TODO consider whether Kahan summation w/ single precision
    // might be faster and/or more precise than naive double summation.
    const __m256 zero = _mm256_setzero_ps();
    __m256d lo_ss = _mm256_setzero_pd();
    __m256d hi_ss = _mm256_setzero_pd();
    __m256d const lo_clipped_count = _mm256_cvtps_pd(
        _mm256_castps256_ps128(clipped_count)
    );
    __m256d const hi_clipped_count = _mm256_cvtps_pd(
        _mm256_extractf128_ps(clipped_count, 1)
    );
    __m256d const lo_center = _mm256_cvtps_pd(
        _mm256_castps256_ps128(center)
    );
    __m256d const hi_center = _mm256_cvtps_pd(
        _mm256_extractf128_ps(center, 1)
    );
    for (size_t i = 0; i < vector_count; ++i) {
        // I think that recalculating the mask is faster than storing
        // and reloading it from memory. Memory is slooooow.
        __m256 const vec = data[i];
        __m256 const mask = sigma_mask(vec, bounds);
        
        __m256 const diffs = _mm256_blendv_ps(
            _mm256_sub_ps(vec, center), zero, mask
        );
        __m256d const lo_diffs = _mm256_cvtps_pd(
            _mm256_castps256_ps128(diffs)
        );
        __m256d const hi_diffs = _mm256_cvtps_pd(
            _mm256_extractf128_ps(diffs, 1)
        );
        __m256d lo_sq = _mm256_mul_pd(lo_diffs, lo_diffs);
        __m256d hi_sq = _mm256_mul_pd(hi_diffs, hi_diffs);
        
        hi_ss = _mm256_add_pd(hi_ss, hi_sq);
        lo_ss = _mm256_add_pd(lo_ss, lo_sq);
    }
    // Now we have the sum of the squared deviations and we can
    // use it to get the standard deviation. Use this to calculate
    // the lower and upper clip bounds for the next iteration.
    // (Yes, I know about FMA, but not all processors do ;_; )
    __m256d const lo_avg_ss = _mm256_div_pd(lo_ss, lo_clipped_count);
    __m256d const hi_avg_ss = _mm256_div_pd(hi_ss, hi_clipped_count);
    __m256d const lo_sd = _mm256_sqrt_pd(lo_avg_ss);
    __m256d const hi_sd = _mm256_sqrt_pd(hi_avg_ss);

    __m256 const new_lower_bound = _mm256_setr_m128(
        _mm256_cvtpd_ps(
            _mm256_sub_pd(lo_center, _mm256_mul_pd(lo_sd, sigma_lower))
        ),
        _mm256_cvtpd_ps(
            _mm256_sub_pd(hi_center, _mm256_mul_pd(hi_sd, sigma_lower))
        )
    );
    __m256 const new_upper_bound = _mm256_setr_m128(
        _mm256_cvtpd_ps(
            _mm256_add_pd(lo_center, _mm256_mul_pd(lo_sd, sigma_upper))
        ),
        _mm256_cvtpd_ps(
            _mm256_add_pd(hi_center, _mm256_mul_pd(hi_sd, sigma_upper))
        )
    );
    bounds.lower = _mm256_max_ps(bounds.lower, new_lower_bound);
    bounds.upper = _mm256_min_ps(bounds.upper, new_upper_bound);
    return bounds;
}
#endif

