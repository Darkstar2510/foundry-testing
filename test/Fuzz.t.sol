// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//forge test --mt testMostSignificantBitFuzz
//forge test --mt testMostSignificantBitManual

import {Test, console} from "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

contract FuzzTest is Test {
    Bit public b;

    function setUp() public {
        b = new Bit();
    }

    //This function finds the index of the most significant bit (MSB) — that is,
    //the highest bit that is 1 in the binary form of the number x.
    function mostSignificantBit(uint256 x) public view returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificantBitManual() public {
        assertEq(b.mostSignificantBit(0), 0); // 0 → no bits set → MSB is 0 by default
        assertEq(b.mostSignificantBit(1), 0); // 1 → binary: 000...0001 → MSB at index 0
        assertEq(b.mostSignificantBit(2), 1); // 2 → binary: 10 → MSB at index 1
        assertEq(b.mostSignificantBit(4), 2); // 4 → binary: 100 → MSB at index 2
        assertEq(b.mostSignificantBit(8), 3); // 8 → binary: 1000 → MSB at index 3
        assertEq(b.mostSignificantBit(type(uint256).max), 255); // max uint256 → all bits 1 → MSB at index 255
    }

    function testMostSignificantBitFuzz(uint256 x) public {
        // assume - If false, the fuzzer will discard the current fuzz inputs
        //          and start a new fuzz run
        // Skip x = 0
        vm.assume(x > 0);
        assertGt(x, 0); //greater than

        // bound(input, min, max) - bound input between min and max
        // Bound
        x = bound(x, 1, 10);
        assertGe(x, 1); ////greater than equal to
        assertLe(x, 10);

        uint256 i = b.mostSignificantBit(x);
        assertEq(i, mostSignificantBit(x));
    }
}
