// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../src/AerodumpOFTAdapter.sol";
import { AeroDumpComposer } from "../../src/AeroDumpComposer.sol";

import { HelperConfig } from "../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on op sepolia
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0x6abA63870bF8Bdf3888b5f794DDf7dE2AeDa5060).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid), addressToBytes32(0x2D92992eA05d38A254B6C26ED9DC5933b5Fb8c5C)
        );

        address[] memory adapterAddresses = new address[](1); // Adjust size as needed
        adapterAddresses[0] = address(0xA621DaF0941E7428Ce7a739a536B6E3954a1d01C);

        AeroDumpComposer(0x6abA63870bF8Bdf3888b5f794DDf7dE2AeDa5060).setAdapterAddresses(adapterAddresses);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
