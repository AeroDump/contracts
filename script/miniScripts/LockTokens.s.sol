// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LockTokens is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        uint256 projectId = 0;
        IERC20(config.getOpSepoliaConfig().tokenAddress).approve(
            0x6dA70c3c286e44F8965c0C26d7D47dba074e9DB0,
            3 * 1e6
        );
        AerodumpOFTAdapter(0x6dA70c3c286e44F8965c0C26d7D47dba074e9DB0)
            .lockTokens{value: 0.004 ether}(
            projectId,
            3 * 1e6,
            2 * 1e6,
            uint32(config.getOpSepoliaConfig().chainId)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
