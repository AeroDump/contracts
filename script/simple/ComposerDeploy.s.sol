// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../src/AeroDumpComposer.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    //deploy on op sepolia, 0xBA9E54606a67147Ad0Fb9DeFbaE2d461ddE8ACc5
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpComposer composer = new AeroDumpComposer(
            msg.sender,
            config.getOpSepoliaConfig().layerZeroEndpoint //layerzero endpoint for Op sepolia
        );
        console.log("composer Contract Address", address(composer));

        vm.stopBroadcast();
    }
}
