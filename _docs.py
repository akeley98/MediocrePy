cmean2 = """\
Factory function that returns a Functor object that combines arrays
using the sigma clipped mean algorithm. The algorithm produces each
entry of the output array by taking a 'column' of data consisting
of the corresponding (same index) entries of the input arrays,
performing max_iter iterations of sigma clipping to remove outliers,
and taking the mean of the remaining numbers in the column. In each
iteration of sigma clipping, the mean and standard deviation (SD) of
the remaining numbers in the column is calculated, and all numbers
less than mean - sigma_lower*SD or greater than sigma_upper*SD are
removed from the column as outliers (clipped out).

The clipped_mean function is an instance of such a Functor with the
default sigma and max_iter parameters.

The mean function is an instance of such a Functor with sigma
clipping disabled.
"""

cmean = """\
See ClippedMean2. This function is used for returning clipped mean
functors in the common case where sigma_lower = sigma_upper (=sigma).
"""

cmedi2 = """\
Factory function that returns a Functor object that combines arrays
using the clipped median algorithm. Such functors combine columns of
data in a similar manner as the clipped mean algorithm.
        (see ClippedMean2)
However, rather than taking the mean of the numbers not clipped in a
column, this functor takes the median, and the bounds used in sigma
clipping are [median-sigma_lower*SD', median+sigma_upper*SD'] instead
of [mean-sigma_lower*SD, mean+sigma_upper*SD], where SD' is the standard
deviation calculated using the median in place of the mean.

The clipped_median function is an instance of such a Functor with the
default sigma and max_iter parameters.

The median function is an instance of such a functor with sigma
clipping disabled.

Note that the median functors can combine no more than a million
(1000000) arrays into a single output.
"""

cmedi = """\
See ClippedMedian2. This function is used for returning clipped median
functors in the common case where sigma_lower = sigma_upper (=sigma).
"""

smean = """\
Combine 1D/2D numpy arrays using the scaled mean algorithm.

The scaled mean algorithm is implemented as an ordinary function rather
than a reusable Functor object.

The scaled mean is an adaptation of the clipped mean algorithm
(see ClippedMean2). The scaled mean was designed with the use case of
combining many astronomical photographs with different exposure times.
As in the clipped mean algorithm, we want to compare these photographs
for outliers; to do so we first scale the images (arrays) so that
their brightnesses are similar (done by dividing the entries of each
array by that array's scale factor), and then clipping out numbers from
each column based on the mean and standard deviation of those scaled
quantities. Then, each entry of the output array is set to the weighted
mean of the remaining scaled quantities in the entry's corresponding
column of data (rather than just the mean as in the clipped mean
function), with the scale factor used to get each quantity as its
weight. This is done because data from photographs with longer exposure
times are generally more reliable than data from photographs with short
exposure times.

scale_factors: sequence of float-like objects. scale_factors[I] is the
scale factor for arrays[I]. len(scale_factors) must equal len(arrays).

arrays, masks, nonzero_means_bad, thread_count:
    as in the Functor call operator

sigma, sigma_lower, sigma_upper, max_iter:
    as in ClippedMean and ClippedMean2
    sigma_lower, sigma_upper: float-like
    sigma: float-like, default value for sigma_lower, sigma_upper
    max_iter: integer-like
"""

