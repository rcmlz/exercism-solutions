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

#| append (given two lists, add all items in the second list to the end of the first list)
sub append(LinkedList $first-list, LinkedList $second-list --> LinkedList) {...}

#| concatenate (given a series of lists, combine all items in all lists into one flattened list)
sub concatenate(**@lists --> LinkedList) {...}

#| filter (given a predicate and a list, return the list of all items for which predicate(item) is True)
sub filter(LinkedList $list, &predicate --> LinkedList) {...}

#| length (given a list, return the total number of items within it)
sub length(LinkedList $list --> UInt) {...}

#| map (given a function and a list, return the list of the results of applying function(item) on all items)
sub map(LinkedList $list, &function --> LinkedList) {...}

#| foldl (given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left)
sub foldl(LinkedList $list, &fun, $acc) {...}

#| foldr (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right)
sub foldr(LinkedList $list, &fun, $acc) {...}

#| reverse (given a list, return a list with all the original items, but in reversed order)
sub reverse(LinkedList $list, LinkedList $acc --> LinkedList) {...}