// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AerodumpOFTAdapter(0x89AD215eF488E254B804162c83d6BC7DE0e1519c).setPeer(
            uint32(40161),
            addressToBytes32(0x09dc432D56616A204B79ABAd351D84aD78153d5D)
        );
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
