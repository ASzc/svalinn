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
        
        if (exists br = blockRemainder) {
            // TODO
        } else {
            //{[Byte+]*} block = input.partition(blockSize);
            
            //Array<Byte> buffer = Array<Byte>({0.byte}.repeat(blockSize));
            //variable Integer endOfPrevBlock = 0;
            //variable Integer remaining = input.size;
            //while (remaining >= blockSize) {
            //    input.copyTo(buffer, endOfPrevBlock, 0, blockSize);
            //    
            //    processBlock(buffer);
            //    endOfPrevBlock += blockSize;
            //    remaining -= blockSize;
            //}
            //if (remaining > blockSize) {
            //    blockRemainder = input[endOfPrevBlock:remaining];
            //} else {
            //    blockRemainder = null;
            //}
            
            variable Integer endOfPrevBlock = 0;
            variable Integer remaining = input.size;
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
    }
    
    shared actual Integer outputSize {
        return nothing;
    }
    
    shared actual void reset() {
    }
}
