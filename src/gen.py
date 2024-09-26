from __future__ import annotations
import os
from exo import *
from exo.stdlib.scheduling import *
from exo.platforms.x86 import *
from exo.stdlib.stdlib import vectorize

@instr("{out_data} = _mm256_add_ps({out_data}, {y_data});")
def MY256_iadd_ps(out: [f32][8] @ AVX2, y: [f32][8] @ AVX2):
    assert stride(out, 0) == 1
    assert stride(y, 0) == 1

    for i in seq(0, 8):
        out[i] += y[i]

@proc
def exo_mean_chunk_lane_outer_loop_m256(
        combine_count : size,
        combine_count_f32 : f32[1],
        chunk_count : size,
        out : f32[chunk_count, 8] @ DRAM,
        in2D : f32[chunk_count, combine_count, 8]):
    for lane in seq(0, 8):
        for c in seq(0, chunk_count):
            accum : f32[8]
            tmp : f32[8]
            divisor : f32[8]
            accum[lane] = 0
            for i in seq(0, combine_count):
                tmp[lane] = in2D[c, i, lane]
                accum[lane] += tmp[lane]
            divisor[lane] = combine_count_f32[0]
            tmp[lane] = accum[lane] / divisor[lane]
            out[c, lane] = tmp[lane]

@proc
def exo_mean_chunk_better_m256(
        combine_count : size,
        combine_count_f32 : f32[1],
        chunk_count : size,
        out : f32[chunk_count, 8] @ DRAM,
        in2D : f32[chunk_count, combine_count, 8]):
    for lane in seq(0, 8):
        for c in seq(0, chunk_count):
            accum : f32
            divisor : f32
            accum = 0
            for i in seq(0, combine_count):
                accum += in2D[c, i, lane]
            divisor = combine_count_f32[0]
            out[c, lane] = accum / divisor


avx_f32_insts = [
    mm256_broadcast_ss,
    mm256_setzero_ps,
    mm256_add_ps,
    MY256_iadd_ps,
    mm256_div_ps,
    mm256_loadu_ps,
    mm256_storeu_ps,
]

if True:
    avx = rename(exo_mean_chunk_lane_outer_loop_m256, "exo_mean_chunk_m256")
    avx = reorder_loops(avx, "lane c")
    avx = lift_alloc(avx, "accum")
    avx = lift_alloc(avx, "tmp")
    avx = lift_alloc(avx, "divisor")
    avx = fission(avx, avx.find("accum[_] = _").after())
    avx = fission(avx, avx.find("for i in _:_").after())
    avx = fission(avx, avx.find("divisor[lane] = _").after())
    avx = fission(avx, avx.find("tmp[lane] = _ #1").after())
    avx = reorder_loops(avx, "lane i")
    avx = fission(avx, avx.find("tmp[lane] = _").after())
    avx = set_memory(avx, "accum", AVX2)
    avx = set_memory(avx, "tmp", AVX2)
    avx = set_memory(avx, "divisor", AVX2)
    for inst in avx_f32_insts:
        avx = replace_all(avx, inst)
    exo_mean_chunk_m256 = avx
else:
    avx = rename(exo_mean_chunk_lane_outer_loop_m256, "exo_mean_chunk_m256")
    avx = reorder_loops(avx, "lane c")
    avx = lift_alloc(avx, "accum")
    avx = lift_alloc(avx, "tmp")
    avx = lift_alloc(avx, "divisor")

@proc
def sin_8(out : f32[8] @ DRAM, in_ : f32[8] @ DRAM):
    for lane in seq(0, 8):
        out[lane] = sin(in_[lane])

@proc
def exo_clipped_mean_chunk_original_m256(
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
        for c in seq(0, chunk_count):
            zero[lane] = 0
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

avx = rename(exo_clipped_mean_chunk_original_m256, "exo_clipped_mean_chunk_m256")
avx = reorder_loops(avx, "lane c")
#avx = repeat(reorder_loops)(avx, "c lane")
exo_clipped_mean_chunk_m256 = avx
