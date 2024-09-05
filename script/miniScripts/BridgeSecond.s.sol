// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { AeroDumpComposer } from "../../../src/layerzero/AeroDumpComposer.sol";

import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //deploy on hedera testnet
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0xa7F96A7ba1b3Ee324dD9d9b115EFEa827bE67d2a).setPeer(
            uint32(config.getHederaTestnetConfig().chainEid),
            addressToBytes32(0x33E21B633FE6f91bAba56d5B08591f572b9Cee73)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(0xB2315a96B687E1dce36cc87bc0050D8E65775D22);

        AeroDumpComposer(0xa7F96A7ba1b3Ee324dD9d9b115EFEa827bE67d2a).setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
