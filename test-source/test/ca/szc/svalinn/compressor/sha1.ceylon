import ca.szc.svalinn.compressor {
    Sha1Compressor
}
import ceylon.test {
    test,
    assertThatException,
    assertEquals
}

shared class Sha1CompressorTest() {
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
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistTwoBlock() {
        Sha1Compressor c = Sha1Compressor();
        
        Array<Byte> blockOne = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71, #80, #00, #00, #00, #00, #00, #00, #00 }) b.byte };
        Array<Byte> blockTwo = arrayOfSize(c.blockSize, 0.byte);
        blockTwo.set(c.blockSize - 2, #01.byte);
        blockTwo.set(c.blockSize - 1, #C0.byte);
        
        Array<Byte> expectedOne = Array<Byte> { for (b in { #f4, #28, #68, #18, #c3, #7b, #27, #ae, #04, #08, #f5, #81, #84, #67, #71, #48, #4a, #56, #65, #72 }) b.byte };
        assertEquals(c.last(blockOne), expectedOne);
        
        Array<Byte> expectedTwo = Array<Byte> { for (b in { #84, #98, #3e, #44, #1c, #3b, #d2, #6e, #ba, #ae, #4a, #a1, #f9, #51, #29, #e5, #e5, #46, #70, #f1 }) b.byte };
        c.compress(blockOne);
        assertEquals(c.last(blockTwo), expectedTwo);
    }
}
