use v6.*;

sub series (Str $string, UInt $length where 1..$string.chars --> Seq) is export {
    comb $length => -$length.pred, $string
}
