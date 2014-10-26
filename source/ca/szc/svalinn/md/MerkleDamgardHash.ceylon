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
    
    variable Integer blockCount = 0;
    
    // If this needs to have multiple implementations in the future, pass in a
    // delegate Class reference for that. Same method as the FIC class.
    "Perform Merkle–Damgård compliant padding of the final block. Returns
     an array of size [[blockSize]] or [[blockSize]] * 2."
    Array<Byte> strengthen(Array<Byte> final) {
        "The size with the terminating '1' bit."
        Integer terminatedSize = final.size + 1;
        "The size of the length suffix seems to hold as the byte block size
         cast to bits. A 64 byte block size would have a 64 bit suffix."
        Integer lengthSuffixByteSize = (blockSize / 8);
        
        "Either one or two blocks"
        Integer paddedSize;
        if (terminatedSize > blockSize - lengthSuffixByteSize) {
            paddedSize = blockSize * 2;
        } else {
            paddedSize = blockSize;
        }
        Array<Byte> padded = arrayOfSize(paddedSize, 0.byte);
        final.copyTo(padded);
        
        "The position of the terminator bit within the terminator byte."
        Integer termPosition = terminatedSize.remainder(8);
        "If [[final]] is a whole block, then the terminator bit is in a new,
         appended, block."
        Integer termByteIndex;
        if (termPosition == 0) {
            termByteIndex = terminatedSize.divided(8) + 1;
        } else {
            termByteIndex = terminatedSize.divided(8);
        }
        Byte? termByte = padded.get(termByteIndex);
        assert (exists termByte);
        padded.set(termByteIndex, termByte.set(termPosition, true));
        
        Integer messageLength = 8 * (final.size + blockCount * blockSize);
        Integer lengthSuffixStart = paddedSize - lengthSuffixByteSize;
        for (i in 0..lengthSuffixByteSize) {
            padded.set(lengthSuffixStart + i, messageLength.rightLogicalShift(lengthSuffixByteSize - i).byte);
        }
        
        return padded;
    }
    
    shared actual Array<Byte> done() {
        // TODO this needs to be redone (?) / checked to account for all messages being padded (even complete ones)
        // TODO might change br to contain the most recent complete block as well?
        if (exists br = blockRemainder) {
            delegate.compress(strengthen(br));
            blockCount++;
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
                blockCount++;
                readInput = minimumInput;
            }
        } else {
            readInput = 0;
        }
        
        variable Integer endOfPrevBlock = readInput;
        variable Integer remaining = input.size - readInput;
        while (remaining >= blockSize) {
            delegate.compress(input[endOfPrevBlock:blockSize]);
            blockCount++;
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
