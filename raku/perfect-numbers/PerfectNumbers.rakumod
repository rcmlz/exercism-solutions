unit module PerfectNumbers;

enum AliquotSumType is export (
    :Deficient(Less),
    :Perfect(Same),
    :Abundant(More),
);

sub aliquot-sum-type ( UInt $n --> AliquotSumType ) is export {
    AliquotSumType( factors($n).sum cmp $n )
}

multi factors(0) {fail}
multi factors(1) {0}
multi factors(UInt $n --> Seq(UInt)) {
    gather {
      take 1;
      for 2 .. $n div 2 -> $i {
        take $i if $n %% $i;
      }
   }
}