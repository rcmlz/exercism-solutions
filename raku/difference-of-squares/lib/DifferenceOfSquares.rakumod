unit module DifferenceOfSquares:ver<1>:auth<exercism:rcmlz>:api<1>;
use experimental :cached;

subset UIntGreaterZero of UInt where * != 0;

proto square-of-sum (UIntGreaterZero \n) is export is cached {*}
proto sum-of-squares (UIntGreaterZero \n) is export is cached {*}
proto difference-of-squares (UIntGreaterZero \n) is export is cached {*}

# Sometimes superscript powers `²` work well for readability.
# `»` is a "SIMD" operation - a hint to the compiler that it can parallelize the call.
# https://docs.raku.org/language/operators#methodop_%C2%BB._/_methodop_%3E%3E.
# Credits: raiph
multi difference-of-squares (\n) {
    sum($_)² - sum($_»²) with 1..n
}

multi difference-of-squares (\n) is default {
    square-of-sum(n) - sum-of-squares(n)
}

multi square-of-sum (\n) is default {
    (n * (n + 1) / 2)²
}

multi square-of-sum (\n) {
    sum(1..n)²
}

multi sum-of-squares (\n) is default {
    (n * (n + 1) * (2 * n + 1)) / 6
}

multi sum-of-squares (\n) {
    sum (1..n)»²
}

# vectorized multiplication »×«, hyper operator direction » « indicating that LHS and RHS must have same number of elements
# https://docs.raku.org/language/operators#Hyper_operators
multi sum-of-squares (\n) {
    sum $_ »×« $_ with 1..n
}