// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../src/AerodumpOFTAdapter.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";

contract OFTAdapterScript is Script {
    function run() public {
        HelperConfig helperconfig = new HelperConfig();
        // address privateKey = vm.envAddress("private_key");
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations attestationscontract =
            new AeroDumpAttestations(msg.sender, helperconfig.getBaseSepoliaConfig()._ispAddress);
        attestationscontract.setSchemaIds(
            helperconfig.getBaseSepoliaConfig()._verifyProjectCertificateSchemaId, 2, 3, 1, 2, 3, 4
        );
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            vm.envAddress("BASE_SEPOLIA_LAYERZERO_ENDPOINT"), msg.sender, address(attestationscontract)
        );
        console.log("script running again");
        console.log("adapter", address(adapter));
        uint256 projectId = attestationscontract.verifyProject(
            "test project", "test description,", "www.testaerodump.com", "www.website.com"
        );
        console.log("projectId", projectId);
        vm.stopBroadcast();
    }
}
