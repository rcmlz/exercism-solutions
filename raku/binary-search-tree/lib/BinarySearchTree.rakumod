unit class BinarySearchTree;

class Node {
    has $.data;
    has Node ($.left, $.right) is rw;
}

has Node $.root is rw;

method add ($data) {
      self.inject: parrent => $!root, child => Node.new(:$data)
}

method inject (Node :$parrent!, Node :$child!) {
    my $cmp = $child.data cmp $parrent.data;

    given            ($cmp,        $parrent.left.so, $parrent.right.so) {
        when $_  eqv (Less | Same, False           , True | False) { $parrent.left  = $child }
        when $_  eqv (More       , True | False    , False       ) { $parrent.right = $child }

        when $_  eqv (Less | Same, True            , True | False) { self.inject: parrent=>$parrent.left,  :$child }
        when $_  eqv (More       , True | False    , True        ) { self.inject: parrent=>$parrent.right, :$child }

        default { fail "Not implemented for parrent $parrent and child $child " }
    }
}

method sort ($node=$!root --> List()) {
    my @left  = self.sort($node.left)  with $node.left;
    my @right = self.sort($node.right) with $node.right;
    |@left, $node.data, |@right
}
