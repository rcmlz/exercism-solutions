unit module Darts;

proto score-dart (Real :$x, Real :$y --> UInt) is export {*}
multi score-dart (:$x, :$y where {  0 ≤ $x² + $y² ≤   1 }, --> 10 ) { }
multi score-dart (:$x, :$y where {  1 < $x² + $y² ≤  25 }, -->  5 ) { }
multi score-dart (:$x, :$y where { 25 < $x² + $y² ≤ 100 }, -->  1 ) { }
multi score-dart (:$x, :$y                               , -->  0 ) { }