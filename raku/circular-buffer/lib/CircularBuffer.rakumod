my class X::CircularBuffer::BufferIsEmpty is X::Phaser::PrePost { method message { 'Buffer is empty' } }
my class X::CircularBuffer::BufferIsFull is X::Phaser::PrePost { method message { 'Buffer is full' } }
my class X::Phaser::PrePost is X::CircularBuffer::BufferIsFull is X::CircularBuffer::BufferIsEmpty { }

role FixedArrayGenericsBuffer[::T] {
    has UInt $.capacity is required;
    has UInt $.elems;
    has UInt $.avail;
    has UInt $!r;
    has UInt $!w;
    has @!buffer;

    submethod TWEAK {
        @!buffer := Array[T].new(:shape($!capacity));
        $!avail = $!capacity;
        $!elems = $!r = $!w = 0;
    }
    method clear(--> FixedArrayGenericsBuffer) {
        @!buffer := Array[T].new(:shape($!capacity));
        $!avail = $!capacity;
        $!elems = $!r = $!w = 0;
        self
    }
    method !tic($position is rw, --> UInt) {
        KEEP $position = ($position + 1) % $!capacity;
        $position
    }
    multi method read(--> T) {
        PRE { $!elems > 0 }
        self!get-item
    }
    multi method read(UInt $count --> Array[T]) {
        PRE { $count <= $!elems }
        my @result := Array[T].new(:shape($!capacity));
        @result =  gather { take self!get-item for ^$count };
        @result
    }
    method write(**@items --> FixedArrayGenericsBuffer) {
        PRE { +@items <= $!avail }
        self!write-item($_) for @items;
        self
    }
    method overwrite(**@items --> FixedArrayGenericsBuffer) {
        for @items -> $item {
            self!tic($!r) if $!avail == 0;
            self!write-item($item)
        }
        self
    }
    method !get-item {
        KEEP {
            $!elems-- unless $!elems == 0;
            $!avail++ unless $!avail == $!capacity;
            @!buffer[$!r] = Nil;
            self!tic($!r)
        }
        @!buffer[$!r]
    }
    method !write-item($item) {
        KEEP {
            $!elems++ unless $!elems == $!capacity;
            $!avail-- unless $!avail == 0;
            self!tic($!w)
        }
        # .clone: slow but prevents reference capturing/leaking!
        @!buffer[$!w] = $item.clone
    }
}

class CircularBuffer is export {
    # The testcases at Exercism use only UInt
    also does FixedArrayGenericsBuffer[UInt];
}