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
        AeroDumpComposer(0xBA9E54606a67147Ad0Fb9DeFbaE2d461ddE8ACc5).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0x675de6cA5A78b3C4acB19CD38E5a02a92da1B5f3)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(
            0x4390bbad9F2cd8F4E28C8B48435c24023823d442
        );

        AeroDumpComposer(0xBA9E54606a67147Ad0Fb9DeFbaE2d461ddE8ACc5)
            .setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
