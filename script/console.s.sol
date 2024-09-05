// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
<<<<<<< HEAD
import { AerodumpOFTAdapter } from "../src/AerodumpOFTAdapter.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
=======
import {AeroDumpComposer} from "../../src/AreoDumpComposer.sol";
import {AerodumpOFTAdapter} from "../../src/AeroDumpOFTAdapter.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
<<<<<<< HEAD
        // console.log(
        //     AerodumpOFTAdapter(0x89AD215eF488E254B804162c83d6BC7DE0e1519c)
=======
        console.log(
            AeroDumpComposer(0x141eA5d5536d81123B4F34Fc3F3aEbd9603aa1AB).data()
        );

        // console.log(
        //     AerodumpOFTAdapter(0x385928e1e9648EF02ec4a44670e9B0D5AFD8e499)
>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3
        //         .data()
        // );
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
