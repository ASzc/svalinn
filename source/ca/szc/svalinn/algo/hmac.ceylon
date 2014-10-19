import ca.szc.svalinn {
    Hmac
}

shared class Sha1Hmac(Array<Byte> key) extends Hmac(key, Sha1()) {}
//shared class Sha256Hmac(Array<Byte> key) extends Hmac(key, Sha256()) {}
//shared class Sha512Hmac(Array<Byte> key) extends Hmac(key, Sha512()) {}
