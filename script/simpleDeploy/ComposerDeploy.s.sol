// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AeroDumpComposer } from "../../src/layerzero/AeroDumpComposer.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    //deploy on hedera testnet EVM Compatible address 0x59f039Ab86A869cc0fc0A086506F8c48048b6b46
    //Contract ID: 0.0.4826972
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpComposer composer = new AeroDumpComposer(
            msg.sender,
            config.getHederaTestnetConfig().layerZeroEndpoint //layerzero endpoint for Op sepolia
        );
        console.log("composer Contract Address", address(composer));

        vm.stopBroadcast();
    }
}
