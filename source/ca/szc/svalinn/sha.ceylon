import ca.szc.svalinn.compressor {
    Sha1Compressor,
    Sha256Compressor,
    Sha512Compressor
}
import ca.szc.svalinn.construction {
    MerkleDamgardHash
}

"A class that implements SHA-1 as specified by [RFC 3174]
 (https://www.ietf.org/rfc/rfc3174.txt)/[FIPS-180-4]
 (http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)."
shared class Sha1() extends MerkleDamgardHash(Sha1Compressor) {}

shared class Sha256() extends MerkleDamgardHash(Sha256Compressor) {}

shared class Sha512() extends MerkleDamgardHash(Sha512Compressor) {}

"Convenience function for [[Sha1]]. If you need to create multiple hashes, or
 need to stream [[input]], it is more efficient to create and reuse a single
 class instance."
shared Array<Byte> sha1(Array<Byte> input) {
    return Sha1().last(input);
}

"Convenience function for [[Sha256]]. If you need to create multiple hashes, or
 need to stream [[input]], it is more efficient to create and reuse a single
 class instance."
shared Array<Byte> sha256(Array<Byte> input) {
    return Sha256().last(input);
}
