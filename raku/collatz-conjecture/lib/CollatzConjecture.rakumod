unit module CollatzConjecture;

subset PositiveInteger of UInt where * != 0;
sub collatz-conjecture (PositiveInteger $number, UInt $count=0, --> UInt) is export {
    return $count if $number == 1;
    samewith($number.lsb.so
                ?? $number +> 1
                !! 3 * $number + 1,
             $count.succ)
}