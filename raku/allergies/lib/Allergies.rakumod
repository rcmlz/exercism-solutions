unit module Allergies;

use variables :D;
use fatal;
use experimental :cached;

enum Allergen is export < Eggs Peanuts Shellfish Strawberries Tomatoes Chocolate Pollen Cats >;

sub allergic-to(Allergen :$item, UInt :$score --> Bool) is cached is export {
    so 1 +< $item +& $score
}

sub list-allergies(UInt $score --> Set[Allergen]) is cached is export {
    Set[Allergen].new(Allergen::
            .values
            .grep: -> $item { allergic-to(:$item, :$score) })
}
