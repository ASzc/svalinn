import ca.szc.svalinn.compressor {
    Sha256Compressor
}
import ceylon.test {
    test,
    assertThatException,
    assertEquals
}

shared class Sha256CompressorTest() {
    test
    shared void undersizeCompress() {
        Sha256Compressor c = Sha256Compressor();
        assertThatException(() => c.compress(arrayOfSize(0, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize - 1, 0.byte))).hasType(`AssertionError`);
    }
    
    test
    shared void oversizeCompress() {
        Sha256Compressor c = Sha256Compressor();
        assertThatException(() => c.compress(arrayOfSize(c.blockSize + 1, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize * 2, 0.byte))).hasType(`AssertionError`);
    }
    
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf)"
    test
    shared void nistOneBlock() {
        Sha256Compressor c = Sha256Compressor();
        Array<Byte> block = arrayOfSize(c.blockSize, 0.byte);
        block.set(0, #61.byte); // a ASCII
        block.set(1, #62.byte); // b ASCII
        block.set(2, #63.byte); // c ASCII
        block.set(3, #80.byte); // $10000000
        block.set(c.blockSize - 1, #18.byte); // $00011000 == 24
        
        Array<Byte> result = c.last(block);
        Array<Byte> expected = Array<Byte> { for (b in { #ba, #78, #16, #bf, #8f, #01, #cf, #ea, #41, #41, #40, #de, #5d, #ae, #22, #23, #b0, #03, #61, #a3, #96, #17, #7a, #9c, #b4, #10, #ff, #61, #f2, #00, #15, #ad }) b.byte };
        assertEquals(result, expected);
    }
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf)"
    test
    shared void nistTwoBlock() {
        Sha256Compressor c = Sha256Compressor();
        
        Array<Byte> blockOne = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71, #80, #00, #00, #00, #00, #00, #00, #00 }) b.byte };
        Array<Byte> blockTwo = arrayOfSize(c.blockSize, 0.byte);
        blockTwo.set(c.blockSize - 2, #01.byte);
        blockTwo.set(c.blockSize - 1, #C0.byte);
        
        Array<Byte> expectedOne = Array<Byte> { for (b in { #85, #e6, #55, #d6, #41, #7a, #17, #95, #33, #63, #37, #6a, #62, #4c, #de, #5c, #76, #e0, #95, #89, #ca, #c5, #f8, #11, #cc, #4b, #32, #c1, #f2, #0e, #53, #3a }) b.byte };
        assertEquals(c.last(blockOne), expectedOne);
        
        Array<Byte> expectedTwo = Array<Byte> { for (b in { #24, #8d, #6a, #61, #d2, #06, #38, #b8, #e5, #c0, #26, #93, #0c, #3e, #60, #39, #a3, #3c, #e4, #59, #64, #ff, #21, #67, #f6, #ec, #ed, #d4, #19, #db, #06, #c1 }) b.byte };
        c.compress(blockOne);
        assertEquals(c.last(blockTwo), expectedTwo);
    }
}
