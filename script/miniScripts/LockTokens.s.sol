// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockTokens is Script {
    IERC20 usdc;

    //running on hedera
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        uint256 projectId = 0;
        usdc = IERC20(config.getHederaTestnetConfig().tokenAddress);
        console.log(usdc.balanceOf(msg.sender));
        usdc.approve(0x58E294d6B380552C0Cd1c6fEd755E2260342b12F, 2 * 1e6);
        AerodumpOFTAdapter(0x58E294d6B380552C0Cd1c6fEd755E2260342b12F).lockTokens{ value: 0.012 ether }(
            projectId, 2 * 1e6, 1 * 1e6, uint32(config.getHederaTestnetConfig().chainId)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
