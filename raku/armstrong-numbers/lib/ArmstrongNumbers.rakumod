unit module ArmstrongNumbers;

sub is-armstrong-number (UInt $number, --> Bool) is export {
    my @digits = $number.comb;
    my $exponent = @digits.elems;
    $number == sum @digits>>.&{ $_ ** $exponent}
}
