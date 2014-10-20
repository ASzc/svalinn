import ca.szc.svalinn {
    MerkleDamgardHash
}

shared class Sha1() extends MerkleDamgardHash() {
    shared actual Integer blockSize => nothing;
    
    shared actual Array<Byte> done() => nothing;
    
    shared actual void more(Array<Byte> input) {}
    
    shared actual Integer outputSize => nothing;
    
    shared actual void reset() {}
}
