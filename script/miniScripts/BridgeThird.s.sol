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
        AerodumpOFTAdapter(0xa8fc227DCC5cEf05bFdd726e88E6E237C043F0B2)
            .setAttestationsEid(uint32(config.getBaseSepoliaConfig().chainEid));
        //calls attestatios's set peer both ways to composer
        AerodumpOFTAdapter(0xa8fc227DCC5cEf05bFdd726e88E6E237C043F0B2).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0xc32b58a3Aa4B65CBef6c64691E20b15e5553aCA4)
        );

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
