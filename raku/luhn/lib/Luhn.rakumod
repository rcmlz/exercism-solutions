constant @doubled = 0, 2, 4, 6, 8, 1, 3, 5, 7, 9;

multi is-luhn-valid (Str $input --> Bool) is export {
    (.elems > 1) and (.reverse.pairs.map({ .key %% 2 ?? .value !! @doubled[.value] }).sum %% 10)
    with $input.comb(/<:Number>/)
}

multi is-luhn-valid (Str $input where /<:!Number - :Space_Separator>/ --> False) is export {}