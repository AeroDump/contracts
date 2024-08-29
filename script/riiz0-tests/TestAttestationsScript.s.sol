// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";

contract TestAttestationsScript is Script {
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract =
            new AeroDumpAttestations(msg.sender, 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD);
        console.log("Attestation Contract Address", address(attestationscontract));
        vm.stopBroadcast();
    }
}
