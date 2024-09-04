// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../src/AreoDumpComposer.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    //deploy on op sepolia, 0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpComposer composer = new AeroDumpComposer(
            msg.sender,
            config.getOpSepoliaConfig().layerZeroEndpoint //layerzero endpoint for linea sepolia
        );
        console.log("composer Contract Address", address(composer));

        vm.stopBroadcast();
    }
}
