import ca.szc.svalinn.construction {
    Hmac
}

shared class Sha1Hmac(Array<Byte> key) extends Hmac(Sha1, key) {}

shared class Sha256Hmac(Array<Byte> key) extends Hmac(Sha256, key) {}
