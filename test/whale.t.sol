// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// forge test --mt testDeposit --fork-url https://eth-mainnet.g.alchemy.com/v2/ac_Y9x0XKcjwJ-ZH_-jdx_oFoT0kLmru -vvv

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ForkTest is Test {
    IERC20 public dai;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {
        address alice = address(123);
        uint256 balBefore = dai.balanceOf(alice);
        console.log("balance before", balBefore / 1e18);

        uint256 totalBefore = dai.totalSupply();
        console.log("total before", totalBefore / 1e18);

        //mint 1 million $$$ to alice
        deal(address(dai), alice, 1e6 * 1e18, true);
        //1e6 = 1 million
        // 1e18 = because DAI uses 18 decimals

        //true = adjust total supply to match
        // false = just give tokens without touching total supply

        uint256 balAfter = dai.balanceOf(alice);
        console.log("balance after", balAfter / 1e18);

        uint256 totalAfter = dai.totalSupply();
        console.log("total after", totalAfter / 1e18);
        // 1e18 in logs ---- Makes big numbers human-readable (like 1000000000000000000 → 1.0 DAI)
    }
}
