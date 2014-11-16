import ca.szc.svalinn {
    FixedInputCompressor
}

shared class Sha512Compressor() satisfies FixedInputCompressor {
    Integer wordBitSize;
    if (runtime.integerAddressableSize >= 64) {
        wordBitSize = 64;
    } else {
        wordBitSize = 32;
    }
    
    Array<Integer> constants;
    if (wordBitSize == 32) {
        constants = Array<Integer> {
            #428A2F98, #D728AE22, #71374491, #23EF65CD, #B5C0FBCF,
            #EC4D3B2F, #E9B5DBA5, #8189DBBC, #3956C25B, #F348B538,
            #59F111F1, #B605D019, #923F82A4, #AF194F9B, #AB1C5ED5,
            #DA6D8118, #D807AA98, #A3030242, #12835B01, #45706FBE,
            #243185BE, #4EE4B28C, #550C7DC3, #D5FFB4E2, #72BE5D74,
            #F27B896F, #80DEB1FE, #3B1696B1, #9BDC06A7, #25C71235,
            #C19BF174, #CF692694, #E49B69C1, #9EF14AD2, #EFBE4786,
            #384F25E3, #0FC19DC6, #8B8CD5B5, #240CA1CC, #77AC9C65,
            #2DE92C6F, #592B0275, #4A7484AA, #6EA6E483, #5CB0A9DC,
            #BD41FBD4, #76F988DA, #831153B5, #983E5152, #EE66DFAB,
            #A831C66D, #2DB43210, #B00327C8, #98FB213F, #BF597FC7,
            #BEEF0EE4, #C6E00BF3, #3DA88FC2, #D5A79147, #930AA725,
            #06CA6351, #E003826F, #14292967, #0A0E6E70, #27B70A85,
            #46D22FFC, #2E1B2138, #5C26C926, #4D2C6DFC, #5AC42AED,
            #53380D13, #9D95B3DF, #650A7354, #8BAF63DE, #766A0ABB,
            #3C77B2A8, #81C2C92E, #47EDAEE6, #92722C85, #1482353B,
            #A2BFE8A1, #4CF10364, #A81A664B, #BC423001, #C24B8B70,
            #D0F89791, #C76C51A3, #0654BE30, #D192E819, #D6EF5218,
            #D6990624, #5565A910, #F40E3585, #5771202A, #106AA070,
            #32BBD1B8, #19A4C116, #B8D2D0C8, #1E376C08, #5141AB53,
            #2748774C, #DF8EEB99, #34B0BCB5, #E19B48A8, #391C0CB3,
            #C5C95A63, #4ED8AA4A, #E3418ACB, #5B9CCA4F, #7763E373,
            #682E6FF3, #D6B2B8A3, #748F82EE, #5DEFB2FC, #78A5636F,
            #43172F60, #84C87814, #A1F0AB72, #8CC70208, #1A6439EC,
            #90BEFFFA, #23631E28, #A4506CEB, #DE82BDE9, #BEF9A3F7,
            #B2C67915, #C67178F2, #E372532B, #CA273ECE, #EA26619C,
            #D186B8C7, #21C0C207, #EADA7DD6, #CDE0EB1E, #F57D4F7F,
            #EE6ED178, #06F067AA, #72176FBA, #0A637DC5, #A2C898A6,
            #113F9804, #BEF90DAE, #1B710B35, #131C471B, #28DB77F5,
            #23047D84, #32CAAB7B, #40C72493, #3C9EBE0A, #15C9BEBC,
            #431D67C4, #9C100D4C, #4CC5D4BE, #CB3E42B6, #597F299C,
            #FC657E2A, #5FCB6FAB, #3AD6FAEC, #6C44198C, #4A475817
        };
    } else {
        constants = Array<Integer> {
            #428A2F98D728AE22, #7137449123EF65CD, #B5C0FBCFEC4D3B2F,
            #E9B5DBA58189DBBC, #3956C25BF348B538, #59F111F1B605D019,
            #923F82A4AF194F9B, #AB1C5ED5DA6D8118, #D807AA98A3030242,
            #12835B0145706FBE, #243185BE4EE4B28C, #550C7DC3D5FFB4E2,
            #72BE5D74F27B896F, #80DEB1FE3B1696B1, #9BDC06A725C71235,
            #C19BF174CF692694, #E49B69C19EF14AD2, #EFBE4786384F25E3,
            #0FC19DC68B8CD5B5, #240CA1CC77AC9C65, #2DE92C6F592B0275,
            #4A7484AA6EA6E483, #5CB0A9DCBD41FBD4, #76F988DA831153B5,
            #983E5152EE66DFAB, #A831C66D2DB43210, #B00327C898FB213F,
            #BF597FC7BEEF0EE4, #C6E00BF33DA88FC2, #D5A79147930AA725,
            #06CA6351E003826F, #142929670A0E6E70, #27B70A8546D22FFC,
            #2E1B21385C26C926, #4D2C6DFC5AC42AED, #53380D139D95B3DF,
            #650A73548BAF63DE, #766A0ABB3C77B2A8, #81C2C92E47EDAEE6,
            #92722C851482353B, #A2BFE8A14CF10364, #A81A664BBC423001,
            #C24B8B70D0F89791, #C76C51A30654BE30, #D192E819D6EF5218,
            #D69906245565A910, #F40E35855771202A, #106AA07032BBD1B8,
            #19A4C116B8D2D0C8, #1E376C085141AB53, #2748774CDF8EEB99,
            #34B0BCB5E19B48A8, #391C0CB3C5C95A63, #4ED8AA4AE3418ACB,
            #5B9CCA4F7763E373, #682E6FF3D6B2B8A3, #748F82EE5DEFB2FC,
            #78A5636F43172F60, #84C87814A1F0AB72, #8CC702081A6439EC,
            #90BEFFFA23631E28, #A4506CEBDE82BDE9, #BEF9A3F7B2C67915,
            #C67178F2E372532B, #CA273ECEEA26619C, #D186B8C721C0C207,
            #EADA7DD6CDE0EB1E, #F57D4F7FEE6ED178, #06F067AA72176FBA,
            #0A637DC5A2C898A6, #113F9804BEF90DAE, #1B710B35131C471B,
            #28DB77F523047D84, #32CAAB7B40C72493, #3C9EBE0A15C9BEBC,
            #431D67C49C100D4C, #4CC5D4BECB3E42B6, #597F299CFC657E2A,
            #5FCB6FAB3AD6FAEC, #6C44198C4A475817
        };
    }
    
    shared actual Integer blockSize => 128;
    shared actual Integer outputSize => 64;
    
    variable Array<Integer> intermediate;
    if (wordBitSize == 32) {
        intermediate = Array<Integer> {
            #6A09E667, #F3BCC908, #BB67AE85, #84CAA73B, #3C6EF372,
            #FE94F82B, #A54FF53A, #5F1D36F1, #510E527F, #ADE682D1,
            #9B05688C, #2B3E6C1F, #1F83D9AB, #FB41BD6B, #5BE0CD19,
            #137E2179
        };
    } else {
        intermediate = Array<Integer> {
            #6A09E667F3BCC908, #BB67AE8584CAA73B, #3C6EF372FE94F82B,
            #A54FF53A5F1D36F1, #510E527FADE682D1, #9B05688C2B3E6C1F,
            #1F83D9ABFB41BD6B, #5BE0CD19137E2179
        };
    }
    
    shared actual void reset() {
        if (wordBitSize == 32) {
            intermediate = Array<Integer> {
                #6A09E667, #F3BCC908, #BB67AE85, #84CAA73B, #3C6EF372,
                #FE94F82B, #A54FF53A, #5F1D36F1, #510E527F, #ADE682D1,
                #9B05688C, #2B3E6C1F, #1F83D9AB, #FB41BD6B, #5BE0CD19,
                #137E2179
            };
        } else {
            intermediate = Array<Integer> {
                #6A09E667F3BCC908, #BB67AE8584CAA73B, #3C6EF372FE94F82B,
                #A54FF53A5F1D36F1, #510E527FADE682D1, #9B05688C2B3E6C1F,
                #1F83D9ABFB41BD6B, #5BE0CD19137E2179
            };
        }
    }
    
    Integer(Integer, Integer) circularShiftRight = circularShiftRightFor(wordBitSize);
    value shiftRightTwoInt = shiftRightTwoIntFor(32);
    value circularShiftRightTwoInt = circularShiftRightTwoIntFor(32);
    value addTwoInt = addTwoIntFor(32);
    
    shared actual void compress(Array<Byte> input) {
        assert (input.size == blockSize);
        
        if (wordBitSize == 32) {
            Array<Integer> words = arrayOfSize(80 * 2, 0);
            
            // Convert 128 byte input block into 32 32-bit/4-byte Integers
            for (i in 0..31) {
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
            
            // Expand inital 32 Integers into 160
            for (i in (32..159).by(2)) {
                value m2 = makeTwoInt(words[i - 2], words[i - 2 + 1]);
                value m7 = makeTwoInt(words[i - 7], words[i - 7 + 1]);
                value m15 = makeTwoInt(words[i - 15], words[i - 15 + 1]);
                value m16 = makeTwoInt(words[i - 16], words[i - 16 + 1]);
                
                value s1 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(m2, 19), circularShiftRightTwoInt(m2, 61)), shiftRightTwoInt(m2, 6));
                value s0 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(m15, 1), circularShiftRightTwoInt(m15, 8)), shiftRightTwoInt(m15, 7));
                
                value w = addTwoInt(addTwoInt(addTwoInt(s1, m7), s0), m16);
                words.set(i, w[0]);
                words.set(i + 1, w[1]);
            }
            
            variable value a = makeTwoInt(intermediate.get(0), intermediate.get(1));
            variable value b = makeTwoInt(intermediate.get(2), intermediate.get(3));
            variable value c = makeTwoInt(intermediate.get(4), intermediate.get(5));
            variable value d = makeTwoInt(intermediate.get(6), intermediate.get(7));
            variable value e = makeTwoInt(intermediate.get(8), intermediate.get(9));
            variable value f = makeTwoInt(intermediate.get(10), intermediate.get(11));
            variable value g = makeTwoInt(intermediate.get(12), intermediate.get(13));
            variable value h = makeTwoInt(intermediate.get(14), intermediate.get(15));
            
            String toHex(Integer input) => "".join { for (i in (7..0)) formatInteger(input.rightLogicalShift(i * 4).and($1111), 16) };
            String fH([Integer, Integer] x) => toHex(x[0]) + "_" + toHex(x[1]);
            
            for (i in 0..79) {
                value w = makeTwoInt(words.get(i * 2), words.get(i * 2 + 1));
                value k = makeTwoInt(constants.get(i * 2), constants.get(i * 2 + 1));
                
                value b1 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(e, 14), circularShiftRightTwoInt(e, 18)), circularShiftRightTwoInt(e, 41));
                value ch = xorTwoInt(andTwoInt(e, f), andTwoInt(notTwoInt(e), g));
                value carry1 = addTwoInt(addTwoInt(addTwoInt(addTwoInt(h, b1), ch), k), w);
                
                value b0 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(a, 28), circularShiftRightTwoInt(a, 34)), circularShiftRightTwoInt(a, 39));
                value maj = xorTwoInt(xorTwoInt(andTwoInt(a, b), andTwoInt(a, c)), andTwoInt(b, c));
                value carry2 = addTwoInt(b0, maj);
                
                h = g;
                g = f;
                f = e;
                e = addTwoInt(d, carry1);
                d = c;
                c = b;
                b = a;
                a = addTwoInt(carry1, carry2);
                
                print(" ".join { i, fH(w), fH(a), fH(b), fH(c), fH(d), fH(e), fH(f), fH(g), fH(h) });
            }
            
            value h0 = makeTwoInt(intermediate.get(0), intermediate.get(1));
            value h0P = addTwoInt(h0, a);
            intermediate.set(0, h0P[0]);
            intermediate.set(1, h0P[1]);
            
            value h1 = makeTwoInt(intermediate.get(2), intermediate.get(3));
            value h1P = addTwoInt(h1, b);
            intermediate.set(2, h1P[0]);
            intermediate.set(3, h1P[1]);
            
            value h2 = makeTwoInt(intermediate.get(4), intermediate.get(5));
            value h2P = addTwoInt(h2, c);
            intermediate.set(4, h2P[0]);
            intermediate.set(5, h2P[1]);
            
            value h3 = makeTwoInt(intermediate.get(6), intermediate.get(7));
            value h3P = addTwoInt(h3, d);
            intermediate.set(4, h3P[0]);
            intermediate.set(5, h3P[1]);
            
            value h4 = makeTwoInt(intermediate.get(8), intermediate.get(9));
            value h4P = addTwoInt(h4, e);
            intermediate.set(4, h4P[0]);
            intermediate.set(5, h4P[1]);
            
            value h5 = makeTwoInt(intermediate.get(10), intermediate.get(11));
            value h5P = addTwoInt(h5, f);
            intermediate.set(4, h5P[0]);
            intermediate.set(5, h5P[1]);
            
            value h6 = makeTwoInt(intermediate.get(12), intermediate.get(13));
            value h6P = addTwoInt(h6, g);
            intermediate.set(4, h6P[0]);
            intermediate.set(5, h6P[1]);
            
            value h7 = makeTwoInt(intermediate.get(14), intermediate.get(15));
            value h7P = addTwoInt(h7, h);
            intermediate.set(4, h7P[0]);
            intermediate.set(5, h7P[1]);
        } else {
            Array<Integer> words = arrayOfSize(80, 0);
            
            // Convert 128 byte input block into 16 64-bit/8-byte Integers
            for (i in 0..15) {
                Byte? b1 = input.get(i * 8 + 0);
                Byte? b2 = input.get(i * 8 + 1);
                Byte? b3 = input.get(i * 8 + 2);
                Byte? b4 = input.get(i * 8 + 3);
                Byte? b5 = input.get(i * 8 + 4);
                Byte? b6 = input.get(i * 8 + 5);
                Byte? b7 = input.get(i * 8 + 6);
                Byte? b8 = input.get(i * 8 + 7);
                assert (exists b1, exists b2, exists b3, exists b4, exists b5, exists b6, exists b7, exists b8);
                
                Integer i1 = b1.unsigned.leftLogicalShift(56);
                Integer i2 = b2.unsigned.leftLogicalShift(48);
                Integer i3 = b3.unsigned.leftLogicalShift(40);
                Integer i4 = b4.unsigned.leftLogicalShift(32);
                Integer i5 = b5.unsigned.leftLogicalShift(24);
                Integer i6 = b6.unsigned.leftLogicalShift(16);
                Integer i7 = b7.unsigned.leftLogicalShift(8);
                Integer i8 = b8.unsigned;
                
                words.set(i, i1.or(i2).or(i3).or(i4).or(i5).or(i6).or(i7).or(i8));
            }
            
            Integer mask = #FF_FF_FF_FF_FF_FF_FF_FF;
            
            // Expand inital 16 Integers into 80
            
            // TODO
            
            variable Integer? aI = intermediate.get(0);
            variable Integer? bI = intermediate.get(1);
            variable Integer? cI = intermediate.get(2);
            variable Integer? dI = intermediate.get(3);
            variable Integer? eI = intermediate.get(4);
            variable Integer? fI = intermediate.get(5);
            variable Integer? gI = intermediate.get(6);
            variable Integer? hI = intermediate.get(7);
            
            assert (exists a = aI, exists b = bI, exists c = cI, exists d = dI, exists e = eI, exists f = fI, exists g = gI, exists h = hI);
            
            // TODO
        }
    }
    
    Array<Byte>(Integer) wordToBytes = wordToBytesFor(wordBitSize / 8);
    
    shared actual Array<Byte> done() {
        Array<Byte> output = arrayOfSize(outputSize, 0.byte);
        
        if (wordBitSize == 32) {
            for (i in 0..15) {
                Integer? w = intermediate.get(i);
                assert (exists w);
                wordToBytes(w).copyTo(output, 0, 4 * i);
            }
        } else {
            for (i in 0..7) {
                Integer? w = intermediate.get(i);
                assert (exists w);
                wordToBytes(w).copyTo(output, 0, 8 * i);
            }
        }
        
        reset();
        return output;
    }
}
