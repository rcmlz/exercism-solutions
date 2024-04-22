unit module PhoneNumber;

constant @errors = (
   '11 digits must start with 1',
   'must not be greater than 11 digits',
   'must not be fewer than 10 digits',
   'letters not permitted',
   'punctuations not permitted',
   'area code cannot start with zero',
   'area code cannot start with one',
   'exchange code cannot start with zero',
   'exchange code cannot start with one'
);

sub clean-number ($number) is export {
    my @number = $number.comb;

    fail(@errors[3]) if @number.grep(/<alpha>/);
    fail(@errors[4]) unless @number.grep(/<punct>/) ⊆ ('(', ')', '+', '-', '.');

    given @number.grep(/\d/) {
        when .elems == 11 && .[0] != 1 { fail(@errors[0]) }
        when .elems > 11 { fail(@errors[1]) }
        when .elems < 10 { fail(@errors[2]) }
        when .[.elems - 10] == 0 { fail(@errors[5]) }
        when .[.elems - 10] == 1 { fail(@errors[6]) }
        when .[.elems - 7] == 0 { fail(@errors[7]) }
        when .[.elems - 7] == 1 { fail(@errors[8]) }
        default { return [~] $_.skip(.elems - 10) }
    }
}
