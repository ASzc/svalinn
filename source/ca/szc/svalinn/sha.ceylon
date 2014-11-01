import ca.szc.svalinn.compressor {
    Sha1Compressor
}
import ca.szc.svalinn.construction {
    MerkleDamgardHash
}

shared class Sha1() extends MerkleDamgardHash(`Sha1Compressor`) {}
