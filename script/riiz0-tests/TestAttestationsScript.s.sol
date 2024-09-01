// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract TestAttestationsScript is Script {
    //deploy on base
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract = new AeroDumpAttestations(
            msg.sender,
            0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD,
            0x6EDCE65403992e310A62460808c4b910D972f10f
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
        uint32 aEid = 40245; //attestations
        attestationscontract.setPeer(
            aEid,
            addressToBytes32(address(attestationscontract))
        );
        uint256 projectid = attestationscontract.verifyProject(
            "notnull",
            "notnull",
            "notnull",
            "notnull"
        );
        console.log("project verified!! id is", projectid);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
