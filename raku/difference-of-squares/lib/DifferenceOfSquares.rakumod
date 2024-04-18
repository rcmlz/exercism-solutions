unit module DifferenceOfSquares:ver<1>:auth<exercism:rcmlz>:api<1>;;
use experimental :cached;

subset UIntGreaterZero of UInt where * != 0;

sub square-of-sum (UIntGreaterZero $number) is export is cached {
    ($number * ($number + 1) / 2)²
}

sub sum-of-squares (UIntGreaterZero $number) is export is cached {
    sum (1..$number) »×« (1..$number)
}

sub difference-of-squares (UIntGreaterZero $number) is export is cached {
    square-of-sum($number) - sum-of-squares($number)
}
