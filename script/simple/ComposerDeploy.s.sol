// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../src/AeroDumpComposer.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    //deploy on op sepolia, 0x6015bB11856889aE9E96E9635CA0D6757f44b71b
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
