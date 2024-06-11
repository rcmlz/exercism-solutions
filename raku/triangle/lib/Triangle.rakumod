unit module Triangle;

sub is-triangle  (\a, \b, \c) {
    a != 0 and b != 0 and c != 0
&&  a + b ≥ c
&&  b + c ≥ a
&&  a + c ≥ b

}
sub is-equilateral ($a, $b, $c) is export {
    is-triangle($a, $b, $c) and $a == $b and $b == $c
}

sub is-isosceles ($a, $b, $c) is export {
    is-triangle($a, $b, $c) and ($a == $b or $b == $c or $a == $c)
}

sub is-scalene ($a, $b, $c) is export {
    is-triangle($a, $b, $c) and $a != $b and $b != $c and $a != $c
}
