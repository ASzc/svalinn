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

shared [Integer, Integer] shiftRightTwoIntFor(Integer wordBitSize)([Integer, Integer] bits, Integer shiftAmount) {
    Integer shiftedHigh;
    if (0 <= shiftAmount < wordBitSize) {
        shiftedHigh = bits[0].rightLogicalShift(shiftAmount);
    } else {
        shiftedHigh = 0;
    }
    
    Integer shiftedLow;
    if (shiftAmount > wordBitSize) {
        shiftedLow = bits[0].rightLogicalShift(shiftAmount - wordBitSize);
    } else if (shiftAmount == wordBitSize) {
        shiftedLow = bits[0];
    } else if (shiftAmount >= 0) {
        shiftedLow = bits[0].leftLogicalShift(wordBitSize - shiftAmount).or(bits[1].rightLogicalShift(shiftAmount));
    } else {
        shiftedLow = 0;
    }
    
    return [shiftedHigh, shiftedLow];
}

shared [Integer, Integer] shiftLeftTwoIntFor(Integer wordBitSize)([Integer, Integer] bits, Integer shiftAmount) {
    Integer shiftedHigh;
    if (shiftAmount > wordBitSize) {
        shiftedHigh = bits[1].leftLogicalShift(shiftAmount - wordBitSize);
    } else if (shiftAmount == wordBitSize) {
        shiftedHigh = bits[1];
    } else if (shiftAmount >= 0) {
        shiftedHigh = bits[0].leftLogicalShift(shiftAmount).or(bits[1].rightLogicalShift(wordBitSize - shiftAmount));
    } else {
        shiftedHigh = 0;
    }
    
    Integer shiftedLow;
    if (0 <= shiftAmount < wordBitSize) {
        shiftedLow = bits[1].leftLogicalShift(shiftAmount);
    } else {
        shiftedLow = 0;
    }
    
    return [shiftedHigh, shiftedLow];
}

shared [Integer, Integer] circularShiftRightTwoIntFor(Integer wordBitSize)([Integer, Integer] bits, Integer shiftAmount) {
    value shiftRightTwoInt = shiftRightTwoIntFor(wordBitSize);
    value shiftLeftTwoInt = shiftLeftTwoIntFor(wordBitSize);
    
    variable Integer mask = 0;
    for (Integer i in 0:wordBitSize) {
        if (i > 0) {
            mask = mask.leftLogicalShift(1);
        }
        mask = mask.or($1);
    }
    
    value bitsMasked = [bits[0].and(mask), bits[1].and(mask)];
    
    value r = shiftRightTwoInt(bitsMasked, shiftAmount);
    Integer rbH = r[0].and(mask);
    Integer rbL = r[1].and(mask);
    
    value l = shiftLeftTwoInt(bitsMasked, wordBitSize * 2 - shiftAmount);
    Integer lbH = l[0].and(mask);
    Integer lbL = l[1].and(mask);
    
    Integer cH = rbH.or(lbH);
    Integer cL = rbL.or(lbL);
    
    return [cH.and(mask), cL.and(mask)];
}

shared Integer bitwiseAdd(Integer a, Integer b) {
    variable Integer carry = a.and(b);
    variable Integer result = a.xor(b);
    while (carry != 0) {
        Integer shiftedcarry = carry.leftLogicalShift(1);
        carry = result.and(shiftedcarry);
        result = result.xor(shiftedcarry);
    }
    return result;
}

shared [Integer, Integer] addTwoIntFor(Integer wordBitSize)([Integer, Integer] one, [Integer, Integer] two) {
    //Integer aL = bitwiseAdd(one[1], two[1]);
    Integer aL = one[1] + two[1];
    // Did aL overflow?
    Integer carry;
    if (aL < one[1]) {
        carry = 1;
    } else {
        carry = 0;
    }
    //Integer aH = bitwiseAdd(bitwiseAdd(one[0], two[0]), carry);
    Integer aH = one[0] + two[0] + carry;
    
    return [aH, aL];
}

shared [Integer, Integer] xorTwoInt([Integer, Integer] one, [Integer, Integer] two) {
    return [one[0].xor(two[0]), one[1].xor(two[1])];
}

shared [Integer, Integer] notTwoInt([Integer, Integer] one) {
    return [one[0].not, one[1].not];
}

shared [Integer, Integer] andTwoInt([Integer, Integer] one, [Integer, Integer] two) {
    return [one[0].and(two[0]), one[1].and(two[1])];
}

shared [Integer, Integer] makeTwoInt(Integer? one, Integer? two) {
    assert (exists one, exists two);
    return [one, two];
}
