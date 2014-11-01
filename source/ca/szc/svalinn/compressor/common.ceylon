shared Array<Byte> wordToBytesFor(Integer wordByteSize)(Integer word) {
    Array<Byte> bytes = arrayOfSize(wordByteSize, 0.byte);
    for (i in 0:wordByteSize) {
        bytes.set(i, word.rightLogicalShift((wordByteSize - 1 - i) * 8).byte);
    }
    return bytes;
}

shared Integer circularShiftLeftFor(Integer wordBitSize)(Integer bits, Integer shiftAmount) {
    Integer circularShiftMask = { for (x in 0:wordBitSize) 2 ^ x }.fold(0)(plus<Integer>);
    return bits.leftLogicalShift(shiftAmount).or(bits.rightLogicalShift(wordBitSize - shiftAmount)).and(circularShiftMask);
}

shared Boolean bitwiseEquals(Integer a, Integer b) {
    return a.xor(b) == 0;
}
