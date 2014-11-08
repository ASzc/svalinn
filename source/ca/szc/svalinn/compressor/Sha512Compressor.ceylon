import ca.szc.svalinn {
    FixedInputCompressor
}

class Sha512Compressor() satisfies FixedInputCompressor {
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
    
    shared actual void compress(Array<Byte> input) {
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
