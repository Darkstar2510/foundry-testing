// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract SignTest is Test {
    // private key = 123
    // public key = vm.addr(private key)
    // message = "secret message"
    // message hash = keccak256(message)
    // vm.sign(private key, message hash)

    // Step 1: Setup a test private key
    // private key = 123 (fake key just for testing)
    // public key = vm.addr(123) gives the address for the private key

    function testSignature() public {
        uint256 privateKey = 123; // Fake test private key
        address pubKey = vm.addr(privateKey); // Get public address for the private key

        // Step 2: Create a message and hash it
        // In Ethereum, messages are always signed as keccak256 hashes
        bytes32 messageHash = keccak256("Signed by Alice"); // hash the message

        // Step 3: Sign the message hash using private key
        // vm.sign returns a signature in (v, r, s) format
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        // Step 4: Recover the signer from message hash and signature
        // This simulates "who signed this message?"
        address signer = ecrecover(messageHash, v, r, s); // Should return Alice's address

        // Step 5: Assert that the recovered signer matches Alice's address
        assertEq(signer, pubKey); // ✅ Signature is valid

        // ---- Negative test ----
        // Let's try to recover using a fake message hash
        bytes32 invalidHash = keccak256("Not Signed by Alice"); // different message = different hash

        // Try to recover signer again with invalid hash
        signer = ecrecover(invalidHash, v, r, s);

        // Recovered signer should NOT match Alice now
        assertTrue(signer != pubKey); // ✅ Signature is invalid for this message
    }
}
