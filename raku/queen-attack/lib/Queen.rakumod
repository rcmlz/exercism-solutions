unit class Queen;

constant MIN = 0;
constant MAX = 7;

has $.row where MIN <= * <= MAX;
has $.column where MIN <= * <= MAX;

method can-attack (Queen \other) {
    $!row == other.row or $!column == other.column or (other.row => other.column) ∈ self.diagonal
}

method diagonal {
    gather {
        for ^8  -> \i {
            take (($!row - i) => ($!column - i)) if $!row - i >= MIN and $!column - i >= MIN;
            take (($!row - i) => ($!column + i)) if $!row - i >= MIN and $!column + i <= MAX;
            take (($!row + i) => ($!column - i)) if $!row + i <= MAX and $!column - i >= MIN;
            take (($!row + i) => ($!column + i)) if $!row + i <= MAX and $!column + i <= MAX;
        }
    }
}