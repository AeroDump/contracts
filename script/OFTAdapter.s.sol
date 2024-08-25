// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OFTAdapterScript is Script {
    function run() public {
        // address privateKey = vm.envAddress("private_key");
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            vm.envAddress("BASE_SEPOLIA_USDC"),
            vm.envAddress("BASE_SEPOLIA_LAYERZERO_ENDPOINT"),
            msg.sender
        );
        console.log("script running again");
        console.log("adapter", address(adapter));
        IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).approve(
            address(adapter),
            2 * 1e6
        );
        adapter.debitFrom(2 * 1e6, 1 * 1e6, uint32(84532));
        vm.stopBroadcast();
        console.log(
            "now our contract owns this much usdc",
            IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).balanceOf(
                address(adapter)
            )
        );
        console.log("now we are crediting to another wallet");
        adapter.creditTo(
            0x6680dfD1c6A4867476b2e60dA89354AC93272878,
            2 * 1e6,
            uint32(84532)
        );
        console.log(
            "credited, balance of new user is ",
            IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).balanceOf(
                0x6680dfD1c6A4867476b2e60dA89354AC93272878
            )
        );
        console.log(
            "balance of contract is ",
            IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).balanceOf(
                address(adapter)
            )
        );
    }
}
