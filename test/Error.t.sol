// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Error} from "../src/Error.sol";

contract testError is Test {
    Error public s_error;

    function setUp() public {
        s_error = new Error();
    }

    //test require statement
    function testThrowError() public {
        vm.expectRevert(bytes("not authorized"));
        //vm.expectRevert("not authorized");
        s_error.throwError();
    }

    //test custom error
    function testThrowCustomError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        s_error.throwCustomError();
    }

    //label assertions
    function testAssertions() public {
        assertEq(uint(1), uint(1), "test 1");
        assertEq(uint(1), uint(1), "test 2");
        assertEq(uint(1), uint(2), "test 3");
        assertEq(uint(1), uint(1), "test 4");
    }
}
