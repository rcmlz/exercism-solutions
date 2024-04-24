unit module Hamming;

sub hamming-distance(Str:D $s1, Str:D $s2 --> UInt) is export {
    fail "strands must be of equal length" if $s1.chars != $s2.chars;
    [+] $s1.comb >>ne<< $s2.comb
}