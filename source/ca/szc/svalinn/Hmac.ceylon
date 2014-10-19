import ceylon.language.meta.model {
    Class
}

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
shared abstract class Hmac(delegateClass, key = null) satisfies SecureHash {
    "An instance of this is created for use as the HMAC hash algorithm."
    Class<SecureHash,[]> delegateClass;
    
    "The encapsulated instance of [[delegateClass]]. Used to hash keys that are
     too long, and applied when creating the layered output hash."
    SecureHash delegate = delegateClass();
    
    "The shared secret used to sign the input. If [[null]], [[newKey]] must be
     called before calling any other method."
    Array<Byte>? key;
    
    void processKey(Array<Byte> key) {
        // TODO
    }
    if (exists key) {
        processKey(key);
    }
    
    // TODO normalise the length of the key (apply hash if too long, pad if too short)
    // TODO process key into inner and outer key pad (don't need the message for this)
    // TODO with class reference, create object and immediately add the inner key pad to it. External calls to more go to this object.
    // TODO save outer key pad for done call, where another hash object will be created
    
    // TODO ^^^ might actually be able to do all that with one instance, by saving result before reusing?
    
    shared actual Integer outputSize => delegate.outputSize;
    shared actual Integer blockSize => delegate.blockSize;
    
    shared actual Array<Byte> done() {
        return nothing;
    }
    
    shared actual void more(Array<Byte> input) {
    }
    
    shared actual void reset() {
        delegate.reset();
        // TODO ???
    }
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, except with a new [[key]]."
    shared void newKey(Array<Byte> key) {
        reset();
        processKey(key);
    }
}
