#ifndef MEDIOCRE_MAYBE_FMA_H_
#define MEDIOCRE_MAYBE_FMA_H_

#ifndef MEDIOCRE_ENABLE_FMA
#define MEDIOCRE_ENABLE_FMA 1
#endif

#include <immintrin.h>

#if MEDIOCRE_ENABLE_FMA

static double fp64_madd(double a, double b, double c)
{
    __m128d tmp = _mm_fmadd_sd(_mm_set_sd(a), _mm_set_sd(b), _mm_set_sd(c));
    return _mm_cvtsd_f64(tmp);
}

static inline __m256d m256d_madd(__m256d a, __m256d b, __m256d c)
{
    return _mm256_fmadd_pd(a, b, c);
}

static inline __m256d m256d_nmadd(__m256d a, __m256d b, __m256d c)
{
    return _mm256_fnmadd_pd(a, b, c);
}

#else

static inline double fp64_madd(double a, double b, double c)
{
    return a * b + c;
}

static inline __m256d m256d_madd(__m256d a, __m256d b, __m256d c)
{
    return _mm256_add_pd(_mm256_mul_pd(a, b), c);
}

static inline __m256d m256d_nmadd(__m256d a, __m256d b, __m256d c)
{
    return _mm256_sub_pd(c, _mm256_mul_pd(a, b));
}

#endif

#endif
