unit module Solution;

# my defaults
use fatal;
use variables :D;
use experimental :cached;

#| The tests have been designed assuming this interface.
role Circular-Buffer-Interface is export {
    has UInt $.capacity is required;
    
    #|« * reading empty buffer should fail
        * each item may only be read once
        * a read frees up capacity for another write
        * items are read in the order they are written
        * read position is maintained even across multiple writes »
    multi method read(UInt $count --> Seq) {...}

    #|« * full buffer can't be written to
        Raku Note:
        * Slurpy parameters declared with two stars ** do not flatten
        * Returns the number of written items
        * any Iterable arguments within the list, but keep the arguments more or less as-is. »
    multi method write(**@items --> UInt) {...}

    #|« * overwrite replaces the oldest item on full buffer
        * Returns the number of written items
        * overwrite acts like write on non-full buffer »
    multi method overwrite(**@items --> UInt) {...}
    
    #|« * clear frees up all capacity
        * Returns True on success
        * clear does nothing on empty buffer »
    multi method clear( --> Bool) {...}
}

#|« Please implement the methods read/write/overwrite/clear.
    
    Examples:
    my $buff = Circular-Buffer.new(capacity => 7);
    say $buff.write(2,3,4,'a', 'b', 'c', 'd');  # 7
    say $buff.read(1);                          # (2)
    say $buff.read(3);                          # (3 4 a)
    say $buff.write('X');                       # 1
    say $buff.read(1);                          # (b)
    say $buff.write('X', <q r s>, 'Y');         # 3
    say $buff.read($buff.elems);                # (c d X X (q r s) Y)
    
    You could add (private) classes, (private) fields or (private) methods if needed.

    Good luck!
»
class Circular-Buffer does Circular-Buffer-Interface is export {

    has UInt $.elems = 0;
    has UInt $!read-pointer = 0;
    has UInt $!write-pointer = 0;
    has @.buffer = [];

    multi method clear( --> Bool) {
        $!elems = 0;
        $!read-pointer = 0;
        $!write-pointer = 0;
        @!buffer = [];
        True            
    }

    method !is-empty(                 --> Bool) { $!elems == 0 }
    method !is-full(                  --> Bool) { $!elems == $!capacity }
    method !has-space-for(UInt $count --> Bool) { $count <= ($!capacity - $!elems) }
    
    multi method read(  --> Seq){ self.read(1) }
    multi method read(0 --> Seq){ Nil          }
    multi method read(UInt $count --> Seq){
        PRE { $count <= $!elems }
        gather { take self!get-item for ^$count }
    }
    
    multi method write { 0 }    
    multi method write(**@items --> UInt){ 
        PRE   { +@items and self!has-space-for(+@items) }

        self!write-item($_) for @items;
        +@items
    }
    multi method overwrite(**@items --> UInt){ 
        PRE   { +@items }

        self!write-item($_) for @items;
        +@items
    }
    
    method !get-item { 
        PRE   { not self!is-empty }
        
        LEAVE { $!elems-- unless self!is-empty;
                @!buffer[ $!read-pointer ] = Nil;
                $!read-pointer = ($!read-pointer + 1) % $!capacity }
        
        @!buffer[ $!read-pointer ].clone
    }

    method !write-item($item) {
        LEAVE { $!elems++ unless self!is-full; 
                $!write-pointer = ($!write-pointer + 1) % $!capacity }
        
        @!buffer[ $!write-pointer ] = $item.clone
    }
}