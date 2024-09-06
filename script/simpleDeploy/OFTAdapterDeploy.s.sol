// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

contract OFTAdapterDeploy is Script {
    HelperConfig config = new HelperConfig();

    //deploy on op sepolia , 0xA2fBE87Da6119B428C22927baC4183cB2Bc718a3
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
