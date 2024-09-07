// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeFirst is Script {
    //running on base sepolia
    function run() public {
        AeroDumpAttestations attestations = AeroDumpAttestations(
            0xe4B0BE62627747Ac752669eBb93Ee612ECFd73bE
        );
        address composerFirstAddress = 0xA6f21f0C90f316D8420BBF3897eB98227285d14b;
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        attestations.setPeer( //attestations
            uint32(config.getOpSepoliaConfig().chainEid),
            addressToBytes32(composerFirstAddress) //composer first
        );
        attestations.setComposerFirstEid( //attestations
            uint32(config.getOpSepoliaConfig().chainEid)
        );
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
