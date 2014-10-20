"An interface for functions (algorithms) that accept a finite, arbitrary sized
 input and produce a fixed length output."
shared interface CompressionFunction {
    "The size (or length) of the [[Array]] returned by [[done]] and [[last]].
     i.e. the number of [[Byte]]s in the output."
    shared formal Integer outputSize;
    
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time."
    shared formal void reset();
    
    "Provide more of the input to the algorithm. Multiple calls are equivalent
     to one call with a concatenated [[input]]."
    shared formal void more(Array<Byte> input);
    
    "Finishes the function computation and returns the output (of size
     [[outputSize]]), then calls [[reset]]. May perform final operations such
     as input padding."
    shared formal Array<Byte> done();
    
    "Convience method for calling [[more]] then [[done]]."
    shared default Array<Byte> last(Array<Byte> input) {
        more(input);
        return done();
    }
}
