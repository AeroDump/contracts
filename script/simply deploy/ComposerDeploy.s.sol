// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
<<<<<<< HEAD
import { AeroDumpComposer } from "../../src/AeroDumpComposer.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
=======
import {AeroDumpComposer} from "../../src/AreoDumpComposer.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    //deploy on op sepolia, 0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB
>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
<<<<<<< HEAD
        AeroDumpComposer aeroDumpComposerContract = new AeroDumpComposer(
            0x6EDCE65403992e310A62460808c4b910D972f10f, //base sepolia layerzero endpoint
            msg.sender, //owner of the contract
            address(1)
        );
        console.log("Attestation Contract Address", address(aeroDumpComposerContract));
=======
        AeroDumpComposer composer = new AeroDumpComposer(
            msg.sender,
            config.getOpSepoliaConfig().layerZeroEndpoint //layerzero endpoint for linea sepolia
        );
        console.log("composer Contract Address", address(composer));

>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3
        vm.stopBroadcast();
    }
}
