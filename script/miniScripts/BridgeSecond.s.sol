// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { AeroDumpComposer } from "../../../src/layerzero/AeroDumpComposer.sol";

import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on hedera testnet
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0x4E9dE77b9bfCe417399B512d02F422af093EBd97).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid), addressToBytes32(0x3f8aD995e6205C8761a8514D3fec8797e69698d9)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(0x58E294d6B380552C0Cd1c6fEd755E2260342b12F);

        AeroDumpComposer(0x4E9dE77b9bfCe417399B512d02F422af093EBd97).setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
