import ca.szc.svalinn {
    FixedInputCompressor
}

"Compressor implementing [RFC 3174](https://www.ietf.org/rfc/rfc3174.txt)/
 [FIPS-180-4](http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)
 SHA-1."
shared class Sha1Compressor() satisfies FixedInputCompressor {
    // Integer is at least 32 bit length on both JVM and JS
    Integer wordBitSize = 32;
    variable Integer h0 = #67_45_23_01;
    variable Integer h1 = #EF_CD_AB_89;
    variable Integer h2 = #98_BA_DC_FE;
    variable Integer h3 = #10_32_54_76;
    variable Integer h4 = #C3_D2_E1_F0;
    
    shared actual Integer blockSize = 64;
    shared actual Integer outputSize = 5 * 4;
    
    shared actual void reset() {
        // Magic initial values as defined in the spec
        h0 = #67_45_23_01;
        h1 = #EF_CD_AB_89;
        h2 = #98_BA_DC_FE;
        h3 = #10_32_54_76;
        h4 = #C3_D2_E1_F0;
    }
    
    Integer circularShiftLeft(Integer bits, Integer shiftAmount) {
        return bits.leftLogicalShift(shiftAmount).or(bits.rightLogicalShift(wordBitSize - shiftAmount));
    }
    
    shared actual void compress(Array<Byte> input) {
        Integer wordSize = 4;
        // TODO Integers are at least 32 bits on JS and JVM, so use them for now
        
        Array<Array<Byte>> w = Array<Array<Byte>> {
            { for (i in 0:16) input[i * wordSize : wordSize] }.chain(
                { for (i in 16:80) arrayOfSize(wordSize, 0.byte) });
        };
        for (i in 16:80) {
            Array<Byte>? m3 = w[i - 3];
            Array<Byte>? m8 = w[i - 8];
            Array<Byte>? m14 = w[i - 14];
            Array<Byte>? m16 = w[i - 16];
            assert (exists m3, exists m8, exists m14, exists m16);
            
            w.set(i, circularShiftLeft(xor(m3, xor(m8, xor(m14, m16)))));
        }
        
        Array<Byte> a = h0.clone();
        Array<Byte> b = h1.clone();
        Array<Byte> c = h2.clone();
        Array<Byte> d = h3.clone();
        Array<Byte> e = h4.clone();
        
        for (i in 0:20) {
            // TODO
        }
        
        for (i in 20:40) {
            // TODO
        }
        
        for (i in 40:60) {
            // TODO
        }
        
        for (i in 60:80) {
            // TODO
        }
        
        // TODO
    }
    
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

shared void bitDemo() {
    print(runtime.integerSize);
    Integer intSizeGuess = 32;
    //Integer x = $1010000000000000000000000000000000000000000000000000000000000000;
    Integer x = $00001101;
    Integer y = 13;
    print(x);
    print(y);
    Integer shift = 30;
    Integer xCircularShiftedLeft = x.leftLogicalShift(shift).or(x.rightLogicalShift(intSizeGuess - shift));
    {Integer*} bits = [for (i in 0 .. intSizeGuess - 1) xCircularShiftedLeft.rightLogicalShift(intSizeGuess - i).and($00000001)];
    print("".join(bits));
}
