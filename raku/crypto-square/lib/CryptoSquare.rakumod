unit module CryptoSquare;

grammar Splitter {
    # as many times as possible size $m, then sizes $n, until entire string is consumed
    token TOP ( $*m, $*n ) { [:!r <long>+] <short>+ } # no ratchet for <long>, needs to look backwards to make <short> match
    token long             { \w ** {$*m}            }
    token short            { \w ** {$*n}            }
}

sub crypto-square ($text) is export {
    my $clean-text = $text.lc.trans(/\W/ => '');
    my $len = $clean-text.chars;
    my $r = $len.sqrt.round;
    return $clean-text if $r < 2;

    my $c = $r;
    # If c is the number of columns and r is the number of rows,
    # then for the rectangle r x c find the smallest possible integer c such that:
    # r * c >= length of message,
    # and c >= r,
    # and c - r <= 1.
    $c++ if $c * $r < $len;
    $r-- while $c * $r > $len;

    my %parsed = Splitter.parse($clean-text, :args(($c, $r))).hash;
    my @matches = map *.Str, |%parsed{'long'}, |%parsed{'short'};
    my @output is default('');
    for @matches -> $match {
        my @match = $match.comb;
        my $i = @match.elems;
        @output[$_] ~= @match[$_] for ^$i;
        @output[$_] ~= ' '        for $i..^$c
    }
    @output.join(' ')
}
