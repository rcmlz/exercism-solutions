unit module Anagram:ver<1>:auth<exercism:rcmlz>:api<1>;

sub match-anagrams (Str :$subject!, :@candidates! --> List(Seq)) is export {
    my Str $subject-lc = $subject.lc;
    my Str $subject-lc-sorted = $subject-lc.comb.sort.join;
    @candidates.grep( { $subject-lc ne .lc and $subject-lc-sorted eq .lc.comb.sort.join } )
}
