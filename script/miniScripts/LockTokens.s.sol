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
        usdc.approve(0x425631DdcF82700a85627DA00c4afE1e6FD752d5, 1 * 1e6);
        AerodumpOFTAdapter(0x425631DdcF82700a85627DA00c4afE1e6FD752d5)
            .lockTokens{value: 0.005 ether}(
            projectId,
            1 * 1e6,
            1 * 1e6,
            uint32(config.getOpSepoliaConfig().chainId)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
