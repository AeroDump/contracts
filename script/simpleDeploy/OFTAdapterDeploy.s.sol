// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { HelperConfig } from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on hedera, 0x58E294d6B380552C0Cd1c6fEd755E2260342b12F
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getHederaTestnetConfig().tokenAddress, config.getHederaTestnetConfig().layerZeroEndpoint, msg.sender
        );
        console.log("adapter", address(adapter));
        adapter.setComposerEid(uint32(config.getHederaTestnetConfig().chainEid));
        vm.stopBroadcast();
    }
}
