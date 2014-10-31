import ca.szc.svalinn {
    FixedInputCompressor
}

"Compressor implementing [RFC 3174](https://www.ietf.org/rfc/rfc3174.txt)/
 [FIPS-180-4](http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)
 SHA-1."
shared class Sha1Compressor() satisfies FixedInputCompressor {
    // Integer is at least 32 bit length on both JVM and JS
    Integer wordBitSize = 32;
    
    // Constants
    Integer k0 = #5A_82_79_99;
    Integer k1 = #6E_D9_EB_A1;
    Integer k2 = #8F_1B_BC_DC;
    Integer k3 = #CA_62_C1_D6;
    
    // Intermediate hash values
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
        // TODO is an AND mask required?
        return bits.leftLogicalShift(shiftAmount).or(bits.rightLogicalShift(wordBitSize - shiftAmount));
    }
    
    shared actual void compress(Array<Byte> input) {
        assert (input.size == blockSize);
        
        // Will need to eventually store 80 Integer "words"
        Array<Integer> words = arrayOfSize(80, 0);
        
        // Convert 64 byte input block into 16 32-bit/4-byte Integers
        for (i in 0:16) {
            // TODO grab 4 bytes into one Integer in sequence
            
            
            //Integer wordSize = 4;
            //
            //Array<Array<Byte>> w = Array<Array<Byte>> {
            //    { for (i in 0:16) input[i * wordSize : wordSize] }.chain(
            //        { for (i in 16:80) arrayOfSize(wordSize, 0.byte) });
            //};
            
            //for(t = 0; t < 16; t++)
            //{
            //    W[t] = context->Message_Block[t * 4] << 24;
            //    W[t] |= context->Message_Block[t * 4 + 1] << 16;
            //    W[t] |= context->Message_Block[t * 4 + 2] << 8;
            //    W[t] |= context->Message_Block[t * 4 + 3];
            //}
        }
        
        // Expand inital 16 Integers into 80
        for (i in 16:80) {
            Integer? m3 = words[i - 3];
            Integer? m8 = words[i - 8];
            Integer? m14 = words[i - 14];
            Integer? m16 = words[i - 16];
            assert (exists m3, exists m8, exists m14, exists m16);
            
            words.set(i, circularShiftLeft(m3.xor(m8).xor(m14).xor(m16), 1));
        }
        
        variable Integer a = h0;
        variable Integer b = h1;
        variable Integer c = h2;
        variable Integer d = h3;
        variable Integer e = h4;
        
        for (i in 0:20) {
            Integer? w = words.get(i);
            assert(exists w);
            Integer carry = circularShiftLeft(a,5) + ((b.and(c)).or(b.not.and(d))) + e + w + k0;
            e = d;
            d = c;
            c = circularShiftLeft(b, 30);
            b = a;
            a = carry;
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
        
        h0 += a;
        h1 += b;
        h2 += c;
        h3 += d;
        h4 += e;
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
