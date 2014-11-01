import ca.szc.svalinn {
    FixedInputCompressor
}
import ca.szc.svalinn.construction {
    MerkleDamgardHash
}

class TestingFic() satisfies FixedInputCompressor {
    shared actual Integer blockSize => nothing;
    
    shared actual void compress(Array<Byte> input) {}
    
    shared actual Array<Byte> done() => nothing;
    
    shared actual Integer outputSize => nothing;
    
    shared actual void reset() {}
}

class TestingMd() extends MerkleDamgardHash(`TestingFic`) {}

class MerkleDamgardHashTest() {
    TestingMd md = TestingMd();
}
