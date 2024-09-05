// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {OptionsBuilder} from "../src/library/OptionsBuilder.sol";

contract SendScript is Script {
    using OptionsBuilder for bytes;

    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();

        vm.startBroadcast();
        // (uint256 nativeFee, ) = AeroDumpAttestations(
        //     0x09dc432D56616A204B79ABAd351D84aD78153d5D
        // ).quote(uint32(40245), "hi_there", options, false);

        AeroDumpAttestations(0x675de6cA5A78b3C4acB19CD38E5a02a92da1B5f3)
            .verifyProject{value: 0.008 ether}(
            "StringWorks",
            "testy",
            "testytest",
            "testtytest"
        );
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
