"An interface for functions (algorithms) that produce a fixed length output."
shared interface Compressor {
    "The size (or length) of the [[Array]] returned by [[done]]. i.e. the
     number of [[Byte]]s in the output."
    shared formal Integer outputSize;
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time."
    shared formal void reset();
    
    "Finishes the function computation and returns the output (of size
     [[outputSize]]), then calls [[reset]]."
    shared formal Array<Byte> done();
}

"An interface for [[Compressor]]s that accept input of a fixed (blocked) size."
shared interface FixedInputCompressor satisfies Blocked & Compressor {
    "Provide a new block of size [[blockSize]]"
    shared formal void compress(Array<Byte> input);
    
    "Convience method for calling [[compress]] then [[done]]."
    shared default Array<Byte> last(Array<Byte> input) {
        compress(input);
        return done();
    }
}

"An interface for [[Compressor]]s that accept a finite, arbitrary sized input."
shared interface VariableInputCompressor satisfies Compressor {
    "Provide more of the input to the algorithm. Multiple calls are equivalent
     to one call with a concatenated [[input]]."
    shared formal void more(Array<Byte> input);
    
    "Convience method for calling [[more]] then [[done]]."
    shared default Array<Byte> last(Array<Byte> input) {
        more(input);
        return done();
    }
}

"A [[VariableInputCompressor]] that processes its input in blocks."
shared interface BlockedVariableInputCompressor satisfies VariableInputCompressor & Blocked {
}

"A [[VariableInputCompressor]] that uses a key."
shared interface KeyedVariableInputCompressor satisfies VariableInputCompressor & Keyed {
}
