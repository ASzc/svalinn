import ca.szc.svalinn {
    FixedInputCompressor
}

shared class Sha1Compressor() satisfies FixedInputCompressor {
    Array<Byte> h0 = arrayOfSize(4, 0.byte);
    Array<Byte> h1 = arrayOfSize(4, 0.byte);
    Array<Byte> h2 = arrayOfSize(4, 0.byte);
    Array<Byte> h3 = arrayOfSize(4, 0.byte);
    Array<Byte> h4 = arrayOfSize(4, 0.byte);
    
    shared actual void reset() {
        // Magic initial values as defined in the spec
        h0.set(0, #67.byte);
        h0.set(1, #45.byte);
        h0.set(2, #23.byte);
        h0.set(3, #01.byte);
        
        h1.set(0, #EF.byte);
        h1.set(1, #CD.byte);
        h1.set(2, #AB.byte);
        h1.set(3, #89.byte);
        
        h2.set(0, #98.byte);
        h2.set(1, #BA.byte);
        h2.set(2, #DC.byte);
        h2.set(3, #FE.byte);
        
        h3.set(0, #10.byte);
        h3.set(1, #32.byte);
        h3.set(2, #54.byte);
        h3.set(3, #76.byte);
        
        h4.set(0, #C3.byte);
        h4.set(1, #D2.byte);
        h4.set(2, #E1.byte);
        h4.set(3, #F0.byte);
    }
    reset();
    
    shared actual Integer blockSize => 64;
    
    shared actual void compress(Array<Byte> input) {
    }
    
    shared actual Integer outputSize = 5 * 4;
    
    shared actual Array<Byte> done() {
        Array<Byte> output = arrayOfSize(outputSize, 0.byte);
        h0.copyTo(output, 0, 4 * 0);
        h1.copyTo(output, 0, 4 * 1);
        h2.copyTo(output, 0, 4 * 2);
        h3.copyTo(output, 0, 4 * 3);
        h4.copyTo(output, 0, 4 * 4);
        reset();
        return output;
    }
}
