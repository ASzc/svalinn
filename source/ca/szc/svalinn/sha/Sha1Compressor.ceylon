import ca.szc.svalinn {
    FixedInputCompressor
}

shared class Sha1Compressor() satisfies FixedInputCompressor {
    shared actual Integer blockSize => nothing;
    
    shared actual void compress(Array<Byte> input) {}
    
    shared actual Array<Byte> done() => nothing;
    
    shared actual Integer outputSize => nothing;
    
    shared actual void reset() {}
}
