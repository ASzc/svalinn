import ceylon.test {
    test,
    assertEquals
}
import ca.szc.svalinn {
    Sha256
}

class Sha256Test() {
    Sha256 h = Sha256();
    
    test
    shared void blank() {
        value expected = Array<Byte> { for (b in { #e3, #b0, #c4, #42, #98, #fc, #1c, #14, #9a, #fb, #f4, #c8, #99, #6f, #b9, #24, #27, #ae, #41, #e4, #64, #9b, #93, #4c, #a4, #95, #99, #1b, #78, #52, #b8, #55 }) b.byte };
        assertEquals(h.last(arrayOfSize(0, 0.byte)), expected);
    }
    
    test
    shared void oneChar() {
        value expected = Array<Byte> { for (b in { #ca, #97, #81, #12, #ca, #1b, #bd, #ca, #fa, #c2, #31, #b3, #9a, #23, #dc, #4d, #a7, #86, #ef, #f8, #14, #7c, #4e, #72, #b9, #80, #77, #85, #af, #ee, #48, #bb }) b.byte };
        assertEquals(h.last(Array<Byte> { #61.byte }), expected);
    }
    
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf)"
    test
    shared void nistOneBlock() {
        value expected = Array<Byte> { for (b in { #ba, #78, #16, #bf, #8f, #01, #cf, #ea, #41, #41, #40, #de, #5d, #ae, #22, #23, #b0, #03, #61, #a3, #96, #17, #7a, #9c, #b4, #10, #ff, #61, #f2, #00, #15, #ad }) b.byte };
        assertEquals(h.last(Array<Byte> { #61.byte, #62.byte, #63.byte }), expected);
    }
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf)"
    test
    shared void nistTwoBlock() {
        value expected = Array<Byte> { for (b in { #24, #8d, #6a, #61, #d2, #06, #38, #b8, #e5, #c0, #26, #93, #0c, #3e, #60, #39, #a3, #3c, #e4, #59, #64, #ff, #21, #67, #f6, #ec, #ed, #d4, #19, #db, #06, #c1 }) b.byte };
        value input = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71 }) b.byte };
        assertEquals(h.last(input), expected);
    }
    
    test
    shared void threeBlocks() {
        value expected = Array<Byte> { for (b in { #e9, #f1, #d7, #04, #c3, #5d, #67, #68, #20, #41, #48, #42, #22, #8d, #d5, #54, #11, #77, #b6, #9f, #01, #04, #e4, #bb, #e2, #0b, #1e, #31, #4f, #a7, #74, #95 }) b.byte };
        // abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopqergegsgtertghrtxcbvxc
        value input = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71, #65, #72, #67, #65, #67, #73, #67, #74, #65, #72, #74, #67, #68, #72, #74, #78, #63, #62, #76, #78, #63 }) b.byte };
        assertEquals(h.last(input), expected);
    }
    
    test
    shared void loremIpsum1Para() {
        value expected = Array<Byte> { for (b in {#9f, #f7, #7d, #34, #ae, #f1, #f6, #ba, #be, #48, #5d, #f6, #a2, #47, #2b, #ce, #1a, #f3, #85, #e4, #49, #7f, #58, #da, #6f, #9d, #3f, #62, #c8, #5c, #f8, #de}) b.byte };
        value input = Array<Byte> { for (b in { #4c, #6f, #72, #65, #6d, #20, #69, #70, #73, #75, #6d, #20, #64, #6f, #6c, #6f, #72, #20, #73, #69, #74, #20, #61, #6d, #65, #74, #2c, #20, #63, #6f, #6e, #73, #65, #63, #74, #65, #74, #75, #72, #20, #61, #64, #69, #70, #69, #73, #63, #69, #6e, #67, #20, #65, #6c, #69, #74, #2e, #20, #44, #6f, #6e, #65, #63, #20, #61, #20, #64, #69, #61, #6d, #20, #6c, #65, #63, #74, #75, #73, #2e, #20, #53, #65, #64, #20, #73, #69, #74, #20, #61, #6d, #65, #74, #20, #69, #70, #73, #75, #6d, #20, #6d, #61, #75, #72, #69, #73, #2e, #20, #4d, #61, #65, #63, #65, #6e, #61, #73, #20, #63, #6f, #6e, #67, #75, #65, #20, #6c, #69, #67, #75, #6c, #61, #20, #61, #63, #20, #71, #75, #61, #6d, #20, #76, #69, #76, #65, #72, #72, #61, #20, #6e, #65, #63, #20, #63, #6f, #6e, #73, #65, #63, #74, #65, #74, #75, #72, #20, #61, #6e, #74, #65, #20, #68, #65, #6e, #64, #72, #65, #72, #69, #74, #2e, #20, #44, #6f, #6e, #65, #63, #20, #65, #74, #20, #6d, #6f, #6c, #6c, #69, #73, #20, #64, #6f, #6c, #6f, #72, #2e, #20, #50, #72, #61, #65, #73, #65, #6e, #74, #20, #65, #74, #20, #64, #69, #61, #6d, #20, #65, #67, #65, #74, #20, #6c, #69, #62, #65, #72, #6f, #20, #65, #67, #65, #73, #74, #61, #73, #20, #6d, #61, #74, #74, #69, #73, #20, #73, #69, #74, #20, #61, #6d, #65, #74, #20, #76, #69, #74, #61, #65, #20, #61, #75, #67, #75, #65, #2e, #20, #4e, #61, #6d, #20, #74, #69, #6e, #63, #69, #64, #75, #6e, #74, #20, #63, #6f, #6e, #67, #75, #65, #20, #65, #6e, #69, #6d, #2c, #20, #75, #74, #20, #70, #6f, #72, #74, #61, #20, #6c, #6f, #72, #65, #6d, #20, #6c, #61, #63, #69, #6e, #69, #61, #20, #63, #6f, #6e, #73, #65, #63, #74, #65, #74, #75, #72, #2e, #20, #44, #6f, #6e, #65, #63, #20, #75, #74, #20, #6c, #69, #62, #65, #72, #6f, #20, #73, #65, #64, #20, #61, #72, #63, #75, #20, #76, #65, #68, #69, #63, #75, #6c, #61, #20, #75, #6c, #74, #72, #69, #63, #69, #65, #73, #20, #61, #20, #6e, #6f, #6e, #20, #74, #6f, #72, #74, #6f, #72, #2e, #20, #4c, #6f, #72, #65, #6d, #20, #69, #70, #73, #75, #6d, #20, #64, #6f, #6c, #6f, #72, #20, #73, #69, #74, #20, #61, #6d, #65, #74, #2c, #20, #63, #6f, #6e, #73, #65, #63, #74, #65, #74, #75, #72, #20, #61, #64, #69, #70, #69, #73, #63, #69, #6e, #67, #20, #65, #6c, #69, #74, #2e, #20, #41, #65, #6e, #65, #61, #6e, #20, #75, #74, #20, #67, #72, #61, #76, #69, #64, #61, #20, #6c, #6f, #72, #65, #6d, #2e, #20, #55, #74, #20, #74, #75, #72, #70, #69, #73, #20, #66, #65, #6c, #69, #73, #2c, #20, #70, #75, #6c, #76, #69, #6e, #61, #72, #20, #61, #20, #73, #65, #6d, #70, #65, #72, #20, #73, #65, #64, #2c, #20, #61, #64, #69, #70, #69, #73, #63, #69, #6e, #67, #20, #69, #64, #20, #64, #6f, #6c, #6f, #72, #2e, #20, #50, #65, #6c, #6c, #65, #6e, #74, #65, #73, #71, #75, #65, #20, #61, #75, #63, #74, #6f, #72, #20, #6e, #69, #73, #69, #20, #69, #64, #20, #6d, #61, #67, #6e, #61, #20, #63, #6f, #6e, #73, #65, #71, #75, #61, #74, #20, #73, #61, #67, #69, #74, #74, #69, #73, #2e, #20, #43, #75, #72, #61, #62, #69, #74, #75, #72, #20, #64, #61, #70, #69, #62, #75, #73, #20, #65, #6e, #69, #6d, #20, #73, #69, #74, #20, #61, #6d, #65, #74, #20, #65, #6c, #69, #74, #20, #70, #68, #61, #72, #65, #74, #72, #61, #20, #74, #69, #6e, #63, #69, #64, #75, #6e, #74, #20, #66, #65, #75, #67, #69, #61, #74, #20, #6e, #69, #73, #6c, #20, #69, #6d, #70, #65, #72, #64, #69, #65, #74, #2e, #20, #55, #74, #20, #63, #6f, #6e, #76, #61, #6c, #6c, #69, #73, #20, #6c, #69, #62, #65, #72, #6f, #20, #69, #6e, #20, #75, #72, #6e, #61, #20, #75, #6c, #74, #72, #69, #63, #65, #73, #20, #61, #63, #63, #75, #6d, #73, #61, #6e, #2e, #20, #44, #6f, #6e, #65, #63, #20, #73, #65, #64, #20, #6f, #64, #69, #6f, #20, #65, #72, #6f, #73, #2e, #20, #44, #6f, #6e, #65, #63, #20, #76, #69, #76, #65, #72, #72, #61, #20, #6d, #69, #20, #71, #75, #69, #73, #20, #71, #75, #61, #6d, #20, #70, #75, #6c, #76, #69, #6e, #61, #72, #20, #61, #74, #20, #6d, #61, #6c, #65, #73, #75, #61, #64, #61, #20, #61, #72, #63, #75, #20, #72, #68, #6f, #6e, #63, #75, #73, #2e, #20, #43, #75, #6d, #20, #73, #6f, #63, #69, #69, #73, #20, #6e, #61, #74, #6f, #71, #75, #65, #20, #70, #65, #6e, #61, #74, #69, #62, #75, #73, #20, #65, #74, #20, #6d, #61, #67, #6e, #69, #73, #20, #64, #69, #73, #20, #70, #61, #72, #74, #75, #72, #69, #65, #6e, #74, #20, #6d, #6f, #6e, #74, #65, #73, #2c, #20, #6e, #61, #73, #63, #65, #74, #75, #72, #20, #72, #69, #64, #69, #63, #75, #6c, #75, #73, #20, #6d, #75, #73, #2e, #20, #49, #6e, #20, #72, #75, #74, #72, #75, #6d, #20, #61, #63, #63, #75, #6d, #73, #61, #6e, #20, #75, #6c, #74, #72, #69, #63, #69, #65, #73, #2e, #20, #4d, #61, #75, #72, #69, #73, #20, #76, #69, #74, #61, #65, #20, #6e, #69, #73, #69, #20, #61, #74, #20, #73, #65, #6d, #20, #66, #61, #63, #69, #6c, #69, #73, #69, #73, #20, #73, #65, #6d, #70, #65, #72, #20, #61, #63, #20, #69, #6e, #20, #65, #73, #74, #2e }) b.byte };
        assertEquals(h.last(input), expected);
    }
}