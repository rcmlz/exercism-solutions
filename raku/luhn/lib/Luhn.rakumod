multi is-luhn-valid (Str $input --> Bool) is export {
    (.elems > 1) and (.reverse »*» (1, 2) andthen .map(*.comb.sum).sum %% 10)
    with $input.comb(/<:Number>/)
}

multi is-luhn-valid (Str $input where /<:!Number - :Space_Separator>/ --> False) is export {}