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
            0x036CbD53842c5426634e7929541eC2318f3dCF7e,
            0x6EDCE65403992e310A62460808c4b910D972f10f,
            msg.sender,
            address(1) // @dev replace address(1) with actual attestation contract address
        );
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
