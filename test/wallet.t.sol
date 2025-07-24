// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// forge test --mt testSendETH
//forge test --mt testWithdrawNotOwner
//forge test --mt testWithraw

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {wallet} from "../src/wallet.sol";

contract testWallet is Test {
    wallet public wallet2;

    function setUp() public {
        wallet2 = new wallet{value: 1e18}();
    }

    //    // Check how much ETH available for test
    //It prints out how much ETH the test contract (WalletTest) has
    function testLogBalance() public {
        console.log("ETH balance", address(this).balance);
    }

    //helper function to send ETH to the wallet
    function _send(uint256 _amount) public {
        (bool ok, ) = address(wallet2).call{value: _amount}("");
        require(ok, "send ETH failed");
    }

    // Examples of deal and hoax
    // deal(address, uint) - Set balance of address
    // hoax(address, uint) - deal + prank, Sets up a prank and set balance

    function testSendETH() public {
        uint256 bal = address(wallet2).balance;

        vm.deal(address(1), 100);
        assertEq(address(1).balance, 100);

        vm.deal(address(1), 10); // overwrites to 10
        assertEq(address(1).balance, 10);

        deal(address(1), 123); // gives 123 to address(1) -- overwritten to 123
        vm.prank(address(1));
        _send(123); // sends 123 from address(1)

        hoax(address(1), 456);
        _send(456); // sends 456 from address(1)

        assertEq(address(wallet2).balance, bal + 123 + 456);
    }

    function testWithdrawNotOwner() public {
        vm.prank(address(1));
        vm.expectRevert(bytes("caller is not owner"));
        wallet2.withdraw(1);
    }

    function testWithraw() public {
        uint256 wallet2BalanceBefore = address(wallet2).balance;
        uint256 ownerBalanceBefore = address(this).balance;

        wallet2.withdraw(1);

        uint256 wallet2BalanceAfter = address(wallet2).balance;
        uint256 ownerBalanceAfter = address(this).balance;

        assertEq(wallet2BalanceAfter, wallet2BalanceBefore - 1);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + 1);
    } //this will revert if there is no fallback() or receive()

    receive() external payable {}
}
