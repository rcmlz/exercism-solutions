unit module SecretHandshake;
use experimental :cached;

constant ACTIONS = 'wink', 'double blink', 'close your eyes', 'jump';

proto handshake (UInt --> List) is cached is export {*}
multi handshake ($number where so $number +& 0b10000) {
    reverse handshake($number +& 0b01111)
}
multi handshake ($number) {
    gather
        for ACTIONS.kv -> $bit-shift, $action {
              take $action if 1 +< $bit-shift +& $number
        }
}