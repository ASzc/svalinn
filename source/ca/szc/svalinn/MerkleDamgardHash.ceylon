"Abstract class for hash functions that apply Merkle–Damgård construction in
 order to accept arbitrary sized input into a fixed input compression
 function."
shared abstract class MerkleDamgardHash() satisfies BlockedHash {
    // TODO use "remainder" tuple to store leftover array and array index. Null if no remainder?
}
