import ca.szc.svalinn.compressor {
    wordToBytesFor,
    circularShiftLeftFor,
    bitwiseEquals,
    circularShiftRightFor,
    circularShiftRightTwoIntFor
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
        throw Exception("be was called with a non-Integer");
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

Boolean btie(Anything a, Anything b) {
    if (is [Integer, Integer] a, is [Integer, Integer] b) {
        return bitwiseEquals(a[0], b[0]) && bitwiseEquals(a[1], b[1]);
    } else {
        throw Exception("btie was called with a non-tuple");
    }
}

shared class CircularShiftRightTwoIntTest() {
    test
    shared void fourByteShift1() {
        value csr = circularShiftRightTwoIntFor(32);
        assertEquals(csr([$0, $0], 1), [$0, $0], "0", btie);
        assertEquals(csr([$0, $1], 1), [#8000_0000, $0], "1", btie);
        assertEquals(csr([$0, $10], 1), [$0, $1], "2", btie);
        assertEquals(csr([$0, $11], 1), [#8000_0000, $1], "3", btie);
        
        assertEquals(csr([#8000_0000, $101], 1), [#C000_0000, $10], "Ends 1", btie);
    }
    
    String toBits(Integer input) => "".join { for (i in 0:32) input.rightLogicalShift(32 - 1 - i).and($1) };
    
    String fH([Integer, Integer] x) => toBits(x[0]) + "_" + toBits(x[1]);
    
    test
    shared void sha512_0_b1() {
        value csr = circularShiftRightTwoIntFor(32);
        //value b1 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(e, 14), circularShiftRightTwoInt(e, 18)), circularShiftRightTwoInt(e, 41));
        
        // e0 = [#510E527F, #ADE682D1]
        value e0ini = [$01010001000011100101001001111111, $10101101111001101000001011010001];
        value e0c14 = [$00001011010001010100010000111001, $01001001111111101011011110011010];
        value e0c18 = [$10100000101101000101010001000011, $10010100100111111110101101111001];
        value e0c41 = [$00111111110101101111001101000001, $01101000101010001000011100101001];
        print("e0ini: " + fH(e0ini));
        print("");
        print("e0c14: " + fH(e0c14));
        print("csr14: " + fH(csr(e0ini, 14)));
        print("");
        print("e0c18: " + fH(e0c18));
        print("csr18: " + fH(csr(e0ini, 18)));
        print("");
        print("e0c41: " + fH(e0c41));
        print("csr41: " + fH(csr(e0ini, 41)));
        print("");
        assertEquals(csr(e0ini, 14), e0c14, "14", btie);
        assertEquals(csr(e0ini, 18), e0c18, "18", btie);
        assertEquals(csr(e0ini, 41), e0c41, "41", btie);
    }
    
    test
    shared void sha512_0_b0() {
        value csr = circularShiftRightTwoIntFor(32);
        //value b0 = xorTwoInt(xorTwoInt(circularShiftRightTwoInt(a, 28), circularShiftRightTwoInt(a, 34)), circularShiftRightTwoInt(a, 39));
        
        // a0 = [#6A09E667, #F3BCC908]
        value a0ini = [$01101010000010011110011001100111, $11110011101111001100100100001000];
        value a0c28 = [$00111011110011001001000010000110, $10100000100111100110011001111111];
        value a0c34 = [$11111100111011110011001001000010, $00011010100000100111100110011001];
        value a0c39 = [$11001111111001110111100110010010, $00010000110101000001001111001100];
        print("a0ini: " + fH(a0ini));
        print("");
        print("a0c28: " + fH(a0c28));
        print("csr28: " + fH(csr(a0ini, 28)));
        print("");
        print("a0c34: " + fH(a0c34));
        print("csr34: " + fH(csr(a0ini, 34)));
        print("");
        print("a0c39: " + fH(a0c39));
        print("csr39: " + fH(csr(a0ini, 39)));
        print("");
        assertEquals(csr(a0ini, 28), a0c28, "28", btie);
        assertEquals(csr(a0ini, 34), a0c34, "34", btie);
        assertEquals(csr(a0ini, 39), a0c39, "39", btie);
    }
}
