// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../src/AeroDumpComposer.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer composer = AeroDumpComposer(
            0x23960EE69b04e9DC87AE3D5E1e7799c6028edc16
        );
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(
            0xB8CEc1a1f2986E36284bC42Aa862b812150dD754
        );

        // Retrieve the last project name from the Composer contract
        string memory lastProjectNameSentToComposer = composer.data();
        console.log(
            "Last project name sent to Composer:",
            lastProjectNameSentToComposer
        );

        // Retrieve the last project name from the Adapter contract
        string memory lastProjectNameSentToAdapterContract = adapter.data();
        console.log(
            "Last project name sent to Adapter Contract:",
            lastProjectNameSentToAdapterContract
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
