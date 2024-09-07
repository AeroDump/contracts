// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on op sepolia , 0x09553565c26d6e5A27Db70692C0E1aFE2cA846E3
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getOpSepoliaConfig().tokenAddress,
            config.getOpSepoliaConfig().layerZeroEndpoint,
            msg.sender
        );
        console.log("adapter", address(adapter));
        adapter.setComposerEid(uint32(config.getOpSepoliaConfig().chainEid));
        vm.stopBroadcast();
    }
}
