// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//forge test --match-contract testAuction
//forge test --mt testBid
//forge test --mt testBidFailsAfterEndTime

import {Test, console} from "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract testAuction is Test {
    Auction public auction;
    uint256 public t_startAt;

    // vm.warp - set block.timestamp to future timestamp
    // vm.roll - set block.number
    // skip - increment current timestamp
    // rewind - decrement current timestamp

    function setUp() public {
        auction = new Auction();
        t_startAt = block.timestamp;
    }

    function testBidfailsBeforeStartTime() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    //check timestamp >= startAt
    function testBid() public {
        vm.warp(t_startAt + 1 days);
        auction.bid();
    }

    //cant bid when auction is ended
    function testBidFailsAfterEndTime() public {
        vm.expectRevert(bytes("cannot bid"));
        vm.warp(t_startAt + 2 days);
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;
        // set block.timestamp to t + 100
        skip(100);
        assertEq(block.timestamp, t + 100);

        // set block.timestamp to t + 100 - 100;
        rewind(100);
        assertEq(block.timestamp, t);
    }

    //vm.roll - set block number
    function testBlockNumber() public {
        uint b = block.number;
        vm.roll(999);
        assertEq(999, block.number);
    }
}
