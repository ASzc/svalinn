import ca.szc.svalinn {
    KeyedHash,
    BlockedHash
}

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
shared abstract class Hmac(delegateClass, originalKey = null) satisfies KeyedHash {
    "An instance of this is created for use as the HMAC hash algorithm."
    Class<BlockedHash,[]> delegateClass;
    
    "The encapsulated instance of [[delegateClass]]. Used to hash keys that are
     too long, and applied when creating the layered output hash."
    BlockedHash delegate = delegateClass();
    
    shared actual Integer outputSize => delegate.outputSize;
    
    "[[null]] when [[originalKey]] wasn't been specified and [[newKey]] hasn't
     been called. Set by [[processKey]]."
    variable Array<Byte>? outer_pad = null;
    
    void processKey(Array<Byte> key) {
        delegate.reset();
        
        // Normalise the key length and init the pad arrays
        Array<Byte> inner_pad = arrayOfSize(delegate.blockSize, 0.byte);
        Array<Byte> outer_pad = arrayOfSize(delegate.blockSize, 0.byte);
        if (key.longerThan(delegate.blockSize)) {
            // The output of a hash function is always going to be smaller than
            // the block size (it's a compression function).
            Array<Byte> hash = delegate.last(key);
            hash.copyTo(inner_pad);
            hash.copyTo(inner_pad);
        } else {
            key.copyTo(inner_pad);
            key.copyTo(outer_pad);
        }
        
        // XOR the pads (containing copies of the normalised key)
        for (i->byte in inner_pad.indexed) {
            inner_pad.set(i, byte.xor(#36.byte));
            outer_pad.set(i, byte.xor(#5c.byte));
        }
        delegate.more(inner_pad);
        this.outer_pad = outer_pad;
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
            outer_pad = null;
        }
    }
    reset();
    
    shared actual void newKey(Array<Byte> key) {
        processKey(key);
    }
    
    shared actual Array<Byte> done() {
        if (exists okp = outer_pad) {
            Array<Byte> innerOutput = delegate.done();
            delegate.more(okp);
            return delegate.last(innerOutput);
        } else {
            // TODO raise state exception? key not provided yet.
            return nothing;
        }
    }
    
    shared actual void more(Array<Byte> input) {
        if (outer_pad exists) {
            delegate.more(input);
        } else {
            // TODO raise state exception? key not provided yet.
        }
    }
}
