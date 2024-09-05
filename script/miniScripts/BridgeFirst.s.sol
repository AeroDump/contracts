// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeScript is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        AeroDumpAttestations(0x651f45D00c1FecBc345F7Ee708ffe4aB57Aa46F6)
            .setPeer(
                uint32(config.getOpSepoliaConfig().chainEid),
                addressToBytes32(0x26f36a778DBAB00B9f9f3DED0dd7aD59C3A7847b)
            );
        AeroDumpAttestations(0x651f45D00c1FecBc345F7Ee708ffe4aB57Aa46F6)
            .setComposerEid(uint32(config.getOpSepoliaConfig().chainEid));
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
