// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script, console2 } from "forge-std/Script.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployAeroDumpAttestations is Script {
    function run() external returns (AeroDumpAttestations) {
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.Config memory config;

        if (block.chainid == 1337) {
            config = helperConfig.getAnvilConfig();
        } else if (block.chainid == 115_155) {
            config = helperConfig.getSepoliaConfig();
        } else {
            revert("Unsupported network");
        }

        vm.startBroadcast();
        AeroDumpAttestations aeroDumpAttestations = new AeroDumpAttestations(config._initialOwner, config._ispAddress);
        vm.stopBroadcast();

        console2.log("AeroDumpAttestations contract deployed at:", address(aeroDumpAttestations));
        console2.log("Initial Owner:", config._initialOwner);
        console2.log("SP Instance", config._ispAddress);

        return aeroDumpAttestations;
    }
}
