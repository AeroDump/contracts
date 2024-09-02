// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../../src/AerodumpOFTAdapter.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { HelperConfig } from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on base sepolia , 0x89AD215eF488E254B804162c83d6BC7DE0e1519c
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getBaseSepoliaConfig().tokenAddress, config.getBaseSepoliaConfig().layerZeroEndpoint, msg.sender
        );
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
