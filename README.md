# Svalinn - A cryptography library for Ceylon

Svalinn is written in pure Ceylon, so it will not restrict you to a particular target of the Ceylon compiler.

Unlike the standard library of Java, Svalinn uses the language's type system for algorithm implementation. This means that Svalinn is far easier to understand and extend. It's also type safe, so you don't have to use `String` algorithm names and catch `NoSuchAlgorithmException`s!

## Usage

Svalinn works on `Array<Byte>` objects. To get `String`s into and out of this form, `ceylon.io.charset` has to be applied. Unfortunately, this packagage is part of a JVM-only module in the current release of Ceylon, but it would be feasible to implement a pure Ceylon version. The usual encoding for output hashes is hexadecimal, which isn't provided by the SDK ??? TODO hex conversion lib?

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
