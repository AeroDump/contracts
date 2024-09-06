// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeScript is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        AeroDumpAttestations(0x3f8aD995e6205C8761a8514D3fec8797e69698d9).setPeer(
            uint32(config.getHederaTestnetConfig().chainEid),
            addressToBytes32(0x4E9dE77b9bfCe417399B512d02F422af093EBd97)
        );
        AeroDumpAttestations(0x3f8aD995e6205C8761a8514D3fec8797e69698d9).setComposerEid(
            uint32(config.getHederaTestnetConfig().chainEid)
        );
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
