"Abstract class for hash functions that apply Merkle–Damgård construction in
 order to accept arbitrary sized input into a fixed input compression
 function."
shared abstract class MerkleDamgardHash() satisfies BlockedHash {
    "Process a complete block of size [[blockSize]]. This method will be called
     automatically each time a [[blockSize]] sized piece of input has been
     gathered."
    shared formal void compressBlock(Array<Byte> block);
    
    variable Array<Byte>? blockRemainder = null;
    
    "Perform Merkle–Damgård compliant padding of an incomplete block."
    Array<Byte> strengthen(Array<Byte> incomplete) { // TODO right name?? pad?
        return nothing;
    }
    
    shared actual Array<Byte> done() {
        if (exists br = blockRemainder) {
            compressBlock(strengthen(br));
        }
        return compressorOutput();
    }
    
    "Return the current result of the inner compression function. This method
     will be called automatically when [[done]] is called."
    shared formal Array<Byte> compressorOutput();
    
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
                compressBlock(blockBuffer);
                readInput = minimumInput;
            }
        } else {
            readInput = 0;
        }
        
        variable Integer endOfPrevBlock = readInput;
        variable Integer remaining = input.size - readInput;
        while (remaining >= blockSize) {
            compressBlock(input[endOfPrevBlock:blockSize]);
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
        resetCompressor();
    }
    
    "Reset the inner compression function. This method will be called
     automatically when [[reset]] is called."
    shared formal void resetCompressor();
}
