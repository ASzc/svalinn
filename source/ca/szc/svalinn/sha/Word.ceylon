"Arbitrary size binary string for when an Array of Bytes representation doesn't
 provide sufficent resolution."
alias Word => Array<Boolean>;

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
    
    shared Word shiftLeft(Integer shiftSize) {
        return nothing;
    }
    
    shared Word shiftRight(Integer shiftSize) {
        return nothing;
    }
    
    shared Word circularShiftLeft(Integer shiftSize) {
        // #define SHA1CircularShift(bits,Word) (((Word) << (bits)) | ((Word) >> (32-(bits))))
        return nothing;
    }
    
    shared Word circularShiftRight(Integer shiftSize) {
        return nothing;
    }
    
    shared Word add(Word other) {
        return nothing;
    }
}

// TODO functions for big/little endian number extraction?
