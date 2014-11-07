import ca.szc.svalinn.compressor {
    wordToBytesFor,
    circularShiftLeftFor,
    bitwiseEquals,
    circularShiftRightFor
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

Boolean be(Anything a, Anything b) {
    if (is Integer a, is Integer b) {
        return bitwiseEquals(a, b);
    } else {
        return false;
    }
}

class CircularShiftLeftTest() {
    test
    shared void fourByteShift1() {
        Integer(Integer, Integer) csl = circularShiftLeftFor(32);
        assertEquals(csl($0, 1), $0, "0", be);
        assertEquals(csl($1, 1), $10, "1", be);
        assertEquals(csl($10, 1), $100, "2", be);
        assertEquals(csl($11, 1), $110, "3", be);
        assertEquals(csl($0000_0000_0000_0000_1001_1000_0000_0000, 1), $0000_0000_0000_0001_0011_0000_0000_0000, "Middle 1", be);
        assertEquals(csl($0010_0000_1111_0000_0000_0000_0000_0010, 1), $0100_0001_1110_0000_0000_0000_0000_0100, "Middle 2", be);
        assertEquals(csl($0100_0000_0000_0000_0000_0000_0000_0000, 1), $1000_0000_0000_0000_0000_0000_0000_0000, "Ends 1", be);
        assertEquals(csl($0000_0000_0000_0000_0000_0000_1111_1111, 1), $0000_0000_0000_0000_0000_0001_1111_1110, "Ends 2", be);
        assertEquals(csl($1111_1111_0000_0000_0000_0000_0000_0000, 1), $1111_1110_0000_0000_0000_0000_0000_0001, "Ends 3", be);
        assertEquals(csl($1100_0000_0000_0000_0000_0000_0000_0001, 1), $1000_0000_0000_0000_0000_0000_0000_0011, "Ends 4", be);
    }
}

class CircularShiftRightTest() {
    test
    shared void fourByteShift1() {
        Integer(Integer, Integer) csl = circularShiftRightFor(32);
        assertEquals(csl($0, 1), $0, "0", be);
        assertEquals(csl($1, 1), #80_00_00_00, "1", be);
        assertEquals(csl($10, 1), $1, "2", be);
        assertEquals(csl($11, 1), #80_00_00_01, "3", be);
        assertEquals(csl($0000_0000_0000_0000_1001_1000_0000_0000, 1), $0000_0000_0000_0000_0100_1100_0000_0000, "Middle 1", be);
        assertEquals(csl($0010_0000_1111_0000_0000_0000_0000_0010, 1), $0001_0000_0111_1000_0000_0000_0000_0001, "Middle 2", be);
        assertEquals(csl($1000_0000_0000_0000_0000_0000_0000_0000, 1), $0100_0000_0000_0000_0000_0000_0000_0000, "Ends 1", be);
        assertEquals(csl($0000_0000_0000_0000_0000_0000_1111_1111, 1), $1000_0000_0000_0000_0000_0000_0111_1111, "Ends 2", be);
        assertEquals(csl($1111_1111_0000_0000_0000_0000_0000_0000, 1), $0111_1111_1000_0000_0000_0000_0000_0000, "Ends 3", be);
        assertEquals(csl($1100_0000_0000_0000_0000_0000_0000_0001, 1), $1110_0000_0000_0000_0000_0000_0000_0000, "Ends 4", be);
    }
    
    //      a         b        c       d        e         f       g         h
    //16 21da9a9b b0fa238e c0645fde d932eb16 8034229c 07590dcd 0b92f20c 745a48de
    //16 21DA9A9B B0FA238E C0645FDE D932EB16 8034229C 07590DCD 0B92F20C 745A48DE
    //     ..                                   ..
    //17 c2ecd9d1 21da9a9b b0fa238e c0645fde 845fe454 8034229c 07590dcd 0b92f20c
    //17 C2FBD9D1 21DA9A9B B0FA238E C0645FDE 846EE454 8034229C 07590DCD 0B92F20C
    
    test
    shared void sha256_17_b1() {
        Integer(Integer, Integer) csr = circularShiftRightFor(32);
        // Integer b1 = circularShiftRight(e, 6).xor(circularShiftRight(e, 11).xor(circularShiftRight(e, 25)));
        
        // e16 = #8034229C
        Integer e16ini = $1000_0000_0011_0100_0010_0010_1001_1100;
        Integer e16cr6 = $0111_0010_0000_0000_1101_0000_1000_1010;
        Integer e16c11 = $0101_0011_1001_0000_0000_0110_1000_0100;
        Integer e16c25 = $0001_1010_0001_0001_0100_1110_0100_0000;
        assertEquals(csr(e16ini, 6), e16cr6, "6", be);
        assertEquals(csr(e16ini, 11), e16c11, "11", be);
        assertEquals(csr(e16ini, 25), e16c25, "25", be);
    }
    
    test
    shared void sha256_17_b0() {
        Integer(Integer, Integer) csr = circularShiftRightFor(32);
        //Integer b0 = circularShiftRight(a, 2).xor(circularShiftRight(a, 13).xor(circularShiftRight(a, 22)));
        
        // a16 = #21DA9A9B
        Integer a16ini = $0010_0001_1101_1010_1001_1010_1001_1011;
        Integer a16cr6 = $1100_1000_0111_0110_1010_0110_1010_0110;
        Integer a16c13 = $1101_0100_1101_1001_0000_1110_1101_0100;
        Integer a16c25 = $0110_1010_0110_1010_0110_1100_1000_0111;
        assertEquals(csr(a16ini, 2), a16cr6, "2", be);
        assertEquals(csr(a16ini, 13), a16c13, "13", be);
        assertEquals(csr(a16ini, 22), a16c25, "22", be);
    }
}
