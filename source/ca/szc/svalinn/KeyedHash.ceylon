"A [[CompressionFunction]] that accepts another fixed input in addition to the
 normal input (a key). Types that don't inherit from this interface are
 implicitly unkeyed."
shared interface KeyedHash satisfies CompressionFunction {
    "Prepare the object to be reused. Restores the object to the state it had
     at creation time, except with a new [[key]]."
    shared formal void newKey(Array<Byte> key);
}
