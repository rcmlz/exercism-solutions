unit module Solution;

#| The tests have been designed assuming this interface.
role Circular-Buffer-Interface is export {
    has UInt $.capacity is required;
    multi method clear(             --> Bool) {...} # returns True on success
    multi method read(              --> Any ) {...} # returns the oldest entry from the ring-buffer
    multi method write(**@items     --> UInt) {...} # returns the number of items written
    multi method overwrite(**@items --> UInt) {...} # returns the number of items written
}

#|« Please implement the public methods read/write/overwrite/clear.
    You could add (private) fields, (private) or (private) methods or even (private) classes if needed.
    "multi" was chosen to give you all the flexibility - in case you like some overloading and dynamic method resolution and stuff ...
»
class Circular-Buffer does Circular-Buffer-Interface is export {

    multi method clear( --> Bool) {
        # do your magic here
    }
    multi method read(--> Any) {
        # do your magic here
    }
    multi method write(**@items --> UInt){
        # do your magic here
     }
    multi method overwrite(**@items --> UInt){
        # do your magic here
    }
}
