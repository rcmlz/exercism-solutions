unit module Luhn;

my token forbidden-chars { <:!Number - :Space_Separator> }
my token insufficient-numbers {
    ^^ <:!Number>* <:Number>? <:!Number>* $$
}

proto is-luhn-valid (Str $input --> Bool) is export {*}

multi is-luhn-valid ($input) {
    $input.comb(/<:Number>/).reverse »*» (1, 2)
            andthen .map(*.comb.sum).sum %% 10
}

multi is-luhn-valid ($input where /<forbidden-chars> || <insufficient-numbers>/ --> False) {}