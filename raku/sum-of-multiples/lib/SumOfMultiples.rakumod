unit module SumOfMultiples;

sub sum-of-multiples (Array[UInt](List) :$factors, UInt :$limit --> UInt) is export {
    $factors.flatmap(-> $factor {
            $factor > 0 and
            $factor «*« (1 .. ($limit div $factor - ($limit %% $factor ?? 1 !! 0)))})
    .unique
    .sum
}
