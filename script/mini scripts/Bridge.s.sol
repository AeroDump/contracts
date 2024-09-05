// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeScript is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        AeroDumpAttestations(0x85482d447FAD3820477611baf3EB52Ed209323D1)
            .setPeer(
                uint32(config.getOpSepoliaConfig().chainEid),
                addressToBytes32(0x89AD215eF488E254B804162c83d6BC7DE0e1519c)
            );
        AeroDumpAttestations(0x85482d447FAD3820477611baf3EB52Ed209323D1)
            .setComposerEid(uint32(config.getOpSepoliaConfig().chainEid));
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
