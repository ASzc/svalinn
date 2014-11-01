import ca.szc.svalinn.compressor {
    Sha1Compressor
}

import ceylon.test {
    test,
    assertThatException,
    assertEquals
}

class Sha1CompressorTest() {
    test
    shared void undersizeCompress() {
        Sha1Compressor c = Sha1Compressor();
        assertThatException(() => c.compress(arrayOfSize(0, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize - 1, 0.byte))).hasType(`AssertionError`);
    }
    
    test
    shared void oversizeCompress() {
        Sha1Compressor c = Sha1Compressor();
        assertThatException(() => c.compress(arrayOfSize(c.blockSize + 1, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize * 2, 0.byte))).hasType(`AssertionError`);
    }
    
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistOneBlock() {
        Sha1Compressor c = Sha1Compressor();
        Array<Byte> block = arrayOfSize(c.blockSize, 0.byte);
        block.set(0, #61.byte); // a ASCII
        block.set(1, #62.byte); // b ASCII
        block.set(2, #63.byte); // c ASCII
        block.set(3, #80.byte); // $10000000
        block.set(c.blockSize - 1, #18.byte); // $00011000 == 24
        
        Array<Byte> result = c.last(block);
        Array<Byte> expected = Array<Byte> { for (b in { #a9, #99, #3e, #36, #47, #06, #81, #6a, #ba, #3e, #25, #71, #78, #50, #c2, #6c, #9c, #d0, #d8, #9d }) b.byte };
        assertEquals(result, expected);
    }
}
