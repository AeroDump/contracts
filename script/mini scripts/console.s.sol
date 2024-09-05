// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../../src/AeroDumpComposer.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer composer = AeroDumpComposer(
            0x89AD215eF488E254B804162c83d6BC7DE0e1519c
        );
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(
            0xc90218Fd15Ab567357041018Dcb35932b00379ab
        );
        console.log(adapter.getIsUserVerified(msg.sender));

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
