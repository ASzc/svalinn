shared Array<Byte> wordToBytesFor(Integer wordByteSize)(Integer word) {
    Array<Byte> bytes = arrayOfSize(wordByteSize, 0.byte);
    for (i in 0:wordByteSize) {
        bytes.set(i, word.rightLogicalShift((wordByteSize - 1 - i) * 8).byte);
    }
    return bytes;
}

shared Integer circularShiftLeftFor(Integer wordBitSize)(Integer bits, Integer shiftAmount) {
    variable Integer mask = 0;
    for (Integer i in 0:wordBitSize) {
        if (i > 0) {
            mask = mask.leftLogicalShift(1);
        }
        mask = mask.or($1);
    }
    return bits.leftLogicalShift(shiftAmount).or(bits.rightLogicalShift(wordBitSize - shiftAmount)).and(mask);
}

shared Boolean bitwiseEquals(Integer a, Integer b) {
    return a.xor(b) == 0;
}
