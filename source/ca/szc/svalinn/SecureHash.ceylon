"An interface for applying secure hash (message digest) algorithms
 to arbitrary size input (a message) to produce a fixed length output."
interface SecureHash {
    "The size (or length) of the [[Array]] returned by [[done]] and [[last]]"
    shared formal Integer outputSize;
    "The size (or length) of the internal blocks"
    shared formal Integer blockSize;
    
    "Prepare the object to be reused. Restores the object to the state it had at creation time."
    shared formal void reset();
    
    "Provide more of the input to the algorithm. Multiple calls are equivalent
     to one call with a concatenated [[input]]"
    shared formal void more(Array<Byte> input);
    
    "Finishes the hash computation and returns the hash (of size
     [[outputSize]]), then calls [[reset]]. May perform final operations such
     as input padding."
    shared formal Array<Byte> done();
    
    "Convience method for calling [[more]] then [[done]]."
    shared default Array<Byte> last(Array<Byte> input) {
        more(input);
        return done();
    }
}
