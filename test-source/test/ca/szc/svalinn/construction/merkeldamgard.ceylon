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

class TestingFic() satisfies FixedInputCompressor {
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

class TestingMd() extends MerkleDamgardHash(`TestingFic`) {}

class MerkleDamgardHashTest() {
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistOneBlock() {
        TestingMd md = TestingMd();
        md.last(Array<Byte> { #61.byte, #62.byte, #63.byte });
    }
}
