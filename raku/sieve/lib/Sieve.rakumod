unit module Sieve;
use experimental :cached;

proto find-primes (UInt:D --> List) is cached is export {*}
multi find-primes (0) { () }
multi find-primes (1) { () }
multi find-primes ($number) {
    # map { $_, 2*$_ ... 10 }, 2 .. 10
    # ((2 4 6 8 10) (3 6 9) (4 8) (5 10) (6) (7) (8) (9) (10))
    # ⊖ : set difference
    ([⊖] map { $_, 2*$_ ... $number }, 2 .. $number).keys.sort

    # the classical approach
    # sieve( 2 .. $number )
}
proto sieve (Seq(Range) , List $agg? --> Seq ) is cached {*}
multi sieve ( (), $agg ) { $agg.reverse }
multi sieve ( $integers, $agg=() ) {
    my $prime = $integers.head;
    samewith( $integers.skip.grep(* !%% $prime), ($prime, |$agg) )
}