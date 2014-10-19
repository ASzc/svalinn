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
shared abstract class Hmac(delegateClass, originalKey = null) satisfies SecureHash {
    "An instance of this is created for use as the HMAC hash algorithm."
    Class<SecureHash,[]> delegateClass;
    
    "The encapsulated instance of [[delegateClass]]. Used to hash keys that are
     too long, and applied when creating the layered output hash."
    SecureHash delegate = delegateClass();
    
    shared actual Integer outputSize => delegate.outputSize;
    shared actual Integer blockSize => delegate.blockSize;
    
    "[[null]] when [[originalKey]] wasn't been specified and [[newKey]] hasn't been
     called. Set by [[processKey]]."
    variable Array<Byte>? outer_key_pad = null;
    
    void processKey(Array<Byte> key) {
        delegate.reset();
        
        Array<Byte> normalisedKey;
        if (key.longerThan(blockSize)) {
            normalisedKey = delegate.last(key);
        } else {
            // TODO pad to blockSize
            normalisedKey = nothing;
        }
        
        // TODO calculate these
        Array<Byte> inner_key_pad = nothing;
        outer_key_pad = nothing;
        
        delegate.more(inner_key_pad);
    }
    
    "The shared secret used to sign the input. If [[null]], [[newKey]] must be
     called before calling any other method."
    Array<Byte>? originalKey;
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, including the [[originalKey]] (even if it is [[null]])."
    shared actual void reset() {
        if (exists originalKey) {
            processKey(originalKey);
        } else {
            outer_key_pad = null;
        }
    }
    reset();
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, except with a new [[key]]."
    shared void newKey(Array<Byte> key) {
        processKey(key);
    }
    
    shared actual Array<Byte> done() {
        if (exists okp = outer_key_pad) {
            Array<Byte> innerOutput = delegate.done();
            delegate.more(okp);
            return delegate.last(innerOutput);
        } else {
            // TODO raise state exception? key not provided yet.
            return nothing;
        }
    }
    
    shared actual void more(Array<Byte> input) {
        if (outer_key_pad exists) {
            delegate.more(input);
        } else {
            // TODO raise state exception? key not provided yet.
        }
    }
}
