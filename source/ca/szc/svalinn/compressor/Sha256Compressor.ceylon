import ca.szc.svalinn {
    FixedInputCompressor
}

class Sha256Compressor() satisfies FixedInputCompressor {
    Integer wordBitSize = 32;
    
    Integer[] constants = [
    ];
    // TODO
    //428a2f98 71374491 b5c0fbcf e9b5dba5
    //3956c25b 59f111f1 923f82a4 ab1c5ed5
    //d807aa98 12835b01 243185be 550c7dc3
    //72be5d74 80deb1fe 9bdc06a7 c19bf174
    //e49b69c1 efbe4786 0fc19dc6 240ca1cc
    //2de92c6f 4a7484aa 5cb0a9dc 76f988da
    //983e5152 a831c66d b00327c8 bf597fc7
    //c6e00bf3 d5a79147 06ca6351 14292967
    //27b70a85 2e1b2138 4d2c6dfc 53380d13
    //650a7354 766a0abb 81c2c92e 92722c85
    //a2bfe8a1 a81a664b c24b8b70 c76c51a3
    //d192e819 d6990624 f40e3585 106aa070
    //19a4c116 1e376c08 2748774c 34b0bcb5
    //391c0cb3 4ed8aa4a 5b9cca4f 682e6ff3
    //748f82ee 78a5636f 84c87814 8cc70208
    //90befffa a4506ceb bef9a3f7 c67178f2
    
    // Intermediate hash values
    variable Integer h0 = #c1_05_9e_d8;
    variable Integer h1 = #36_7c_d5_07;
    variable Integer h2 = #30_70_dd_17;
    variable Integer h3 = #f7_0e_59_39;
    variable Integer h4 = #ff_c0_0b_31;
    variable Integer h5 = #68_58_15_11;
    variable Integer h6 = #64_f9_8f_a7;
    variable Integer h7 = #be_fa_4f_a4;
    
    shared actual Integer blockSize => 64;
    shared actual Integer outputSize => 8 * 4;
    
    shared actual void reset() {
        h0 = #c1_05_9e_d8;
        h1 = #36_7c_d5_07;
        h2 = #30_70_dd_17;
        h3 = #f7_0e_59_39;
        h4 = #ff_c0_0b_31;
        h5 = #68_58_15_11;
        h6 = #64_f9_8f_a7;
        h7 = #be_fa_4f_a4;
    }
    
    shared actual void compress(Array<Byte> input) {
        assert (input.size == blockSize);
        
        Array<Integer> words = arrayOfSize(63, 0);
        
        // TODO
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
