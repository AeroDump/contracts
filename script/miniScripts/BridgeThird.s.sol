// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeThird is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AerodumpOFTAdapter(0xc121eDef7bE2Bc9ea7E8Bc6D697bD6AF3730A266)
            .setAttestationsEid(uint32(config.getBaseSepoliaConfig().chainEid));
        //calls attestatios's set peer both ways to composer
        AerodumpOFTAdapter(0xc121eDef7bE2Bc9ea7E8Bc6D697bD6AF3730A266).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0x0742E003FBe108fd92f7B089cDce906A9a143e2c)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
