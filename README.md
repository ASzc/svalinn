# Svalinn - A cryptography library for Ceylon

Svalinn is pure Ceylon, meaning that it will not restrict other software to a particular target of the Ceylon compiler. Usually, accessing cryptographic algorithms would mean using a native library (JVM xor JS), limiting the software to one target only.

Unlike the standard library of Java, an attempt has been made to use the language's type system. This means that Svalinn is statically type safe (no `String` algorithm names and `NoSuchAlgorithmException`s!), and is far easier to understand and extend with new algorithms.

## Usage

Svalinn works on `Array<Byte>` objects. To get text `String`s into and out of this form, you'll have to convert them using `ceylon.io.charset`. Unfortunately, this is part of a JVM only module in the current release of Ceylon, but that package could feasibly be converted to pure Ceylon. The usual encoding for output hashes is hexadecimal, which isn't provided by the SDK ??? TODO hex conversion lib?

## Algorithms

Svalinn currently contains implementations for the following cryptographic hash algorithms:

- SHA-1

- HMAC (General purpose)
 - SHA-1 HMAC

## Performance

TODO performance comparison with Java standard library

## Acknowledgements

The compression function interface is a combination of the Java and Python standard library packages for hashing.

A better understanding of the following points was obtained from the *Handbook of Applied Cryptography* by A. Menezes, P. van Oorschot and S. Vanstone. Thanks to the authors and the publisher for making it available without cost.

- Cryptographic hash function classification
- Merkle–Damgård construction

## License

The content of this repository is released under the ASL v2.0 as provided in the LICENSE file.

By submitting a "pull request" or otherwise contributing to this repository, you agree to license your contribution under the license mentioned above.
