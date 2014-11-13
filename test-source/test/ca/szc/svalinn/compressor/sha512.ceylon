import ca.szc.svalinn.compressor {
    Sha512Compressor
}
import ceylon.test {
    test,
    assertThatException,
    assertEquals
}

shared class Sha512CompressorTest() {
    test
    shared void undersizeCompress() {
        Sha512Compressor c = Sha512Compressor();
        assertThatException(() => c.compress(arrayOfSize(0, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize - 1, 0.byte))).hasType(`AssertionError`);
    }
    
    test
    shared void oversizeCompress() {
        Sha512Compressor c = Sha512Compressor();
        assertThatException(() => c.compress(arrayOfSize(c.blockSize + 1, 0.byte))).hasType(`AssertionError`);
        assertThatException(() => c.compress(arrayOfSize(c.blockSize * 2, 0.byte))).hasType(`AssertionError`);
    }
    
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA512.pdf)"
    test
    shared void nistOneBlock() {
        Sha512Compressor c = Sha512Compressor();
        Array<Byte> block = arrayOfSize(c.blockSize, 0.byte);
        block.set(0, #61.byte); // a ASCII
        block.set(1, #62.byte); // b ASCII
        block.set(2, #63.byte); // c ASCII
        block.set(3, #80.byte); // $10000000
        block.set(c.blockSize - 1, #18.byte); // $00011000 == 24
        
        Array<Byte> result = c.last(block);
        Array<Byte> expected = Array<Byte> { for (b in { #dd, #af, #35, #a1, #93, #61, #7a, #ba, #cc, #41, #73, #49, #ae, #20, #41, #31, #12, #e6, #fa, #4e, #89, #a9, #7e, #a2, #0a, #9e, #ee, #e6, #4b, #55, #d3, #9a, #21, #92, #99, #2a, #27, #4f, #c1, #a8, #36, #ba, #3c, #23, #a3, #fe, #eb, #bd, #45, #4d, #44, #23, #64, #3c, #e8, #0e, #2a, #9a, #c9, #4f, #a5, #4c, #a4, #9f }) b.byte };
        assertEquals(result, expected);
    }
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA512.pdf)"
    test
    shared void nistTwoBlock() {
        Sha512Compressor c = Sha512Compressor();
        
        Array<Byte> blockOne = Array<Byte> { for (b in { #61, #62, #63, #64, #65, #66, #67, #68, #62, #63, #64, #65, #66, #67, #68, #69, #63, #64, #65, #66, #67, #68, #69, #6a, #64, #65, #66, #67, #68, #69, #6a, #6b, #65, #66, #67, #68, #69, #6a, #6b, #6c, #66, #67, #68, #69, #6a, #6b, #6c, #6d, #67, #68, #69, #6a, #6b, #6c, #6d, #6e, #68, #69, #6a, #6b, #6c, #6d, #6e, #6f, #69, #6a, #6b, #6c, #6d, #6e, #6f, #70, #6a, #6b, #6c, #6d, #6e, #6f, #70, #71, #6b, #6c, #6d, #6e, #6f, #70, #71, #72, #6c, #6d, #6e, #6f, #70, #71, #72, #73, #6d, #6e, #6f, #70, #71, #72, #73, #74, #6e, #6f, #70, #71, #72, #73, #74, #75, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00, #00 }) b.byte };
        Array<Byte> blockTwo = arrayOfSize(c.blockSize, 0.byte);
        blockTwo.set(c.blockSize - 2, #03.byte);
        blockTwo.set(c.blockSize - 1, #80.byte);
        
        Array<Byte> expectedOne = Array<Byte> { for (b in { #43, #19, #01, #7a, #2b, #70, #6e, #69, #cd, #4b, #05, #93, #8b, #ae, #5e, #89, #01, #86, #bf, #19, #9f, #30, #aa, #95, #6e, #f8, #b7, #1d, #2f, #81, #05, #85, #d7, #87, #d6, #76, #4b, #20, #bd, #a2, #a2, #60, #14, #47, #09, #73, #69, #20, #00, #ec, #05, #7f, #37, #d1, #4b, #8e, #06, #ad, #d5, #b5, #0e, #67, #1c, #72 }) b.byte };
        assertEquals(c.last(blockOne), expectedOne);
        
        Array<Byte> expectedTwo = Array<Byte> { for (b in { #8e, #95, #9b, #75, #da, #e3, #13, #da, #8c, #f4, #f7, #28, #14, #fc, #14, #3f, #8f, #77, #79, #c6, #eb, #9f, #7f, #a1, #72, #99, #ae, #ad, #b6, #88, #90, #18, #50, #1d, #28, #9e, #49, #00, #f7, #e4, #33, #1b, #99, #de, #c4, #b5, #43, #3a, #c7, #d3, #29, #ee, #b6, #dd, #26, #54, #5e, #96, #e5, #5b, #87, #4b, #e9, #09 }) b.byte };
        c.compress(blockOne);
        assertEquals(c.last(blockTwo), expectedTwo);
    }
}
