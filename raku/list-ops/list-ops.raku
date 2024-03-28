#| simple List Item implementation - do not change!
class ListItem {
    has $.value;
    has ListItem $.succ is rw;
    multi method clone(--> ListItem) {
        ListItem.new(value => $!value.clone)
    }
}

#| simple Linked List implementation - do not change!
class LinkedList {
    has ListItem $.anchor = ListItem.new;
    has ListItem $.last-elem is rw;

    #| Human readable LinkedList
    multi method gist(--> Str:D) {
        my ListItem $current = $!anchor;
        join ' -> ', gather {
            while $current.succ {
                take $current.succ.value;
                $current = $current.succ;
            }
        }
    }

    #| Creating a clone - better slow than sorry
    multi method clone(--> LinkedList) {
        my $ll = LinkedList.new;
        my ListItem $current = $!anchor;
        while $current.succ {
            $ll.add($current.succ);
            $current = $current.succ;
        }
        return $ll
    }

    #| push a clone of a ListItem to the end of a LinkedList
    multi method add (ListItem $item --> LinkedList) {
        with self.last-elem {
            self.last-elem.succ = $item.clone;
            self.last-elem = self.last-elem.succ;
        }
        without self.last-elem {
            self.last-elem = $item.clone;
            self.anchor.succ = self.last-elem
        }
        return self
    }

    #| get the head of a LinkedList
    multi method head (--> LinkedList) {
        my $head = LinkedList.new;
        $head.add: self.anchor.succ;
        return $head
    }

    #| get everything but the first element of a LinkedList
    multi method tail (--> LinkedList) {
        my $tail = LinkedList.new;
        my ListItem $current = self.anchor.succ;
        while $current.succ {
            $tail.add($current.succ);
            $current = $current.succ;
        }
        return $tail
    }
}

# Here is where your fun starts - as Raku has everything included we need to fake it.
# We just pretend nothing is there and we are forced to work with the LinkedList and ListItem classes listed above.

#| append (given two lists, add all items in the second list to the end of the first list);
sub append(LinkedList $first-list, LinkedList $second-list --> LinkedList) {
    my $ll = $first-list.clone;
    with $ll.last-elem {
        $ll.last-elem.succ = $second-list.anchor.succ;
    }
    without $ll.last-elem {
        $ll.anchor.succ = $second-list.anchor.succ;
    }
    return $ll
}

#| concatenate (given a series of lists, combine all items in all lists into one flattened list);
sub concatenate(**@lists --> LinkedList) {
    my $ll = @lists.shift.clone;
    $ll = append($ll, $_) for @lists;
    return $ll
}

#| filter (given a predicate and a list, return the list of all items for which predicate(item) is True);
sub filter(LinkedList $list, &predicate --> LinkedList) {
    my $filtered = LinkedList.new;
    my ListItem $current = $list.anchor;
    while $current.succ {
        $filtered.add($current.succ) if predicate($current.succ.value);
        $current = $current.succ;
    }
    return $filtered
}

#| length (given a list, return the total number of items within it);
sub length(LinkedList $list --> UInt) {
    my UInt $len = 0;
    my ListItem $current = $list.anchor;
    while $current.succ {
        $len++;
        $current = $current.succ;
    }
    return $len;
}

#| map (given a function and a list, return the list of the results of applying function(item) on all items);
sub map(LinkedList $list, &function --> LinkedList) {
    my $mapped = LinkedList.new;
    my ListItem $current = $list.anchor;
    while $current.succ {
        $mapped.add(ListItem.new(value => function($current.succ.value)));
        $current = $current.succ;
    }
    return $mapped
}

#| foldl (given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left);
sub foldl(LinkedList $list, &fun, $acc) {
    return $acc without $list.anchor.succ;
    foldl($list.tail, &fun, fun($acc, $list.anchor.succ.value))
}

#| foldr (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right);
sub foldr(LinkedList $list, &fun, $acc) {
    foldl(reverse($list), &fun, $acc)
}

#| reverse (given a list, return a list with all the original items, but in reversed order)
sub reverse(LinkedList $list, LinkedList $acc = LinkedList.new --> LinkedList) {
    return $acc without $list.anchor.succ;
    reverse($list.tail, append($list.head, $acc))
}

use Test;

my $ll-with-ops1 = LinkedList.new;
$ll-with-ops1.add: ListItem.new(value => $_) for ^3;
my $ll-with-ops2 = LinkedList.new;
$ll-with-ops2.add: ListItem.new(value => $_) for 3 .. 6;
my $ll-with-ops3 = LinkedList.new;
$ll-with-ops3.add: ListItem.new(value => $_) for 7 .. 11;

say "List 1: " ~ $ll-with-ops1.gist;
say "List 2: " ~ $ll-with-ops2.gist;
say "List 3: " ~ $ll-with-ops3.gist;

is append($ll-with-ops1, $ll-with-ops2).gist, '0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6';
is concatenate($ll-with-ops1, $ll-with-ops2, $ll-with-ops3).gist,
        '0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 9 -> 10 -> 11';

sub some-predicate      ($value --> Bool) {
    7 < $value < 10
}
sub some-other-predicate($value --> Bool) {
    0 < $value < 5 and 3 < $value < 11
}
is filter($ll-with-ops3, &some-predicate).gist, '8 -> 9';
is filter($ll-with-ops2, &some-other-predicate).gist, '4';

is length($ll-with-ops1).gist, 3;
is length($ll-with-ops2).gist, 4;
is length($ll-with-ops3).gist, 5;

sub some-function      ($value) {
    $value * 2
}
sub some-other-function($value) {
    "." x $value
}
is map($ll-with-ops1, &some-function).gist, '0 -> 2 -> 4';
is map($ll-with-ops2, &some-other-function).gist, '... -> .... -> ..... -> ......';

sub some-aggregation-function       (Numeric $a, Numeric $b) {
    $a + $b
}
sub some-other-aggregation-function (Numeric $a, Numeric $b where $b != 0) {
    $a / $b
}
is foldl($ll-with-ops1, &some-aggregation-function, 0).gist, 3;
is foldl($ll-with-ops2, &some-other-aggregation-function, 1).gist, 1 / 3 / 4 / 5 / 6;
is foldr($ll-with-ops1, &some-aggregation-function, 0).gist, 3;
is foldr($ll-with-ops2, &some-other-aggregation-function, 1).gist, 1 / 6 / 5 / 4 / 3;

is reverse($ll-with-ops1).gist, '2 -> 1 -> 0';

say "List 1: " ~ $ll-with-ops1.gist;
say "List 2: " ~ $ll-with-ops2.gist;
say "List 3: " ~ $ll-with-ops3.gist;
