"A [[CompressionFunction]] that processes its input in blocks."
shared interface BlockedHash satisfies CompressionFunction {
    "The size (or length) of the internal blocks."
    shared formal Integer blockSize;
}
