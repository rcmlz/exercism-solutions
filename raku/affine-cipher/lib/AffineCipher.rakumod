unit class AffineCipher;

constant @alphabet = 'a' .. 'z';
constant $m = @alphabet.elems;
constant %alphabet = @alphabet.antipairs;

has UInt $.a where *gcd $m == 1;
has UInt $.b;

method encode (Str $phrase) {
    $phrase
        .lc
        .comb(/<alnum>/)
        .duckmap(-> $_ where %alphabet { self!enc-letter($_) })
        .batch(5)
        .map(*.join)
        .join(' ')
}

method decode (Str $phrase) {
    $phrase
        .comb(/<alnum>/)
        .duckmap(-> $_ where %alphabet { self!dec-letter($_) })
        .join
}

method !enc-letter(Str $letter) {
    @alphabet[($!a * %alphabet{$letter} + $!b) mod $m];
}

method !dec-letter(Str $letter) {
    @alphabet[(self!inverse_mod($!a, modulo => $m) * (%alphabet{$letter} - $!b)) mod $m]
}

# https://rosettacode.org/wiki/Modular_inverse#Raku
method !inverse_mod(UInt $n, UInt :$modulo) {
    state %invers_mod;
    unless %invers_mod{$n}:exists {
        my ($c, $d, $uc, $vc, $ud, $vd) = ($n % $modulo, $modulo, 1, 0, 0, 1);
        my $q;
        while $c != 0 {
            ($q, $c, $d) = ($d div $c, $d % $c, $c);
            ($uc, $vc, $ud, $vd) = ($ud - $q * $uc, $vd - $q * $vc, $uc, $vc);
        }
        %invers_mod{$n} = $ud % $modulo;
    }
    %invers_mod{$n}
}