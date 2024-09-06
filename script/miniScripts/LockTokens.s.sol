// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockTokens is Script {
    IERC20 usdc;

    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        uint256 projectId = 0;
        usdc = IERC20(config.getOpSepoliaConfig().tokenAddress);
        usdc.approve(0xa8fc227DCC5cEf05bFdd726e88E6E237C043F0B2, 2 * 1e6);
        AerodumpOFTAdapter(0xa8fc227DCC5cEf05bFdd726e88E6E237C043F0B2)
            .lockTokens{value: 0.012 ether}(
            projectId,
            2 * 1e6,
            1 * 1e6,
            uint32(config.getOpSepoliaConfig().chainId)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
