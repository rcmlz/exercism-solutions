unit module NthPrime;

my @potential-primes of UInt = 2,3,5,7,9,11,13,15...Inf;

sub my-is-prime (UInt $n --> Bool) {
  # all even numbers except 2 are not prime
  return False if $n %% 2 && $n != 2;

  state $primes = [2,3,5,7,13].Set;
  return True if $n ∈ $primes;

  state $odd-numbers = [9,15].Set;
  return False if $n ∈ $odd-numbers;
  
  my UInt $divisor-id = 0;
  my UInt $max-divisor = Int(sqrt($n));
  
  while @potential-primes[$divisor-id] <= $max-divisor {
    if $n %% @potential-primes[$divisor-id] {
        #$odd-numbers = $odd-numbers ∪ $n;
        return False
    }
    $divisor-id += 1
  }

  $primes = $primes ∪ $n;

  return True
}

sub nth-prime (UInt $n where * > 0 --> UInt) is export {
    @potential-primes.grep( *.&my-is-prime )[$n - 1]
}
