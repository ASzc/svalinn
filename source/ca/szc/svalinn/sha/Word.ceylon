"Arbitrary size binary string for when an Array of Bytes representation doesn't
 provide sufficent resolution."
alias Word => Array<Boolean>;

"In place (mutator) bitwise operations"
object mutbitops {
}

"Non-mutator bitwise operations"
object bitops {
    shared Word and(Word first, Word second) {
        return Array<Boolean> { for (a->b in zipEntries(first, second)) a && b };
    }
    
    shared Word xor(Word first, Word second) {
        return Array<Boolean> { for (a->b in zipEntries(first, second)) a != b };
    }
    
    shared Word or(Word first, Word second) {
        return Array<Boolean> { for (a->b in zipEntries(first, second)) a || b };
    }
    
    shared Word not(Word bits) {
        return Array<Boolean> { for (b in bits) !b };
    }
    
    shared Word shiftLeft(Word bits, Integer shiftSize) {
        {Boolean*} seq = bits.chain({ false }.cycled).skip(shiftSize);
        return Array<Boolean> { for (b in seq.take(bits.size)) b };
    }
    
    shared Word shiftRight(Word bits, Integer shiftSize) {
        {Boolean*} seq = expand { { false }.cycled.take(shiftSize), bits };
        return Array<Boolean> { for (b in seq.take(bits.size)) b };
    }
    
    shared Word circularShiftLeft(Word bits, Integer shiftSize) {
        {Boolean*} seq = bits.cycled.skip(shiftSize);
        return Array<Boolean> { for (b in seq.take(bits.size)) b };
    }
    
    shared Word circularShiftRight(Word bits, Integer shiftSize) {
        {Boolean*} seq = expand { bits.terminal(shiftSize), bits };
        return Array<Boolean> { for (b in seq.take(bits.size)) b };
    }
    
    shared Word add(Word first, Word second) {
        variable Word carry = and(first, second);
        variable Word result = xor(first, second);
        while (!isZero(carry)) {
            Word shiftedcarry = shiftLeft(carry, 1);
            carry = and(result, shiftedcarry);
            result = xor(result, shiftedcarry);
        }
        return result;
    }
    
    shared Boolean isZero(Word bits) {
        return { for (b in bits) b }.every((Boolean element) => !element);
    }
}

shared void test() {
    Array<Boolean> a = Array<Boolean> { false, true, false, false, true };
    print(a);
    print(bitops.circularShiftLeft(a, 0));
    print(bitops.circularShiftLeft(a, 1));
    print(bitops.circularShiftLeft(a, 2));
    print(bitops.circularShiftRight(a, 0));
    print(bitops.circularShiftRight(a, 1));
    print(bitops.circularShiftRight(a, 2));
    print("");
    Array<Boolean> b = Array<Boolean> { true, false, true };
    print(a);
    print(b);
    print(bitops.add(a, b));
    print(bitops.add(a, a));
}
