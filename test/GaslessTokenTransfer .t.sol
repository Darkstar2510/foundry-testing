// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

//forge test --mt testDeposit --fork-url https://eth-mainnet.g.alchemy.com/v2/ac_Y9x0XKcjwJ-ZH_-jdx_oFoT0kLmru -vvv

// Forge test utilities
import "forge-std/Test.sol";
import "forge-std/console.sol";

// WETH interface with two functions: balance check + deposit ETH to get WETH
interface IWETH {
    function balanceOf(address) external view returns (uint256); // check WETH balance

    function deposit() external payable; // deposit ETH to get same amount of WETH
}

contract ForkTest is Test {
    IWETH public weth; //weth stores the interface instance

    // This runs before each test
    function setUp() public {
        // WETH contract address on Ethereum mainnet
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testDeposit() public {
        // Step 1: Check our WETH balance before depositing
        uint256 balBefore = weth.balanceOf(address(this));
        console.log("balance before", balBefore);

        // Step 2: Deposit 100 wei ETH into the WETH contract
        // This gives us 100 wei of WETH in return
        weth.deposit{value: 100}();

        // Step 3: Check new WETH balance after depositing
        uint256 balAfter = weth.balanceOf(address(this));
        console.log("balance after", balAfter);
    }
}
