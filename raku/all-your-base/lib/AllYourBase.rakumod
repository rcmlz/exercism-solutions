sub convert-base (:%bases!  where 1 < .values.all,
                  :@digits! where 0 ≤ .all < %bases<from> --> List ) is export {

    return (0,) if @digits.all == 0;

    @digits.reverse.pairs.map( { .value * .key.exp( %bases<from> ) } ).sum # digits to base 10 number
           .polymod( %bases<to> xx ∞ ).reverse.List                        # base 10 number to output list
}