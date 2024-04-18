unit module Wordy;

grammar WordyGrammar {
    token TOP { <word>+ <term> <punct> }
    token word { <wb> <:Letter>+ <ws> }
    token term { <integer> [<ws> <operator> <ws> ['by' <ws>]* <integer>]* }
    token integer { <[-]>? <:N>+ }
    token operator { plus | minus | multiplied | divided }
}

sub answer ($question) is export {
    my $match = WordyGrammar.parse($question) || fail;

    my @integers of Int = $match<term><integer>.map: *.Int;
    my @operators of Str = $match<term><operator>.map: *.Str;

    my $result = @integers.shift;
    for @operators {
        when 'plus' { $result += @integers.shift }
        when 'minus' { $result -= @integers.shift }
        when 'multiplied' { $result *= @integers.shift }
        when 'divided' { $result /= @integers.shift }
        default { fail }
    }
    return $result
}
