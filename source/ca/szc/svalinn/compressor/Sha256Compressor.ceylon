import ca.szc.svalinn {
    FixedInputCompressor
}

shared class Sha256Compressor() satisfies FixedInputCompressor {
    Integer wordBitSize = 32;
    
    Array<Integer> constants = Array<Integer> {
        #428a2f98, #71374491, #b5c0fbcf, #e9b5dba5,
        #3956c25b, #59f111f1, #923f82a4, #ab1c5ed5,
        #d807aa98, #12835b01, #243185be, #550c7dc3,
        #72be5d74, #80deb1fe, #9bdc06a7, #c19bf174,
        #e49b69c1, #efbe4786, #0fc19dc6, #240ca1cc,
        #2de92c6f, #4a7484aa, #5cb0a9dc, #76f988da,
        #983e5152, #a831c66d, #b00327c8, #bf597fc7,
        #c6e00bf3, #d5a79147, #06ca6351, #14292967,
        #27b70a85, #2e1b2138, #4d2c6dfc, #53380d13,
        #650a7354, #766a0abb, #81c2c92e, #92722c85,
        #a2bfe8a1, #a81a664b, #c24b8b70, #c76c51a3,
        #d192e819, #d6990624, #f40e3585, #106aa070,
        #19a4c116, #1e376c08, #2748774c, #34b0bcb5,
        #391c0cb3, #4ed8aa4a, #5b9cca4f, #682e6ff3,
        #748f82ee, #78a5636f, #84c87814, #8cc70208,
        #90befffa, #a4506ceb, #bef9a3f7, #c67178f2
    };
    
    // Intermediate hash values
    variable Integer h0 = #6a09e667;
    variable Integer h1 = #bb67ae85;
    variable Integer h2 = #3c6ef372;
    variable Integer h3 = #a54ff53a;
    variable Integer h4 = #510e527f;
    variable Integer h5 = #9b05688c;
    variable Integer h6 = #1f83d9ab;
    variable Integer h7 = #5be0cd19;
    
    shared actual Integer blockSize => 64;
    shared actual Integer outputSize => 8 * 4;
    
    shared actual void reset() {
        h0 = #6a09e667;
        h1 = #bb67ae85;
        h2 = #3c6ef372;
        h3 = #a54ff53a;
        h4 = #510e527f;
        h5 = #9b05688c;
        h6 = #1f83d9ab;
        h7 = #5be0cd19;
    }
    
    Integer(Integer, Integer) circularShiftRight = circularShiftRightFor(wordBitSize);
    
    shared actual void compress(Array<Byte> input) {
        assert (input.size == blockSize);
        
        Array<Integer> words = arrayOfSize(64, 0);
        
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
        
        Integer mask = #FF_FF_FF_FF;
        
        // Expand inital 16 Integers into 64
        for (i in 16..63) {
            Integer? m2 = words[i - 3];
            Integer? m7 = words[i - 8];
            Integer? m15 = words[i - 14];
            Integer? m16 = words[i - 16];
            assert (exists m2, exists m7, exists m15, exists m16);
            
            Integer s1 = circularShiftRight(m2, 17).xor(circularShiftRight(m2, 19).xor(m2.rightLogicalShift(10)));
            Integer s0 = circularShiftRight(m15, 7).xor(circularShiftRight(m15, 18).xor(m15.rightLogicalShift(3)));
            
            words.set(i, (((s1 + m7).and(mask) + s0).and(mask) + m16).and(mask));
        }
        
        variable Integer a = h0;
        variable Integer b = h1;
        variable Integer c = h2;
        variable Integer d = h3;
        variable Integer e = h4;
        variable Integer f = h5;
        variable Integer g = h6;
        variable Integer h = h7;
        
        String fH(Integer x) => formatInteger(x, 16).padLeading(8, '0');
        
        Integer ba(Integer a, Integer b) {
            variable Integer carry = a.and(b);
            variable Integer result = a.xor(b);
            while (carry != 0) {
                Integer shiftedcarry = carry.leftLogicalShift(1);
                carry = result.and(shiftedcarry);
                result = result.xor(shiftedcarry);
            }
            return result;
        }
        
        for (i in 0..63) {
            Integer? w = words.get(i);
            Integer? k = constants.get(i);
            assert (exists w, exists k);
            
            Integer b1 = circularShiftRight(e, 6).xor(circularShiftRight(e, 11).xor(circularShiftRight(e, 25)));
            Integer ch = (e.and(f)).xor(e.not.and(g));
            Integer carry1 = ba(ba(ba(ba(h, b1).and(mask), ch).and(mask), k).and(mask), w).and(mask);
            
            Integer b0 = circularShiftRight(a, 2).xor(circularShiftRight(a, 13).xor(circularShiftRight(a, 22)));
            Integer maj = (a.and(b)).xor(a.and(c)).xor(b.and(c));
            Integer carry2 = ba(b0, maj).and(mask);
            
            h = g;
            g = f;
            f = e;
            e = ba(d, carry1).and(mask);
            d = c;
            c = b;
            b = a;
            a = ba(carry1, carry2).and(mask);
            
            print(" ".join { i, fH(a), fH(b), fH(c), fH(d), fH(e), fH(f), fH(g), fH(h) });
        }
        
        h0 = (h0 + a).and(mask);
        h1 = (h1 + b).and(mask);
        h2 = (h2 + c).and(mask);
        h3 = (h3 + d).and(mask);
        h4 = (h4 + e).and(mask);
        h5 = (h5 + f).and(mask);
        h6 = (h6 + g).and(mask);
        h7 = (h7 + h).and(mask);
    }
    
    Array<Byte>(Integer) wordToBytes = wordToBytesFor(wordBitSize / 8);
    
    shared actual Array<Byte> done() {
        Array<Byte> output = arrayOfSize(outputSize, 0.byte);
        
        wordToBytes(h0).copyTo(output, 0, 4 * 0);
        wordToBytes(h1).copyTo(output, 0, 4 * 1);
        wordToBytes(h2).copyTo(output, 0, 4 * 2);
        wordToBytes(h3).copyTo(output, 0, 4 * 3);
        wordToBytes(h4).copyTo(output, 0, 4 * 4);
        wordToBytes(h5).copyTo(output, 0, 4 * 5);
        wordToBytes(h6).copyTo(output, 0, 4 * 6);
        wordToBytes(h7).copyTo(output, 0, 4 * 7);
        
        reset();
        return output;
    }
}
