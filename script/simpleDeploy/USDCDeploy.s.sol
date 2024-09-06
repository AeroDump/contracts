// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { USDC } from "../../src/USDC.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";

contract USDCDeploy is Script {
    //deploy on hedera testnet 0xe0112d460C99b48FBcABE6148ff3F65ac60e2497
    function run() public {
        uint256 currentNonce = vm.getNonce(msg.sender); // Retrieves current nonce
        console.log("Current Nonce:", currentNonce);

        vm.startBroadcast();
        console.log("script running");
        USDC usdc = new USDC(msg.sender);
        console.log("USDC Contract Address", address(usdc));

        vm.stopBroadcast();
    }
}
