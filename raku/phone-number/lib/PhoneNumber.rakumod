grammar NANP {
    token TOP { <Country-Code>? \D* <Area-Code> \D* <Exchange-Code> \D* <Subscriber-Number> \D* }
    token Country-Code      { '+'? 1 }
    token Area-Code         { <N><X><X> }
    token Exchange-Code     { <N><X><X> }
    token Subscriber-Number { <X> ** 4 }
    token N                 { <[2..9]> }
    token X                 { <[0..9]> }
}

sub clean-number ($number) is export {
    NANP.parse($number)<Area-Code Exchange-Code Subscriber-Number>.join
         || check-number-and-return-special-errors($number)
}

sub check-number-and-return-special-errors ($number) {
    my @digits = $number ~~ m:g/\d/ || [];
    fail 'must not be greater than 11 digits' if @digits.elems > 11;

    my @letter = $number ~~ m:g/<:Letter>/ || [];
    fail 'letters not permitted' if @letter;

    my @puncations = $number ~~ m:g/<:P>/ || [];
    my @allowed = $number ~~ m:g/<[( ) \. \+ \-]>/ || [];
    @puncations = @puncations.map: *.Str;
    @allowed = @allowed.map: *.Str;
    @puncations = @puncations (-) @allowed;
    fail 'punctuations not permitted' if @puncations.elems;
    fail 'must not be fewer than 10 digits' if @digits.elems < 10;
    fail '11 digits must start with 1' if (@digits.elems == 11 and @digits[0] != 1);

    my $area-code-start = @digits.elems - 11 + 1;
    fail 'exchange code cannot start with zero' if @digits[$area-code-start + 3] == 0;
    fail 'exchange code cannot start with one' if @digits[$area-code-start + 3] == 1;
    fail 'area code cannot start with zero' if @digits[$area-code-start] == 0;
    fail 'area code cannot start with one' if @digits[$area-code-start] == 1;
}
