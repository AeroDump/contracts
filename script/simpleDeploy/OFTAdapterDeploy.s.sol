// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { HelperConfig } from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on hedera testnet
    function run() public {
        vm.startBroadcast();
        console.log("script running");

        // Get the token address and decimals
        address tokenAddress = config.getHederaTestnetConfig().tokenAddress;
        uint256 decimals = config.getUSDCDecimals();

        console.log("Token Address:", tokenAddress);
        console.log("Decimals:", decimals);

        AerodumpOFTAdapter adapter =
            new AerodumpOFTAdapter(tokenAddress, config.getHederaTestnetConfig().layerZeroEndpoint, msg.sender);
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
