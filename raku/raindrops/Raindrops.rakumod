#unit module Raindrops;

constant \sounds = <Pling Plang Plong>;
constant \divisors = 3, 5, 7;

sub raindrop (Int \num --> Str(Int)) is export {
    [~] sounds Zx num «%%« divisors or num;
}

raindrop(1);
use Test;
cmp-ok( # begin: 1575d549-e502-46d4-a8e1-6b7bec6123d8
    raindrop(15),
    "eqv",
    "1",
    "the sound for 1 is 1",
); # end: 1575d549-e502-46d4-a8e1-6b7bec6123d8
