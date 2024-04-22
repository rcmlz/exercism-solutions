unit module BinarySearch;

sub binary-search (:@array!, :$value! --> UInt ) is export {
    return $_ with first($value, @array, :k);
    fail "element not found"
}