// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {AeroDumpComposerFirst} from "../../../src/layerzero/AeroDumpComposerFirst.sol";
import {AeroDumpComposerSecond} from "../../../src/layerzero/AeroDumpComposerSecond.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecond is Script {
    //running on op sepolia
    function run() public {
        AeroDumpComposerFirst composerFirst = AeroDumpComposerFirst(
            0xA6f21f0C90f316D8420BBF3897eB98227285d14b
        );
        AeroDumpComposerSecond composerSecond = AeroDumpComposerSecond(
            0x4C90332f18716C69A76799cB30dB3cA085aC80A3
        );
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(
            0x425631DdcF82700a85627DA00c4afE1e6FD752d5
        );
        address attestations = 0xe4B0BE62627747Ac752669eBb93Ee612ECFd73bE;

        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        composerFirst.setPeer( //composer first
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(address(attestations)) //attestations
        );

        adapter.setPeer(
            uint32(config.getOpSepoliaConfig().chainEid),
            addressToBytes32(address(composerSecond))
        );

        composerSecond.setPeer( //composer first
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(address(adapter)) //attestations
        );

        adapter.setComposerSecondEid(
            uint32(config.getOpSepoliaConfig().chainEid)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(address(adapter));

        composerFirst.setAdapterAddresses(adapterAddresses);

        composerSecond.setAttestationsAddress(address(attestations));
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
