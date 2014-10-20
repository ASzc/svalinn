"A [[CompressionFunction]] that accepts another fixed input in addition to the
 normal input (a key). Types that don't inherit from this interface are
 implicitly unkeyed."
shared interface KeyedHash satisfies CompressionFunction {
    //TODO extract KeyedHash items from Hmac
}
