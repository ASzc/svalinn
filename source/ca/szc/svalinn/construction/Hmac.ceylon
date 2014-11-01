import ca.szc.svalinn {
    KeyedVariableInputCompressor,
    BlockedVariableInputCompressor
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
shared abstract class Hmac(delegateClass, originalKey) satisfies KeyedVariableInputCompressor {
    "An instance of this is created for use as the HMAC hash algorithm.
     Technically only [[MerkleDamgardHash]] and other length
     extension vulnerable constructions need to use HMAC for MACs."
    Class<BlockedVariableInputCompressor,[]> delegateClass;
    
    "The encapsulated instance of [[delegateClass]]. Used to hash keys that are
     too long, and applied when creating the layered output hash."
    BlockedVariableInputCompressor delegate = delegateClass();
    
    shared actual Integer outputSize => delegate.outputSize;
    
    "The shared secret used to sign the input."
    Array<Byte> originalKey;
    
    "The pad used to start the second pass with [[delegate]]"
    variable Array<Byte> outer_pad = arrayOfSize(delegate.blockSize, 0.byte);
    
    shared actual void newKey(Array<Byte> key) {
        delegate.reset();
        
        // Normalise the key length and init the pad arrays
        Array<Byte> inner_pad = arrayOfSize(delegate.blockSize, 0.byte);
        if (key.longerThan(delegate.blockSize)) {
            // The output of a hash function is always going to be smaller than
            // the block size (it's a compression function).
            Array<Byte> hash = delegate.last(key);
            hash.copyTo(inner_pad);
            hash.copyTo(outer_pad);
        } else {
            key.copyTo(inner_pad);
            key.copyTo(outer_pad);
        }
        
        // XOR the pads (containing copies of the normalised key).
        // The arrays have been set to the same contents, so just read from
        // one instead of looping twice.
        for (i->b in inner_pad.indexed) {
            inner_pad.set(i, b.xor(#36.byte));
            outer_pad.set(i, b.xor(#5c.byte));
        }
        delegate.more(inner_pad);
    }
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, including the [[originalKey]]."
    shared actual void reset() {
        newKey(originalKey);
    }
    
    reset();
    
    shared actual Array<Byte> done() {
        Array<Byte> innerOutput = delegate.done();
        delegate.more(outer_pad);
        return delegate.last(innerOutput);
    }
    
    shared actual void more(Array<Byte> input) {
        delegate.more(input);
    }
}
