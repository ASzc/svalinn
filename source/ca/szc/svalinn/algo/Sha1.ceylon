import ca.szc.svalinn {
    SecureHash
}

class Sha1() satisfies SecureHash {
    shared actual Integer blockSize => nothing;
    
    shared actual Array<Byte> done() => nothing;
    
    shared actual void more(Array<Byte> input) {}
    
    shared actual Integer outputSize => nothing;
    
    shared actual void reset() {}
}
