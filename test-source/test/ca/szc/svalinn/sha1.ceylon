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
        assertEquals(h.last(Array<Byte> {#61.byte}), expected);
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
