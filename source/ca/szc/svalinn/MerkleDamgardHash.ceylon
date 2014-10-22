"Abstract class for hash functions that apply Merkle–Damgård construction in
 order to accept arbitrary sized input into a fixed input compression
 function."
shared abstract class MerkleDamgardHash() satisfies BlockedHash {
    "Process a complete block of size [[blockSize]]. This method will be called
     automatically each time a [[blockSize]] sized piece of input has been
     gathered."
    shared formal void processBlock(Array<Byte> block);
    
    variable Array<Byte>? blockRemainder = null;
    
    Array<Byte> strengthen() { // TODO right name?? pad?
        return nothing;
    }
    
    shared actual Array<Byte> done() {
        return nothing;
    }
    
    shared actual void more(Array<Byte> input) {
        // Assuming size is obtained in constant time since it is fixed size and backed by a native array.
        
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
                processBlock(blockBuffer);
                readInput = minimumInput;
            }
        } else {
            readInput = 0;
        }
        
        variable Integer endOfPrevBlock = readInput;
        variable Integer remaining = input.size - readInput;
        while (remaining >= blockSize) {
            processBlock(input[endOfPrevBlock:blockSize]);
            endOfPrevBlock += blockSize;
            remaining -= blockSize;
        }
        if (remaining > blockSize) {
            blockRemainder = input[endOfPrevBlock:remaining];
        } else {
            blockRemainder = null;
        }
    }
    
    shared actual Integer outputSize {
        return nothing;
    }
    
    shared actual void reset() {
    }
}
