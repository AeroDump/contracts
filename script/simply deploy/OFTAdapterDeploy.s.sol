// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on op sepolia , 0xc1291707f5Af0aBEaC2bf483053330BF1798189d
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getOpSepoliaConfig().tokenAddress,
            config.getOpSepoliaConfig().layerZeroEndpoint,
            msg.sender
        );
        console.log("adapter", address(adapter));
        vm.stopBroadcast();
    }
}
