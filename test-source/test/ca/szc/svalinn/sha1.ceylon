import ca.szc.svalinn {
    Sha1
}
import ceylon.test {
    test,
    assertEquals
}

class Sha1Test() {
    Sha1 h = Sha1();
    
    test
    shared void blank() {
        value expected = Array<Byte> { for (b in { #da, #39, #a3, #ee, #5e, #6b, #4b, #0d, #32, #55, #bf, #ef, #95, #60, #18, #90, #af, #d8, #07, #09 }) b.byte };
        assertEquals(h.last(arrayOfSize(0, 0.byte)), expected);
    }
    
    test
    shared void oneChar() {
        value expected = Array<Byte> { for (b in { #86, #f7, #e4, #37, #fa, #a5, #a7, #fc, #e1, #5d, #1d, #dc, #b9, #ea, #ea, #ea, #37, #76, #67, #b8 }) b.byte };
        assertEquals(h.last(Array<Byte> { #61.byte }), expected);
    }
    
    "Example #1 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistOneBlock() {
        value expected = Array<Byte> { for (b in { #a9, #99, #3e, #36, #47, #06, #81, #6a, #ba, #3e, #25, #71, #78, #50, #c2, #6c, #9c, #d0, #d8, #9d }) b.byte };
        assertEquals(h.last(Array<Byte> { #61.byte, #62.byte, #63.byte }), expected);
    }
    
    "Example #2 from [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA1.pdf)"
    test
    shared void nistTwoBlock() {
        value expected = Array<Byte> { for (b in { #84, #98, #3e, #44, #1c, #3b, #d2, #6e, #ba, #ae, #4a, #a1, #f9, #51, #29, #e5, #e5, #46, #70, #f1 }) b.byte };
        value input = Array<Byte> { for (b in { #61, #62, #63, #64, #62, #63, #64, #65, #63, #64, #65, #66, #64, #65, #66, #67, #65, #66, #67, #68, #66, #67, #68, #69, #67, #68, #69, #6a, #68, #69, #6a, #6b, #69, #6a, #6b, #6c, #6a, #6b, #6c, #6d, #6b, #6c, #6d, #6e, #6c, #6d, #6e, #6f, #6d, #6e, #6f, #70, #6e, #6f, #70, #71 }) b.byte };
        assertEquals(h.last(input), expected);
    }
    
    //test
    //shared void firstBlock() {
    //    //assertEquals(h.last(arra), expected, message, (Anything val1, Anything val2) => nothing);
    //}
    //
    //test
    //shared void lastBlock() {
    //}
}
