constant %singles = < ones twos threes fours fives sixes > Z=> 1..6;

sub score ($dice, *%category) is export {
    given %category.keys.head {
        when 'little-straight' { 30 if 1..5 ⊆ $dice }
        when 'big-straight'    { 30 if 2..6 ⊆ $dice }
        when 'yacht'           { 50 if $dice.maxpairs.head.value > 4 }
        when 'choice'          { $dice.kxxv.sum }
        when 'full-house'      { $dice.kxxv.sum if (3, 2) ≡ $dice.values.sort.reverse.head(2) }
        when 'four-of-a-kind'  { $dice.maxpairs.head.&( *.key × 4 ) if $dice.values.max > 3 }
        default                { $dice{ $_ } × $_ with %singles{ $_ } or fail "unkown category $_" }
    }
}