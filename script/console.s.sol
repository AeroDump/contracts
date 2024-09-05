// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AeroDumpComposer} from "../../src/AeroDumpComposer.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer composer = AeroDumpComposer(
            0x6015bB11856889aE9E96E9635CA0D6757f44b71b
        );
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(
            0xe473EffDC30EdBFb68990A517A21307d287CcbB3
        );

        // Retrieve the last project name from the Composer contract
        address userAddress = composer.USER();
        uint256 projectId = composer.PROJECTID();
        console.log("last msg.sender in composer contract:", userAddress);
        console.log("last id in composer contract:", projectId);

        // Retrieve the last project name from the Adapter contract
        address userAddress2 = adapter.USER();
        uint256 projectId2 = adapter.PROJECTID();

        console.log("last msg.sender in adapter:", userAddress2);
        console.log("last id in adapter contract:", projectId2);

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
