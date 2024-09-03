// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AeroDumpComposer } from "../../src/AeroDumpComposer.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract ComposerDeploy is Script {
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpComposer aeroDumpComposerContract = new AeroDumpComposer(
            0x6EDCE65403992e310A62460808c4b910D972f10f, //base sepolia layerzero endpoint
            msg.sender, //owner of the contract
            address(1)
        );
        console.log("Attestation Contract Address", address(aeroDumpComposerContract));
        vm.stopBroadcast();
    }
}
