unit module MatchingBrackets;

grammar M {
    token TOP { <brackets>* }
    token brackets { <opening-bracket> <brackets>* <closing-bracket> }
    token opening-bracket { <:Open_Punctuation> }
    token closing-bracket { <:Close_Punctuation> }
}

class C {
    method TOP ($match) {
        $match.make: $match<brackets>».made.all == True
    }
    method brackets($/) {
        make 0 < $<closing-bracket>.ord - $<opening-bracket>.ord <= 2
    }
}

sub has-matching-brackets (Str $string --> Bool) is export {
    my $brackets-only = $string.comb(/ <:Open_Punctuation +:Close_Punctuation> /).join;
    so M.parse($brackets-only, actions => C.new).made
}