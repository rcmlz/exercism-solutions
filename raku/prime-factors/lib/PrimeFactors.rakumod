unit module PrimeFactors;

sub factors ( UInt $number is copy --> List(Seq) ) is export {
    return () if $number < 2;

    my @primes = flat 2, (3,5,7 ... $number.sqrt).grep: *.is-prime;

    gather {
        for @primes -> $prime {
            while $number %% $prime {
                take $prime;
                $number div= $prime
            }
        }
        take $number if $number > 1;
    }
}
