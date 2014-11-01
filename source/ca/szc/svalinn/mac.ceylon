import ca.szc.svalinn.construction {
    Hmac
}

shared class Sha1Hmac(Array<Byte> key) extends Hmac(`Sha1`, key) {}
