// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpComposerFirst} from "../../src/layerzero/AeroDumpComposerFirst.sol";
import {AeroDumpComposerSecond} from "../../src/layerzero/AeroDumpComposerSecond.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";

import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract OPDeploy is Script {
    //deploy on op sepolia, 0xa31Cb24339725ccB5A50358Ad77F66Bdc02A613B
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpComposerFirst composerFirst = new AeroDumpComposerFirst(
            msg.sender,
            config.getOpSepoliaConfig().layerZeroEndpoint //layerzero endpoint for Op sepolia
        );
        console.log("composer First Contract Address", address(composerFirst));
        AeroDumpComposerSecond composerSecond = new AeroDumpComposerSecond(
            msg.sender,
            config.getOpSepoliaConfig().layerZeroEndpoint //layerzero endpoint for Op sepolia
        );
        console.log(
            "composer Second Contract Address",
            address(composerSecond)
        );
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getOpSepoliaConfig().tokenAddress,
            config.getOpSepoliaConfig().layerZeroEndpoint,
            msg.sender
        );
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
