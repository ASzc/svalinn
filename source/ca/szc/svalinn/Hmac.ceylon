"An abstract class for applying secure hash (message digest) algorithms;
 
 * to arbitrary size input (a message),
 * with a shared secret (a key),
 
 to produce a fixed length output that can be authenticated by parties that
 know the shared secret. This process is [HMAC]
 (https://en.wikipedia.org/wiki/HMAC) (Hash-based Message Authentication Code).
 In some ways HMAC is similar to asymmetric (public/private) signatures, but
 with a symmetric (single) key.
 
 HMAC can also be used to augment other secrets (like passwords) to make the
 output hash more resistant to certain kinds of reversal attacks (e.g. rainbow
 tables)."
shared abstract class Hmac(delegate) satisfies SecureHash {
    "Used to hash keys that are too long, and applied twice when creating the
     final layered output hash."
    SecureHash delegate;
    
    shared actual Integer outputSize => delegate.outputSize;
    shared actual Integer blockSize => delegate.blockSize;
    
    shared actual Array<Byte> done() {
        return nothing;
    }
    
    shared actual void more(Array<Byte> input) {
    }
    
    shared actual void reset() {
    }
    
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, except with a new [[key]]."
    shared void newKey(Array<Byte> key) {
        // TODO
    }
}
