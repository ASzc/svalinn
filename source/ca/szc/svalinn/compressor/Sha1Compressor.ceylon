import ca.szc.svalinn {
    FixedInputCompressor
}

"Compressor implementing [RFC 3174](https://www.ietf.org/rfc/rfc3174.txt)/
 [FIPS-180-4](http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)
 SHA-1."
shared class Sha1Compressor() satisfies FixedInputCompressor {
    // Integer is at least 32 bit length on both JVM and JS
    Integer wordBitSize = 32;
    // Should yield a binary mask of all 1 bits, of length wordBitSize
    Integer circularShiftMask = { for (x in 0..wordBitSize) 2 ^ x }.fold(0)(plus<Integer>);
    
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
    
    Integer(Integer, Integer) circularShiftLeft = circularShiftLeftFor(wordBitSize);
    
    shared actual void compress(Array<Byte> input) {
        assert (input.size == blockSize);
        
        // Will need to eventually store 80 Integer "words"
        Array<Integer> words = arrayOfSize(80, 0);
        
        // Convert 64 byte input block into 16 32-bit/4-byte Integers
        for (i in 0..15) {
            Byte? b1 = input.get(i * 4 + 0);
            Byte? b2 = input.get(i * 4 + 1);
            Byte? b3 = input.get(i * 4 + 2);
            Byte? b4 = input.get(i * 4 + 3);
            assert (exists b1, exists b2, exists b3, exists b4);
            
            Integer i1 = b1.unsigned.leftLogicalShift(24);
            Integer i2 = b2.unsigned.leftLogicalShift(16);
            Integer i3 = b3.unsigned.leftLogicalShift(8);
            Integer i4 = b4.unsigned;
            
            words.set(i, i1.or(i2).or(i3).or(i4));
        }
        
        // Expand inital 16 Integers into 80
        for (i in 16..79) {
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
        
        for (i in 0..19) {
            Integer? w = words.get(i);
            assert (exists w);
            Integer carry = circularShiftLeft(a, 5) + ((b.and(c)).or(b.not.and(d))) + e + w + k0;
            e = d;
            d = c;
            c = circularShiftLeft(b, 30);
            b = a;
            a = carry;
        }
        
        for (i in 20..39) {
            Integer? w = words.get(i);
            assert (exists w);
            Integer carry = circularShiftLeft(a, 5) + (b.xor(c).xor(d)) + e + w + k1;
            e = d;
            d = c;
            c = circularShiftLeft(b, 30);
            b = a;
            a = carry;
        }
        
        for (i in 40..59) {
            Integer? w = words.get(i);
            assert (exists w);
            Integer carry = circularShiftLeft(a, 5) + ((b.and(c)).or(b.and(d)).or(c.and(d))) + e + w + k2;
            e = d;
            d = c;
            c = circularShiftLeft(b, 30);
            b = a;
            a = carry;
        }
        
        for (i in 60..79) {
            Integer? w = words.get(i);
            assert (exists w);
            Integer carry = circularShiftLeft(a, 5) + (b.xor(c).xor(d)) + e + w + k3;
            e = d;
            d = c;
            c = circularShiftLeft(b, 30);
            b = a;
            a = carry;
        }
        
        h0 += a;
        h1 += b;
        h2 += c;
        h3 += d;
        h4 += e;
    }
    
    Array<Byte>(Integer) wordToBytes = wordToBytesFor(wordBitSize / 8);
    
    shared actual Array<Byte> done() {
        Array<Byte> output = arrayOfSize(outputSize, 0.byte);
        
        wordToBytes(h0).copyTo(output, 0, 4 * 0);
        wordToBytes(h1).copyTo(output, 0, 4 * 1);
        wordToBytes(h2).copyTo(output, 0, 4 * 2);
        wordToBytes(h3).copyTo(output, 0, 4 * 3);
        wordToBytes(h4).copyTo(output, 0, 4 * 4);
        
        reset();
        return output;
    }
}
