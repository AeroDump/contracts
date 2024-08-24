// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script, console2 } from "forge-std/Script.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "./HelperConfig.s.sol";

contract DeployAeroDumpAttestations is Script {
    HelperConfig config;
    AeroDumpAttestations aeroDumpAttestations;

    function run() external {
        //TO DO
    }
}
