unit module Scrabble;

constant %LETTERS = { 1 => <A E I O U L N R S T>,
                      2 => <D G>,
                      3 => <B C M P>,
                      4 => <F H V W Y>,
                      5 => <K>,
                      8 => <J X>,
                      10 => <Q Z> }.invert;

sub scrabble-score (Str $word --> UInt) is export {
    sum $word.uc.comb.Bag.map: { %LETTERS{.key} × .value }
}
