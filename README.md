# Svalinn - A cryptography library for Ceylon

Svalinn is written in pure [Ceylon](http://ceylon-lang.org/), so it will not restrict you to a particular target of the Ceylon compiler. It's also compile-time type safe, so you don't have to use `String` algorithm names and catch `NoSuchAlgorithmException`s, as you would in Java.

Although the [specifications implemented](#algorithms) so far don't leave much room for error (i.e. they tend to either work or not work), Svalinn is a new library, so please use it with caution.

## Usage

Svalinn works on `Array<Byte>` objects. To get `String`s into and out of this form, `ceylon.io.charset` has to be applied. Unfortunately, this package is part of a JVM-only module in the current release of Ceylon. The planned `ceylon.text` may provide the required functionality in the future. The usual encoding for output hashes is hexadecimal, which isn't provided for arbitrary lengths at present (?).

## Algorithms

Svalinn currently contains implementations for the following cryptographic hash algorithms:

- SHA-1
- SHA-1 HMAC

## Performance

Probably not that great, but good enough for short-ish messages. Applications requiring a great amount of throughput are better suited to a native library.

TODO performance comparison with Java standard library

## Acknowledgements

Thanks to the people in [#ceylonlang](http://ceylon-lang.org/community/) for helping me solve the problems I found during implementation.

The compression function interface is a combination of the hashing components of the [Java](http://docs.oracle.com/javase/7/docs/api/java/security/MessageDigest.html) and [Python](https://docs.python.org/3/library/hashlib.html) standard libraries.

Details about the Merkle–Damgård construction, and the classification of cryptographic hash functions were found in the [Handbook of Applied Cryptography](http://cacr.uwaterloo.ca/hac/) by A. Menezes, P. van Oorschot and S. Vanstone. Thanks to the authors and the publisher for making it available without cost.

## License

The content of this repository is released under the ASL v2.0 as provided in the LICENSE file.

By submitting a "pull request" or otherwise contributing to this repository, you agree to license your contribution under the license mentioned above.
