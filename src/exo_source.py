from __future__ import annotations
import os
from exo import *
from exo.stdlib.scheduling import *

@proc
def exo_mean_chunk_m256(
        combine_count : size,
        combine_count_f32 : f32,
        chunk_count : size,
        out : f32[chunk_count, 8] @ DRAM,
        in2D : f32[chunk_count, combine_count, 8]):
    for c in seq(0, chunk_count):
        tmp : f32[8]
        for lane in seq(0, 8):
            tmp[lane] = 0
        for i in seq(0, combine_count):
            for lane in seq(0, 8):
                tmp[lane] += in2D[c, i, lane]
        for lane in seq(0, 8):
            out[c, lane] = tmp[lane] / combine_count_f32

@proc
def sin_8(out : f32[8] @ DRAM, in_ : f32[8] @ DRAM):
    for lane in seq(0, 8):
        out[lane] = sin(in_[lane])

@proc
def exo_clipped_mean_chunk_m256(
        combine_count : size,
        chunk_count : size,
        out : f32[chunk_count, 8] @ DRAM,
        in2D : f32[chunk_count, combine_count, 8],
        sigma_lower : f64,
        sigma_upper : f64,
        max_iter : size):

    lower_bounds : f32[8]
    upper_bounds : f32[8]
    zero : f32[8]
    value : f32[8]
    accum : f32[8]
    count : f32[8]
    tmp : f32[8]
    mean : f32[8]

    sum_squares : f64[8]
    stdev : f64[8]
    tmp64 : f64[8]

    for lane in seq(0, 8):
        zero[lane] = 0

        for c in seq(0, chunk_count):
            lower_bounds[lane] = -1e100
            upper_bounds[lane] = 1e100

            for sigma_iter in seq(0, max_iter):
                # Calculate the mean, masking away out-of-bounds values
                # tmp = in_bounds ? 1.0 : 0.0
                accum[lane] = 0
                count[lane] = 0
                for i in seq(0, combine_count):
                    value[lane] = in2D[c, i, lane]
                    tmp[lane] = 1.0
                    tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                    tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                    count[lane] += tmp[lane]
                    value[lane] = select(value[lane], lower_bounds[lane], zero[lane], value[lane])
                    value[lane] = select(upper_bounds[lane], value[lane], zero[lane], value[lane])
                    accum[lane] += value[lane]

                mean[lane] = accum[lane] / count[lane]

                # Calculate the sum of squared deviation, including only numbers in bound
                # tmp = in_bounds ? square(value - mean) : 0.0
                sum_squares[lane] = 0
                for i in seq(0, combine_count):
                    value[lane] = in2D[c, i, lane]
                    tmp[lane] = value[lane] - mean[lane]
                    tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                    tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                    sum_squares[lane] += tmp[lane] * tmp[lane]
                tmp64[lane] = count[lane]
                tmp64[lane] = sum_squares[lane] / tmp64[lane]
                stdev[lane] = sqrt(tmp64[lane])
                #stdev[lane] = sqrt(sum_squares[lane] / tmp64[lane])

                # Set the new lower/upper bounds
                tmp64[lane] = mean[lane]
                lower_bounds[lane] = tmp64[lane] - sigma_lower * stdev[lane]
                upper_bounds[lane] = tmp64[lane] + sigma_upper * stdev[lane]

            # Compute and write out the clipped mean based on the final mask bounds
            accum[lane] = 0
            count[lane] = 0
            for i in seq(0, combine_count):
                value[lane] = in2D[c, i, lane]
                tmp[lane] = 1.0
                tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                count[lane] += tmp[lane]
                value[lane] = select(value[lane], lower_bounds[lane], zero[lane], value[lane])
                value[lane] = select(upper_bounds[lane], value[lane], zero[lane], value[lane])
                accum[lane] += value[lane]

            mean[lane] = accum[lane] / count[lane]
            out[c, lane] = mean[lane]
        # end loop for c in seq(0, chunk_count)
    # end loop for lane in seq(0, ...)
