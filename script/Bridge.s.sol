// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeScript is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        AeroDumpAttestations(0x2AEf4AB12A5b8dBD420AbC44CE5C3ac562352526)
            .setPeer(
                uint32(config.getOpSepoliaConfig().chainEid),
                addressToBytes32(0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB)
            );
        AeroDumpAttestations(0x2AEf4AB12A5b8dBD420AbC44CE5C3ac562352526)
            .setComposerEid(uint32(config.getOpSepoliaConfig().chainEid));
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
