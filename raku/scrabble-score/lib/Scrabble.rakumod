constant %score = <AEIOULNRST DG BCMP FHVWY K JX QZ>».comb
             «=>» <1          2  3    4     5 8  10>».Int;

sub scrabble-score (Str:D $word --> UInt:D) is export {
    $word.uc.comb».&(-> \letter { %score{letter} || 0 } ).sum
}
