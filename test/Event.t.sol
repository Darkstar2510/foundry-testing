// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// forge test --mt testEmitTransferEvent

// forge test --mt testEmitManyTransferEvents -vvv

import {Test, console} from "forge-std/Test.sol";
import {Event} from "../src/Event.sol";

contract testEvent is Test {
    Event public s_event;

    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        s_event = new Event();
    }

    //testing single event
    function testEmitTransferEvent() public {
        // function expectEmit(
        //     bool checkTopic1,
        //     bool checkTopic2,
        //     bool checkTopic3,
        //     bool checkData
        // ) external;

        // 1. Tell Foundry which data to check
        // Check index 1, index 2 and data
        vm.expectEmit(true, true, false, true);
        // 2. Emit the expected event
        emit Transfer(address(this), address(123), 456);
        // 3. Call the function that should emit the event
        s_event.transfer(address(this), address(123), 456);

        // Check only index 1
        vm.expectEmit(true, false, false, false);
        emit Transfer(address(this), address(123), 456);
        // NOTE: index 2 and data (amount) doesn't match
        //       but the test will still pass
        s_event.transfer(address(this), address(111), 222);
    }

    //Test multiple events emmited by single functions
    function testEmitManyTransferEvents() public {
        address[] memory to = new address[](2);
        to[0] = address(777);
        to[1] = address(888);

        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 777;
        amounts[1] = 888;

        for (uint256 i = 0; i < to.length; i++) {
            // 1. Tell Foundry which data to check
            vm.expectEmit(true, true, false, true);
            // 2. Emit the expected event
            emit Transfer(address(this), to[i], amounts[i]);
        }

        // 3. Call the function that should emit the event
        s_event.transferMany(address(this), to, amounts);
    }
}
