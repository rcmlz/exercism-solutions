sub is-isbn10 ($number) is export {
    with $number.subst(/ \- /, :g) {
        return False unless / ^^ [<digit>] ** 9 [<digit> | X] $$ /;
        with .comb(/<digit>/) {
            9 <= .elems <= 10 and sum(|$_, 10 Z[R*] 1..10) %% 11
        }
    }
}
