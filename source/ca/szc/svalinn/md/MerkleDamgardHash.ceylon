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
    
    variable Array<Byte> latentBlock = Array<Byte> { };
    
    variable Integer blockCount = 0;
    
    shared actual void reset() {
        latentBlock = Array<Byte> { };
        blockCount = 0;
        delegate.reset();
    }
    
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
        delegate.compress(strengthen(latentBlock));
        blockCount++;
        return delegate.done();
    }
    
    shared actual void more(Array<Byte> input) {
        if (input.size > 0) {
            // Have to make this variable to satisfy the compiler
            variable Integer inputTaken = 0;
            if (latentBlock.size == blockSize) {
                delegate.compress(latentBlock);
                blockCount++;
                latentBlock = Array<Byte> { };
            } else if (latentBlock.size > 0) {
                Integer latentGap = blockSize - latentBlock.size;
                if (input.size <= latentGap) {
                    Integer concatSize = latentBlock.size + input.size;
                    Array<Byte> newLatentBlock = arrayOfSize(concatSize, 0.byte);
                    latentBlock.copyTo(newLatentBlock);
                    input.copyTo(newLatentBlock, 0, latentBlock.size);
                    latentBlock = newLatentBlock;
                    return;
                } else {
                    Array<Byte> block = arrayOfSize(blockSize, 0.byte);
                    latentBlock.copyTo(block);
                    input.copyTo(block, 0, latentBlock.size, latentGap);
                    delegate.compress(block);
                    blockCount++;
                    latentBlock = Array<Byte> { };
                    inputTaken = latentGap;
                }
            }
            
            variable Integer endOfPrevBlock = inputTaken;
            variable Integer remaining = input.size - inputTaken;
            while (remaining > blockSize) {
                delegate.compress(input[endOfPrevBlock:blockSize]);
                blockCount++;
                endOfPrevBlock += blockSize;
                remaining -= blockSize;
            }
            if (remaining > 0) {
                latentBlock = input[endOfPrevBlock:remaining];
            } else {
                latentBlock = Array<Byte> { };
            }
        }
    }
}
