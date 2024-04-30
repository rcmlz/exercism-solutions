proto largest-product (Str $number, UInt $span --> UInt) is export {*}
multi largest-product ($number, 0 --> 1) { }
multi largest-product ($number, $span where 1 .. $number.chars ) {
    max $number.comb.rotor( $span => - $span.pred )».reduce: &[×]
}
