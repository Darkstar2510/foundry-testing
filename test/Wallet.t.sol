// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract testWallet is Test {
    Wallet public wallet;

    function setUp() public {
        wallet = new Wallet();
    }

    //current ownner shud be able to set the new owner

    //owner of wallet will be testWallet -- function called by this contract
    function testOwner() public {
        wallet.setOwner(address(1)); //setting new owner
        //check new owner = address(1)
        assertEq(address(1), wallet.owner());
    }

    function testNotOwner() public {
        vm.expectRevert();
        vm.prank(address(1));
        wallet.setOwner(address(1));
    }
}
