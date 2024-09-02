// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract AttestationsDeploy is Script {
    //deploy on eth sepolia, 0x09dc432D56616A204B79ABAd351D84aD78153d5D
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract = new AeroDumpAttestations(
            msg.sender,
            0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5, //isp for sepolia eth
            0x6EDCE65403992e310A62460808c4b910D972f10f //layerzero endpoint for eth sepolia
        );
        console.log("Attestation Contract Address", address(attestationscontract));
        attestationscontract.setSchemaIds(
            config.getBaseSepoliaConfig()._verifyProjectCertificateSchemaId,
            config.getBaseSepoliaConfig()._tokenDepositSchemaId,
            3,
            1,
            2,
            3,
            4
        );
        console.log("schema ids are set");

        vm.stopBroadcast();
    }
}
