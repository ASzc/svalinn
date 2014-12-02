import ca.szc.svalinn.construction {
    Hmac
}

shared class Sha1Hmac(Array<Byte> key) extends Hmac(Sha1, key) {}

shared class Sha256Hmac(Array<Byte> key) extends Hmac(Sha256, key) {}

"Convenience function for [[Sha1Hmac]]. If you need to create multiple MACs, or
 need to stream [[input]], it is more efficient to create and reuse a single
 class instance."
shared Array<Byte> sha1Hmac(Array<Byte> key, Array<Byte> input) {
    return Sha1Hmac(key).last(input);
}

"Convenience function for [[Sha256Hmac]]. If you need to create multiple MACs,
 or need to stream [[input]], it is more efficient to create and reuse a single
 class instance."
shared Array<Byte> sha256Hmac(Array<Byte> key, Array<Byte> input) {
    return Sha1Hmac(key).last(input);
}
