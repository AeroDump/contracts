// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {AeroDumpComposer} from "../../../src/layerzero/AeroDumpComposer.sol";

import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on op sepolia
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0xa31Cb24339725ccB5A50358Ad77F66Bdc02A613B).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0x11a17E5D54A591465F925772868f3695422F7Fea)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(
            0x09553565c26d6e5A27Db70692C0E1aFE2cA846E3
        );

        AeroDumpComposer(0xa31Cb24339725ccB5A50358Ad77F66Bdc02A613B)
            .setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
