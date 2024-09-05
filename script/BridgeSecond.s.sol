// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpComposer} from "../../src/AeroDumpComposer.sol";

import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on op sepolia
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0x23960EE69b04e9DC87AE3D5E1e7799c6028edc16).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0x66Cb88c2C4e68Ed626855dA33a2969bD4f4E5540)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(
            0xB8CEc1a1f2986E36284bC42Aa862b812150dD754
        );

        AeroDumpComposer(0x23960EE69b04e9DC87AE3D5E1e7799c6028edc16)
            .setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
