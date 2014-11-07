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
    
    Integer b = bits.and(mask);
    Integer s = shiftAmount.remainder(wordBitSize);
    
    return b.leftLogicalShift(s).or(b.rightLogicalShift(wordBitSize - s)).and(mask);
}

shared Integer circularShiftRightFor(Integer wordBitSize)(Integer bits, Integer shiftAmount) {
    variable Integer mask = 0;
    for (Integer i in 0:wordBitSize) {
        if (i > 0) {
            mask = mask.leftLogicalShift(1);
        }
        mask = mask.or($1);
    }
    
    Integer b = bits.and(mask);
    Integer s = shiftAmount.remainder(wordBitSize);
    
    return b.rightLogicalShift(s).or(b.leftLogicalShift(wordBitSize - s)).and(mask);
}

shared Boolean bitwiseEquals(Integer a, Integer b) {
    return a.xor(b) == 0;
}
