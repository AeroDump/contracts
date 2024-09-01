// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeScript is Script {
    // deploying on base
    function run() public {
        // address privateKey = vm.envAddress("private_key");
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpAttestations attestations = AeroDumpAttestations(address(0));

        uint256 projectid = attestations.verifyProject(
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
