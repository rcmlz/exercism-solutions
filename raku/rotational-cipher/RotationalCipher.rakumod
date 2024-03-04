unit module RotationalCipher;

sub caesar-cipher ( :$text, :$shift-key ) is export {
    $text.ords.map( -> $ord {
        ord('A') <= $ord <= ord('z') 
            ?? transform($ord, $shift-key)
            !! $ord
    }).chrs
}

sub transform(UInt $ord, UInt $shift-key --> UInt) {
    my $base = $ord < ord('a') ?? ord('A') !! ord('a');
    ($ord - $base + $shift-key) % 26 + $base;
}