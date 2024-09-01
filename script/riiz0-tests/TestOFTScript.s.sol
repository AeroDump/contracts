// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/AerodumpOFTAdapter.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestOFTScript is Script {
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            0x6EDCE65403992e310A62460808c4b910D972f10f, msg.sender, 0xe734076F9B3C4Af1920e92B218B4C3691a1b02d7
        );
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
