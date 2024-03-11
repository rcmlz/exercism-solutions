unit module Sieve;

proto find-primes ( UInt:D --> List ) is export {*}
multi find-primes ( 0 ) { () }
multi find-primes ( 1 ) { () }
multi find-primes ( $number ) is export {
    2, |sieve( (2 .. $number).grep( not * %% 2 ) )
}
multi sieve([]){[]}
multi sieve(@range){
    with @range.head -> $prime {
        $prime, |samewith(@range.skip.grep( not * %% $prime )) }
}