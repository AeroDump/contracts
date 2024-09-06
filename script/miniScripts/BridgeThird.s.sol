// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeThird is Script {
    //running on hedera
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AerodumpOFTAdapter(0x58E294d6B380552C0Cd1c6fEd755E2260342b12F).setAttestationsEid(
            uint32(config.getBaseSepoliaConfig().chainEid)
        );
        //calls attestatios's set peer both ways to composer
        AerodumpOFTAdapter(0x58E294d6B380552C0Cd1c6fEd755E2260342b12F).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid), addressToBytes32(0x3f8aD995e6205C8761a8514D3fec8797e69698d9)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
