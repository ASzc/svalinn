import ca.szc.svalinn {
    BlockedVariableInputCompressor,
    FixedInputCompressor
}

"Abstract class for hash functions that apply Merkle–Damgård construction in
 order to accept arbitrary sized input into a fixed input compression
 function."
shared abstract class MerkleDamgardHash(delegateClass) satisfies BlockedVariableInputCompressor {
    "Called to create and instance for use as the compression algorithm."
    FixedInputCompressor() delegateClass;
    
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
    
    void compress(Array<Byte> block) {
        delegate.compress(block);
        blockCount++;
    }
    
    // If this needs to have multiple implementations in the future, pass in a
    // delegate Class reference for that. Same method as the FIC class.
    "Perform Merkle–Damgård compliant padding of the final block. Returns an
     array of size [[blockSize]] or [[blockSize]] * 2."
    Array<Byte> strengthen(Array<Byte> final) {
        assert (final.size <= blockSize);
        "The size of [[final]] in bits with the terminating '1' bit."
        Integer termBitSize = final.size * 8 + 1;
        
        "The size of the length suffix seems to hold as the byte block size
         cast to bits. A 64 byte block size would have a 64 bit suffix. Note
         the miniumum guaranteed capacity of the Integer class is only 32 bits,
         so this may not reflect the max acceptable message length."
        Integer lengthSuffixBitSize = blockSize;
        Integer blockBitSize = blockSize * 8;
        "Either one or two blocks worth. The minimum needed to fit the
         terminated message and the length value suffix."
        Integer paddedByteSize;
        if (termBitSize + lengthSuffixBitSize > blockBitSize) {
            paddedByteSize = blockSize * 2;
        } else {
            paddedByteSize = blockSize;
        }
        "The padded version of [[final]] that will be returned. Of size
         [[paddedByteSize]]."
        Array<Byte> paddedFinal = arrayOfSize(paddedByteSize, 0.byte);
        
        // Copy in final to beginning
        final.copyTo(paddedFinal);
        
        "The position of the the terminating '1' bit within the terminator byte.
         [[termBitSize]] should never divide evenly with 8."
        Integer termPosition = 8 - termBitSize.remainder(8);
        "The index of the terminator byte."
        Integer termByteIndex = termBitSize.divided(8);
        "Byte is immutable, so we have to get the existing Byte to modify it
         and replace it."
        Byte? termByte = paddedFinal.get(termByteIndex);
        assert (exists termByte);
        paddedFinal.set(termByteIndex, termByte.set(termPosition, true));
        
        "The total unterminated message size in bits."
        Integer messageBitSize = 8 * (final.size + (blockCount * blockSize));
        "The Integer representation byte size. Should be 8 on JVM (64-bit) and
         4 on JS (32-bit)."
        Integer intAddrByteSize = runtime.integerAddressableSize / 8;
        "The first byte of the length bits, as an offset from the right hand
         side. Really this should use [[lengthSuffixBitSize]], but the Integer
         class might not be of that size. This alternate offset is safe since
         the array starts as all zeros."
        Integer lengthSuffixStartByte = paddedByteSize - intAddrByteSize;
        // Serialise the Integer a Byte at a time
        for (i in 0:intAddrByteSize) {
            Byte byte = messageBitSize.rightLogicalShift((intAddrByteSize - 1 - i) * 8).byte;
            paddedFinal.set(lengthSuffixStartByte + i, byte);
        }
        
        return paddedFinal;
    }
    
    shared actual Array<Byte> done() {
        Array<Byte> finalBlocks = strengthen(latentBlock);
        variable Integer endOfPrevBlock = 0;
        while (endOfPrevBlock < finalBlocks.size) {
            compress(finalBlocks[endOfPrevBlock:blockSize]);
            endOfPrevBlock += blockSize;
        }
        Array<Byte> output = delegate.done();
        reset();
        return output;
    }
    
    shared actual void more(Array<Byte> input) {
        if (input.size > 0) {
            // Have to make this variable to satisfy the compiler
            variable Integer inputTaken = 0;
            if (latentBlock.size == blockSize) {
                compress(latentBlock);
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
                    compress(block);
                    latentBlock = Array<Byte> { };
                    inputTaken = latentGap;
                }
            }
            
            variable Integer endOfPrevBlock = inputTaken;
            variable Integer remaining = input.size - inputTaken;
            while (remaining > blockSize) {
                compress(input[endOfPrevBlock:blockSize]);
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
