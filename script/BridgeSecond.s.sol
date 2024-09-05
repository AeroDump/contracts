// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpComposer} from "../../src/AreoDumpComposer.sol";

import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeSecondScript is Script {
    //running on op sepolia
    function run() public {
        // sets the peer both ways from composer to attestations.
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer(0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB).setPeer(
            uint32(config.getBaseSepoliaConfig().chainEid),
            addressToBytes32(0x2AEf4AB12A5b8dBD420AbC44CE5C3ac562352526)
        );
        AeroDumpComposer(0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB)
            .setAdapterAddress(0xc1291707f5Af0aBEaC2bf483053330BF1798189d);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
