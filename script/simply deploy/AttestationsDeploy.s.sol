// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract AttestationsDeploy is Script {
    //deploy on base sepolia, 0x2AEf4AB12A5b8dBD420AbC44CE5C3ac562352526
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract = new AeroDumpAttestations(
            msg.sender,
            config.getBaseSepoliaConfig()._ispAddress, //isp for sepolia eth
            config.getBaseSepoliaConfig().layerZeroEndpoint //layerzero endpoint for eth sepolia
        );
        console.log(
            "Attestation Contract Address",
            address(attestationscontract)
        );
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
