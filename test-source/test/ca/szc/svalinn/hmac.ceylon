import ca.szc.svalinn {
    Sha1Hmac,
    Sha256Hmac
}
import ceylon.test {
    test,
    assertEquals
}

shared class Sha1HmacTest() {
    "Example #1 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA1.pdf)"
    test
    shared void nistKeyLenEqualBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3d, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #1a, #1b, #1c, #1d, #1e, #1f, #20, #21, #22, #23, #24, #25, #26, #27, #28, #29, #2a, #2b, #2c, #2d, #2e, #2f, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #3a, #3b, #3c, #3d, #3e, #3f }) b.byte };
        Sha1Hmac h = Sha1Hmac(key);
        value expected = Array<Byte> { for (b in { #5f, #d5, #96, #ee, #78, #d5, #55, #3c, #8f, #f4, #e7, #2d, #26, #6d, #fd, #19, #23, #66, #da, #29 }) b.byte };
        assertEquals(h.last(text), expected);
    }
    
    "Example #2 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA1.pdf)"
    test
    shared void nistKeyLenLessThanBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3c, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13 }) b.byte };
        Sha1Hmac h = Sha1Hmac(key);
        value expected = Array<Byte> { for (b in { #4c, #99, #ff, #0c, #b1, #b3, #1b, #d3, #3f, #84, #31, #db, #af, #4d, #17, #fc, #d3, #56, #a8, #07 }) b.byte };
        assertEquals(h.last(text), expected);
    }
    
    "Example #3 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA1.pdf)"
    test
    shared void nistKeyLenGreaterThanBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3d, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #1a, #1b, #1c, #1d, #1e, #1f, #20, #21, #22, #23, #24, #25, #26, #27, #28, #29, #2a, #2b, #2c, #2d, #2e, #2f, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #3a, #3b, #3c, #3d, #3e, #3f, #40, #41, #42, #43, #44, #45, #46, #47, #48, #49, #4a, #4b, #4c, #4d, #4e, #4f, #50, #51, #52, #53, #54, #55, #56, #57, #58, #59, #5a, #5b, #5c, #5d, #5e, #5f, #60, #61, #62, #63 }) b.byte };
        Sha1Hmac h = Sha1Hmac(key);
        value expected = Array<Byte> { for (b in { #2d, #51, #b2, #f7, #75, #0e, #41, #05, #84, #66, #2e, #38, #f1, #33, #43, #5f, #4c, #4f, #d4, #2a }) b.byte };
        assertEquals(h.last(text), expected);
    }
}

shared class Sha256HmacTest() {
    "Example #1 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA256.pdf)"
    test
    shared void nistKeyLenEqualBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3d, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #1a, #1b, #1c, #1d, #1e, #1f, #20, #21, #22, #23, #24, #25, #26, #27, #28, #29, #2a, #2b, #2c, #2d, #2e, #2f, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #3a, #3b, #3c, #3d, #3e, #3f }) b.byte };
        Sha256Hmac h = Sha256Hmac(key);
        value expected = Array<Byte> { for (b in { #8b, #b9, #a1, #db, #98, #06, #f2, #0d, #f7, #f7, #7b, #82, #13, #8c, #79, #14, #d1, #74, #d5, #9e, #13, #dc, #4d, #01, #69, #c9, #05, #7b, #13, #3e, #1d, #62 }) b.byte };
        assertEquals(h.last(text), expected);
    }
    
    "Example #2 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA256.pdf)"
    test
    shared void nistKeyLenLessThanBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3c, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #1a, #1b, #1c, #1d, #1e, #1f }) b.byte };
        Sha256Hmac h = Sha256Hmac(key);
        value expected = Array<Byte> { for (b in { #a2, #8c, #f4, #31, #30, #ee, #69, #6a, #98, #f1, #4a, #37, #67, #8b, #56, #bc, #fc, #bd, #d9, #e5, #cf, #69, #71, #7f, #ec, #f5, #48, #0f, #0e, #bd, #f7, #90 }) b.byte };
        assertEquals(h.last(text), expected);
    }
    
    "Example #3 NIST [NIST]
     (http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/HMAC_SHA256.pdf)"
    test
    shared void nistKeyLenGreaterThanBlockLen() {
        value text = Array<Byte> { for (b in { #53, #61, #6d, #70, #6c, #65, #20, #6d, #65, #73, #73, #61, #67, #65, #20, #66, #6f, #72, #20, #6b, #65, #79, #6c, #65, #6e, #3d, #62, #6c, #6f, #63, #6b, #6c, #65, #6e }) b.byte };
        value key = Array<Byte> { for (b in { #00, #01, #02, #03, #04, #05, #06, #07, #08, #09, #0a, #0b, #0c, #0d, #0e, #0f, #10, #11, #12, #13, #14, #15, #16, #17, #18, #19, #1a, #1b, #1c, #1d, #1e, #1f, #20, #21, #22, #23, #24, #25, #26, #27, #28, #29, #2a, #2b, #2c, #2d, #2e, #2f, #30, #31, #32, #33, #34, #35, #36, #37, #38, #39, #3a, #3b, #3c, #3d, #3e, #3f, #40, #41, #42, #43, #44, #45, #46, #47, #48, #49, #4a, #4b, #4c, #4d, #4e, #4f, #50, #51, #52, #53, #54, #55, #56, #57, #58, #59, #5a, #5b, #5c, #5d, #5e, #5f, #60, #61, #62, #63 }) b.byte };
        Sha256Hmac h = Sha256Hmac(key);
        value expected = Array<Byte> { for (b in { #bd, #cc, #b6, #c7, #2d, #de, #ad, #b5, #00, #ae, #76, #83, #86, #cb, #38, #cc, #41, #c6, #3d, #bb, #08, #78, #dd, #b9, #c7, #a3, #8a, #43, #1b, #78, #37, #8d }) b.byte };
        assertEquals(h.last(text), expected);
    }
}
