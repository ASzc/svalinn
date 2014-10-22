import ca.szc.svalinn {
    BlockedVariableInputCompressor,
    FixedInputCompressor
}
import ceylon.language.meta.model {
    Class
}

"Abstract class for hash functions that apply Merkle–Damgård construction in
 order to accept arbitrary sized input into a fixed input compression
 function."
shared abstract class MerkleDamgardHash(delegateClass) satisfies BlockedVariableInputCompressor {
    "An instance of this is created for use as the compression algorithm."
    Class<FixedInputCompressor,[]> delegateClass;
    
    "The encapsulated instance of [[delegateClass]]."
    FixedInputCompressor delegate = delegateClass();
    
    shared actual Integer blockSize => delegate.blockSize;
    
    shared actual Integer outputSize => delegate.outputSize;
    
    variable Array<Byte>? blockRemainder = null;
    
    "Perform Merkle–Damgård compliant padding of an incomplete block."
    Array<Byte> strengthen(Array<Byte> incomplete) { // TODO right name?? pad?
        return nothing;
    }
    
    shared actual Array<Byte> done() {
        if (exists br = blockRemainder) {
            delegate.compress(strengthen(br));
        }
        return delegate.done();
    }
    
    shared actual void more(Array<Byte> input) {
        Integer readInput;
        if (exists br = blockRemainder) {
            Integer minimumInput = blockSize - br.size;
            if (input.size < minimumInput) {
                Array<Byte> blockBuffer = arrayOfSize(br.size + input.size, 0.byte);
                br.copyTo(blockBuffer);
                input.copyTo(blockBuffer, 0, br.size, minimumInput);
                blockRemainder = blockBuffer;
                return;
            } else {
                Array<Byte> blockBuffer = arrayOfSize(blockSize, 0.byte);
                br.copyTo(blockBuffer);
                input.copyTo(blockBuffer, 0, br.size, minimumInput);
                delegate.compress(blockBuffer);
                readInput = minimumInput;
            }
        } else {
            readInput = 0;
        }
        
        variable Integer endOfPrevBlock = readInput;
        variable Integer remaining = input.size - readInput;
        while (remaining >= blockSize) {
            delegate.compress(input[endOfPrevBlock:blockSize]);
            endOfPrevBlock += blockSize;
            remaining -= blockSize;
        }
        if (remaining > 0) {
            blockRemainder = input[endOfPrevBlock:remaining];
        } else {
            blockRemainder = null;
        }
    }
    
    shared actual void reset() {
        blockRemainder = null;
        delegate.reset();
    }
}
