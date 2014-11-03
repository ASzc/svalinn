import ca.szc.svalinn {
    FixedInputCompressor
}
import ca.szc.svalinn.construction {
    MerkleDamgardHash
}
import ceylon.test {
    test,
    assertEquals
}

class NistOneBlockFic() satisfies FixedInputCompressor {
    shared actual Integer blockSize => 64;
    
    shared actual void compress(Array<Byte> input) {
        Array<Byte> expected = arrayOfSize(blockSize, 0.byte);
        expected.set(0, #61.byte); // a ASCII
        expected.set(1, #62.byte); // b ASCII
        expected.set(2, #63.byte); // c ASCII
        expected.set(3, #80.byte); // $10000000
        expected.set(blockSize - 1, #18.byte); // $00011000 == 24
        
        assertEquals(input, expected);
    }
    
    shared actual Array<Byte> done() => Array<Byte> { };
    
    shared actual Integer outputSize => 256;
    
    shared actual void reset() {}
}

class NistOneBlockMd() extends MerkleDamgardHash(`NistOneBlockFic`) {}

class NistTwoBlockFic() satisfies FixedInputCompressor {
    shared actual Integer blockSize => 64;
    
    Array<Byte> blockOne = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71, #80, #00, #00, #00, #00, #00, #00, #00 }) b.byte };
    Array<Byte> blockTwo = arrayOfSize(blockSize, 0.byte);
    blockTwo.set(blockSize - 2, #01.byte);
    blockTwo.set(blockSize - 1, #C0.byte);
    
    variable Integer compressCallCount = 0;
    
    shared actual void compress(Array<Byte> input) {
        compressCallCount++;
        if (compressCallCount == 1) {
            assertEquals(input, blockOne);
        } else if (compressCallCount == 2) {
            assertEquals(input, blockTwo);
        } else {
            throw AssertionError("More than two blocks recieved");
        }
    }
    
    shared actual Array<Byte> done() => Array<Byte> { };
    
    shared actual Integer outputSize => 256;
    
    shared actual void reset() {}
}

class NistTwoBlockMd() extends MerkleDamgardHash(`NistTwoBlockFic`) {}

class MerkleDamgardHashTest() {
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistOneBlock() {
        NistOneBlockMd md = NistOneBlockMd();
        md.last(Array<Byte> { #61.byte, #62.byte, #63.byte });
    }
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistTwoBlock() {
        value input = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71 }) b.byte };
        NistTwoBlockMd md = NistTwoBlockMd();
        md.last(input);
    }
}
