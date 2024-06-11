#| delegate to parameterized Array, see https://docs.raku.org/language/objects#Delegation
unit class LinkedList;

has UInt @!q handles(count => 'elems', 'push', 'pop', 'shift', 'unshift');

method delete(UInt $value --> Array[UInt](Slip)) {
    @!q.splice($_, 1) with @!q.first($value, :k)
}

#|«
If the instances in the test cases would be created parameterized:

my LinkedList[UInt] $linked-list.=new

Then Generics would work too:
»
#unit role LinkedList[::T] ;
#has T @!q handles(count => 'elems', 'push', 'pop', 'shift', 'unshift');
#
#method delete(T $value --> Array[T](Slip)) {
#    @!q.first($value, :k) andthen @!q.splice($_, 1)
#}
