import ca.szc.svalinn {
    Hmac
}

shared class Sha1Hmac(Array<Byte>? key=null) extends Hmac(`Sha1`, key) {}
//shared class Sha256Hmac(Array<Byte>? key=null) extends Hmac(`Sha256`, key) {}
//shared class Sha512Hmac(Array<Byte>? key=null) extends Hmac(`Sha512`, key) {}
