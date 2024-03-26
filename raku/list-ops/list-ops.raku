#| simple List Item implementation - do not change!;
class ListItem {
	has $.value;
	has ListItem $.succ is rw;
}

#| simple Linked List implementation - do not change!;
class LinkedList {
	has ListItem $.ancor = ListItem.new;
	has ListItem $.last-elem is rw;
	method add (ListItem $item) {
		with $!last-elem {
			$!last-elem.succ = $item;
			$!last-elem = $!last-elem.succ
		}
		without $!last-elem {
			$!last-elem = $item;
			$!ancor.succ = $!last-elem
		}
	}
	multi method gist( --> Str:D) {
		my ListItem $current = $!ancor;
		join ' -> ', gather {
			while $current.succ {
				take $current.succ.value;
				$current = $current.succ;
			}
		}
	}
}

#|« Your task is to implement the following List Operations - designed to be applied to an object of class LinkedList.

    For easy testing the classes LinkedList and ListItem are given and should be used "as is".»
role LinkedListOps {
	#| append (given two lists, add all items in the second list to the end of the first list);
	multi method append(LinkedList $second-list --> LinkedList) {
		with self.last-elem {
			self.last-elem.succ = $second-list.ancor.succ;
		}
		without self.last-elem {
			self.ancor.succ = $second-list.ancor.succ;
		}
		return self
	}

	#| concatenate (given a series of lists, combine all items in all lists into one flattened list);
	#multi method concatenate( | --> LinkedList) {...}

	#| filter (given a predicate and a list, return the list of all items for which predicate(item) is True);
	#multi method filter( | --> LinkedList) {...}

	#| length (given a list, return the total number of items within it);
	#multi method length( | --> UInt) {...}

	#| map (given a function and a list, return the list of the results of applying function(item) on all items);
	#multi method map( | --> LinkedList) {...}

	#| foldl (given a function, a list, and initial accumulator, fold (reduce) each item into the accumulator from the left);
	#multi method foldl( | ) {...}

	#| foldr (given a function, a list, and an initial accumulator, fold (reduce) each item into the accumulator from the right);
	#multi method foldr( | ) {...}

	#| reverse (given a list, return a list with all the original items, but in reversed order)
	#multi method reverse( | --> LinkedList) {...}
}

use Test;

my $ll-with-ops1 = LinkedList.new does LinkedListOps;
$ll-with-ops1.add(ListItem.new: value => $_) for ^3;

my $ll-with-ops2 = LinkedList.new does LinkedListOps;
$ll-with-ops2.add(ListItem.new: value => $_) for 3..6;

say "List 1: " ~ $ll-with-ops1.gist;
say "List 2: " ~ $ll-with-ops2.gist;
is $ll-with-ops1.append($ll-with-ops2).gist, '0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6';
say "List 1 append List 2: " ~ $ll-with-ops1.gist;