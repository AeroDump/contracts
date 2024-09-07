// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeFourth is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        //calls attestatios's set peer both ways to composer
        AeroDumpAttestations(0x0742E003FBe108fd92f7B089cDce906A9a143e2c)
            .setPeer(
                uint32(config.getOpSepoliaConfig().chainEid),
                addressToBytes32(0xc121eDef7bE2Bc9ea7E8Bc6D697bD6AF3730A266)
            );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
