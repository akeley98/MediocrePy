from __future__ import annotations
import os
from exo import *
from exo.stdlib.scheduling import *
from exo.platforms.x86 import *
from exo.stdlib.stdlib import vectorize
from exo.memory import Memory, MemGenError
from exo.extern import Extern
from exo.libs.externs import sin, fmaxf


try:
    from exo.libs.externs import fminf, sqrt
except ImportError:
    class _FminF(Extern):
        def __init__(self):
            super().__init__("fminf")

        def typecheck(self, args):
            if len(args) != 2:
                raise _EErr(f"expected 2 argument, got {len(args)}")

            atyp = args[0].type
            if not atyp.is_real_scalar():
                raise _EErr(
                    f"expected argument 2 to be a real scalar value, but "
                    f"got type {atyp}"
                )
            return atyp

        def globl(self, prim_type):
            return "#include <math.h>"

        def interpret(self, args):
            return math.fminf(args[0], args[1])

        def compile(self, args, prim_type):
            return f"fminf(({prim_type})({args[0]}), ({prim_type})({args[1]}))"

    fminf = _FminF()


    class _Sqrt(Extern):
        def __init__(self):
            super().__init__("sqrt")

        def typecheck(self, args):
            if len(args) != 1:
                raise _EErr(f"expected 1 argument, got {len(args)}")

            atyp = args[0].type
            if not atyp.is_real_scalar():
                raise _EErr(
                    f"expected argument 1 to be a real scalar value, but "
                    f"got type {atyp}"
                )
            return atyp

        def globl(self, prim_type):
            return "#include <math.h>"

        def interpret(self, args):
            return math.sqrt(args[0])

        def compile(self, args, prim_type):
            return f"sqrt(({prim_type})({args[0]}))"


    sqrt = _Sqrt()


class MYAVX512D(Memory):
    @classmethod
    def global_(cls):
        return "#include <immintrin.h>"

    @classmethod
    def can_read(cls):
        return False

    @classmethod
    def alloc(cls, new_name, prim_type, shape, srcinfo):
        if not shape:
            raise MemGenError(f"{srcinfo}: AVX512 vectors are not scalar values")
        if not prim_type == "double":
            raise MemGenError(f"{srcinfo}: AVX512F64 vectors must be f64")
        if not shape[-1].isdecimal() or int(shape[-1]) != 8:
            raise MemGenError(f"{srcinfo}: AVX512F64 vectors must be 8-wide")
        shape = shape[:-1]
        if shape:
            result = f'__m512d {new_name}[{"][".join(map(str, shape))}];'
        else:
            result = f"__m512d {new_name};"
        return result

    @classmethod
    def free(cls, new_name, prim_type, shape, srcinfo):
        return ""

    @classmethod
    def window(cls, basetyp, baseptr, indices, strides, srcinfo):
        assert strides[-1] == "1"
        idxs = indices[:-1] or ""
        if idxs:
            idxs = "[" + "][".join(idxs) + "]"
        return f"{baseptr}{idxs}"

@instr("{out_data} = _mm256_add_ps({out_data}, {y_data});")
def MY256_iadd_ps(out: [f32][8] @ AVX2, y: [f32][8] @ AVX2):
    assert stride(out, 0) == 1
    assert stride(y, 0) == 1

    for i in seq(0, 8):
        out[i] += y[i]

@instr("{out_data} = _mm256_min_ps({out_data}, {y_data});")
def MY256_imin_ps(out: [f32][8] @ AVX2, y: [f32][8] @ AVX2):
    assert stride(out, 0) == 1
    assert stride(y, 0) == 1

    for i in seq(0, 8):
        out[i] = fminf(out[i], y[i])

@instr("{out_data} = _mm256_max_ps({out_data}, {y_data});")
def MY256_imax_ps(out: [f32][8] @ AVX2, y: [f32][8] @ AVX2):
    assert stride(out, 0) == 1
    assert stride(y, 0) == 1

    for i in seq(0, 8):
        out[i] = fmaxf(out[i], y[i])

@instr("{dst_data} = _mm256_set1_ps({src_data});")
def MY256_set1_ps(
    dst: [f32][16] @ AVX512,
    src: [f32][1],
):
    assert stride(dst, 0) == 1

    for i in seq(0, 8):
        dst[i] = src[0]


### XXX RISKY WORKAROUND: this seems to match and replace patterns even where the z's don't match (fixed in yam branch?)
@instr(
    """{z_data} = _mm256_blendv_ps ({z_data}, {y_data}, _mm256_cmp_ps ({x_data}, {v_data}, _CMP_LT_OQ));"""
)
def MY256_select4_ps(
    x: [f32][8] @ AVX2,
    v: [f32][8] @ AVX2,
    y: [f32][8] @ AVX2,
    z: [f32][8] @ AVX2,
):
    # WARNING: This instruction above use a lower precision
    #    float32 (C float) than the implementation of
    #    the builtin which uses float64 (C double)
    assert stride(x, 0) == 1
    assert stride(v, 0) == 1
    assert stride(y, 0) == 1
    assert stride(z, 0) == 1

    for i in seq(0, 8):
        z[i] = select(x[i], v[i], y[i], z[i])

@instr(
    """{dst_data} = _mm512_setzero_pd();""")
def MY512_setzero_pd(dst: [f64][8] @ MYAVX512D):
    assert stride(dst, 0) == 1
    for i in seq(0, 8):
        dst[i] = 0.0

@instr(
    """{dst_data} = _mm512_fmadd_pd({src_data}, {src_data}, {dst_data});""")
def MY512_fmadd_square_pd(dst: [f64][8] @ MYAVX512D, src: [f64][8] @ MYAVX512D):
    assert stride(dst, 0) == 1
    assert stride(src, 0) == 1
    for i in seq(0, 8):
        dst[i] += src[i] * src[i]

@instr(
    """{dst_data} = _mm512_cvtps_pd({src_data});""")
def MY512_cvtps_pd(dst: [f64][8] @ MYAVX512D, src: [f32][8] @ AVX2):
    assert stride(dst, 0) == 1
    assert stride(src, 0) == 1
    for i in seq(0, 8):
        dst[i] = src[i]

@instr(
    """{dst_data} = _mm512_cvtpd_ps({src_data});""")
def MY512_cvtpd_ps(dst: [f32][8] @ AVX2, src: [f64][8] @ MYAVX512D):
    assert stride(dst, 0) == 1
    assert stride(src, 0) == 1
    for i in seq(0, 8):
        dst[i] = src[i]


@instr("{out_data} = _mm512_div_pd({x_data}, {y_data});")
def MY512_div_pd(out: [f64][8] @ MYAVX512D, x: [f64][8] @ MYAVX512D, y: [f64][8] @ MYAVX512D):
    assert stride(out, 0) == 1
    assert stride(x, 0) == 1
    assert stride(y, 0) == 1

    for i in seq(0, 8):
        out[i] = x[i] / y[i]

@instr("{out_data} = _mm512_sqrt_pd({x_data});")
def MY512_sqrt_pd(out: [f64][8] @ MYAVX512D, x: [f64][8] @ MYAVX512D):
    assert stride(out, 0) == 1
    assert stride(x, 0) == 1

    for i in seq(0, 8):
        out[i] = sqrt(x[i])

@instr("{dst_data} = _mm512_fmadd_pd(_mm512_set1_pd({src_scalar_data}), {src_vector_data}, {dst_data});")
def MY512_fmadd_scalar_vector_pd(
    dst: [f64][8] @ MYAVX512D,
    src_scalar: [f64][1] @ DRAM,
    src_vector: [f64][8] @ MYAVX512D,
):
    assert stride(src_vector, 0) == 1
    assert stride(dst, 0) == 1

    for i in seq(0, 8):
        dst[i] += src_scalar[0] * src_vector[i]

@instr("{dst_data} = _mm512_fnmadd_pd(_mm512_set1_pd({src_scalar_data}), {src_vector_data}, {dst_data});")
def MY512_fnmadd_scalar_vector_pd(
    dst: [f64][8] @ MYAVX512D,
    src_scalar: [f64][1] @ DRAM,
    src_vector: [f64][8] @ MYAVX512D,
):
    assert stride(src_vector, 0) == 1
    assert stride(dst, 0) == 1

    for i in seq(0, 8):
        dst[i] += -src_scalar[0] * src_vector[i]


my_avx_insts = [
    avx2_reg_copy_ps,
    mm256_broadcast_ss,
    mm256_setzero_ps,
    MY256_iadd_ps,
    mm256_add_ps,
    mm256_sub_ps,
    mm256_div_ps,
    mm256_loadu_ps,
    mm256_storeu_ps,
    MY256_set1_ps,
    MY256_select4_ps,
    MY512_setzero_pd,
    MY512_fmadd_square_pd,
    MY512_cvtps_pd,
    MY512_cvtpd_ps,
    MY512_div_pd,
    MY512_sqrt_pd,
    MY512_fmadd_scalar_vector_pd,
    MY512_fnmadd_scalar_vector_pd,
    MY256_imin_ps,
    MY256_imax_ps,
]


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


if True:
    orig = exo_mean_chunk_lane_outer_loop_m256
    avx = rename(exo_mean_chunk_lane_outer_loop_m256, "exo_mean_chunk_m256")
    avx = reorder_loops(avx, "lane c")
    avx = lift_alloc(avx, "accum")
    avx = lift_alloc(avx, "tmp")
    avx = lift_alloc(avx, "divisor")
    avx = fission(avx, orig.find("accum[_] = _").after())
    avx = fission(avx, orig.find("for i in _:_").after())
    avx = fission(avx, orig.find("divisor[lane] = _").after())
    avx = fission(avx, orig.find("tmp[lane] = _ #1").after())
    avx = reorder_loops(avx, "lane i")
    avx = fission(avx, orig.find("tmp[lane] = _").after())
    avx = set_memory(avx, "accum", AVX2)
    avx = set_memory(avx, "tmp", AVX2)
    avx = set_memory(avx, "divisor", AVX2)
    for inst in my_avx_insts:
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
def exo_clipped_mean_chunk_original(
        combine_count : size,
        chunk_count : size,
        out : f32[chunk_count, 8] @ DRAM,
        in2D : f32[chunk_count, combine_count, 8],
        sigma_lower : f64[1],
        sigma_upper : f64[1],
        max_iter : size):

    lower_bounds : f32[8]
    upper_bounds : f32[8]
    zero : f32[8]
    value : f32[8]
    accum : f32[8]
    count : f32[8]
    tmp : f32[8]
    mean : f32[8]

    tmp_scalar : f32[1]

    sum_squares : f64[8]
    stdev : f64[8]
    tmp64 : f64[8]

    for c in seq(0, chunk_count):
        for lane in seq(0, 8):
            zero[lane] = 0
        tmp_scalar[0] = -1e100
        for lane in seq(0, 8):
            lower_bounds[lane] = tmp_scalar[0]
        tmp_scalar[0] = 1e100
        for lane in seq(0, 8):
            upper_bounds[lane] = tmp_scalar[0]

        # Sigma clipping loop
        for sigma_iter in seq(0, max_iter):
                # Calculate the mean, masking away out-of-bounds values
                # tmp = in_bounds ? 1.0 : 0.0
            for lane in seq(0, 8):
                accum[lane] = 0
            for lane in seq(0, 8):
                count[lane] = 0
            for i in seq(0, combine_count):
                for lane in seq(0, 8):
                    value[lane] = in2D[c, i, lane]
                tmp_scalar[0] = 1.0
                for lane in seq(0, 8):
                    tmp[lane] = tmp_scalar[0]
                for lane in seq(0, 8):
                    tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    count[lane] += tmp[lane]
                for lane in seq(0, 8):
                    tmp[lane] = value[lane]
                for lane in seq(0, 8):
                    tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    accum[lane] += tmp[lane]

            for lane in seq(0, 8):
                mean[lane] = accum[lane] / count[lane]

                # Calculate the sum of squared deviation, including only numbers in bound
                # tmp = in_bounds ? square(value - mean) : 0.0
            for lane in seq(0, 8):
                sum_squares[lane] = 0
            for i in seq(0, combine_count):
                for lane in seq(0, 8):
                    value[lane] = in2D[c, i, lane]
                for lane in seq(0, 8):
                    tmp[lane] = value[lane] - mean[lane]
                for lane in seq(0, 8):
                    tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
                for lane in seq(0, 8):
                    tmp64[lane] = tmp[lane]
                for lane in seq(0, 8):
                    sum_squares[lane] += tmp64[lane] * tmp64[lane]
            for lane in seq(0, 8):
                stdev[lane] = count[lane]
            for lane in seq(0, 8):
                tmp64[lane] = sum_squares[lane] / stdev[lane]
            for lane in seq(0, 8):
                stdev[lane] = sqrt(tmp64[lane])
                #stdev[lane] = sqrt(sum_squares[lane] / tmp64[lane])

                # Set the new lower/upper bounds, but must be at least as strict as old bounds
            for lane in seq(0, 8):
                tmp64[lane] = mean[lane]
            for lane in seq(0, 8):
                tmp64[lane] += -sigma_lower[0] * stdev[lane]
            for lane in seq(0, 8):
                tmp[lane] = tmp64[lane]
            for lane in seq(0, 8):
                lower_bounds[lane] = fmaxf(lower_bounds[lane], tmp[lane])
            for lane in seq(0, 8):
                tmp64[lane] = mean[lane]
            for lane in seq(0, 8):
                tmp64[lane] += sigma_upper[0] * stdev[lane]
            for lane in seq(0, 8):
                tmp[lane] = tmp64[lane]
            for lane in seq(0, 8):
                upper_bounds[lane] = fminf(upper_bounds[lane], tmp[lane])

        # Compute and write out the clipped mean based on the final mask bounds
        for lane in seq(0, 8):
            accum[lane] = 0
        for lane in seq(0, 8):
            count[lane] = 0
        for i in seq(0, combine_count):
            for lane in seq(0, 8):
                value[lane] = in2D[c, i, lane]
            tmp_scalar[0] = 1.0
            for lane in seq(0, 8):
                tmp[lane] = tmp_scalar[0]
            for lane in seq(0, 8):
                tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
            for lane in seq(0, 8):
                tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
            for lane in seq(0, 8):
                count[lane] += tmp[lane]
            for lane in seq(0, 8):
                tmp[lane] = value[lane]
            for lane in seq(0, 8):
                tmp[lane] = select(value[lane], lower_bounds[lane], zero[lane], tmp[lane])
            for lane in seq(0, 8):
                tmp[lane] = select(upper_bounds[lane], value[lane], zero[lane], tmp[lane])
            for lane in seq(0, 8):
                accum[lane] += tmp[lane]
        for lane in seq(0, 8):
            mean[lane] = accum[lane] / count[lane]
        for lane in seq(0, 8):
            out[c, lane] = mean[lane]

avx = rename(exo_clipped_mean_chunk_original, "exo_clipped_mean_chunk_m256")
for var in ("lower_bounds", "upper_bounds", "zero", "value", "accum", "count", "tmp", "mean"):
    avx = set_memory(avx, var, AVX2)
for var in ("sum_squares", "stdev", "tmp64"):
    avx = set_memory(avx, var, MYAVX512D)
for inst in my_avx_insts:
    avx = replace_all(avx, inst)
# exo_clipped_mean_chunk_m256 = avx
