import ca.szc.svalinn {
    FixedInputCompressor
}

"Compressor implementing [RFC 3174](https://www.ietf.org/rfc/rfc3174.txt)/
 [FIPS-180-4](http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)
 SHA-1."
shared class Sha1Compressor() satisfies FixedInputCompressor {
    Array<Byte> h0 = arrayOfSize(4, 0.byte);
    Array<Byte> h1 = arrayOfSize(4, 0.byte);
    Array<Byte> h2 = arrayOfSize(4, 0.byte);
    Array<Byte> h3 = arrayOfSize(4, 0.byte);
    Array<Byte> h4 = arrayOfSize(4, 0.byte);
    
    shared actual Integer blockSize = 64;
    shared actual Integer outputSize = 5 * 4;
    
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
    
    Array<Byte> xor(Array<Byte> a, Array<Byte> b) {
        return Array<Byte> {
            for (aByte->bByte in zipEntries(a, b)) aByte.xor(bByte)
        };
    }
    Array<Byte> circularShiftLeft(Array<Byte> a) {
        Byte? leftmostByte = a[0];
        assert (exists leftmostByte);
        
        // TODO have to move the leftmost bit of each byte to the rightmost bit of the byte on the left (mod a.size) ???
        
        // #define SHA1CircularShift(bits,word) (((word) << (bits)) | ((word) >> (32-(bits))))
        
        return Array<Byte> {
            //TODO
        };
    }
    
    shared actual void compress(Array<Byte> input) {
        Integer wordSize = 4;
        
        //Array<Array<Byte>> w = Array<Array<Byte>> {
        //    {for (i in 0:15) arrayOfSize(wordSize, 0.byte)}.chain(
        //    {for (i in 16:79) arrayOfSize(wordSize, 0.byte)});
        //};
        
        Array<Array<Byte>> w = Array<Array<Byte>> {
            { for (i in 0:15) input[i * wordSize : wordSize] }.chain(
                { for (i in 16:79) arrayOfSize(wordSize, 0.byte) });
        };
        for (i in 16:79) {
            // (w[i-3] xor w[i-8] xor w[i-14] xor w[i-16]) leftrotate 1
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
