import ca.szc.svalinn.compressor {
    Sha1Compressor,
    Sha256Compressor
}
import ca.szc.svalinn.construction {
    MerkleDamgardHash
}

"A class that implements SHA-1 as specified by [RFC 3174]
 (https://www.ietf.org/rfc/rfc3174.txt)/[FIPS-180-4]
 (http://csrc.nist.gov/publications/fips/fips180-4/fips-180-4.pdf)."
shared class Sha1() extends MerkleDamgardHash(`Sha1Compressor`) {}

shared class Sha256() extends MerkleDamgardHash(`Sha256Compressor`) {}