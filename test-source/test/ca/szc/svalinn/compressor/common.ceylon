import ca.szc.svalinn.compressor {
    wordToBytesFor,
    circularShiftLeftFor
}
import ceylon.test {
    test,
    assertEquals
}

class WordToBytesTest() {
    test
    shared void fourByte() {
        Array<Byte>(Integer) wtb = wordToBytesFor(4);
        assertEquals(wtb(#80), Array<Byte> { for (b in { #00, #00, #00, #80 }) b.byte });
        assertEquals(wtb(#01FF), Array<Byte> { for (b in { #00, #00, #01, #FF }) b.byte });
        assertEquals(wtb(#EF8001), Array<Byte> { for (b in { #00, #EF, #80, #01 }) b.byte });
        assertEquals(wtb(#10000000), Array<Byte> { for (b in { #10, #00, #00, #00 }) b.byte });
        assertEquals(wtb(#0180000000), Array<Byte> { for (b in { #80, #00, #00, #00 }) b.byte });
    }
}

class CircularShiftLeftTest() {
    test
    shared void fourByteShift1() {
        Integer(Integer, Integer) csl = circularShiftLeftFor(32);
        assertEquals(csl($0, 1), $0, "0");
        assertEquals(csl($1, 1), $10, "1");
        assertEquals(csl($10, 1), $100, "2");
        assertEquals(csl($11, 1), $110, "3");
        assertEquals(csl($0000_0000_0000_0000_1001_1000_0000_0000, 1), $0000_0000_0000_0001_0011_0000_0000_0000, "Middle 1");
        assertEquals(csl($0010_0000_1111_0000_0000_0000_0000_0010, 1), $0100_0001_1110_0000_0000_0000_0000_0100, "Middle 2");
        assertEquals(csl($0100_0000_0000_0000_0000_0000_0000_0000, 1), $1000_0000_0000_0000_0000_0000_0000_0000, "Ends 1");
        assertEquals(csl($0000_0000_0000_0000_0000_0000_1111_1111, 1), $0000_0000_0000_0000_0000_0001_1111_1110, "Ends 2");
        assertEquals(csl($1111_1111_0000_0000_0000_0000_0000_0000, 1), $1111_1110_0000_0000_0000_0000_0000_0001, "Ends 3");
        assertEquals(csl($1100_0000_0000_0000_0000_0000_0000_0001, 1), $1000_0000_0000_0000_0000_0000_0000_0011, "Ends 4");
    }
}
