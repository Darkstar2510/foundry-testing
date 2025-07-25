// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

// forge test --mt testFFI --ffi -vvv

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract TestFFI is Test {
    function testFFI() public {
        string[] memory cmds = new string[](2);

        cmds[0] = "cat";
        cmds[1] = "ffi_test.txt";

        bytes memory results = vm.ffi(cmds);

        console.log(string(results));
    }
}
