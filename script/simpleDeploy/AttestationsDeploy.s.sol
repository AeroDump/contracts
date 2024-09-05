// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract AttestationsDeploy is Script {
    //deploy on base sepolia, 0x33E21B633FE6f91bAba56d5B08591f572b9Cee73
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract = new AeroDumpAttestations(
            msg.sender,
            config.getBaseSepoliaConfig()._ispAddress, //isp for base sepolia
            config.getBaseSepoliaConfig().layerZeroEndpoint //layerzero endpoint for base sepolia
        );
        console.log("Attestation Contract Address", address(attestationscontract));
        attestationscontract.setSchemaIds(
            config.getBaseSepoliaConfig()._verifyProjectCertificateSchemaId,
            config.getBaseSepoliaConfig()._tokenDepositSchemaId,
            3,
            1
        );
        console.log("schema ids are set");

        vm.stopBroadcast();
    }
}
