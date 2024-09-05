// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AeroDumpComposer } from "../../src/AeroDumpComposer.sol";
import { AerodumpOFTAdapter } from "../../src/AerodumpOFTAdapter.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer composer = AeroDumpComposer(0x6abA63870bF8Bdf3888b5f794DDf7dE2AeDa5060);
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(0xA621DaF0941E7428Ce7a739a536B6E3954a1d01C);

        // Retrieve the last project name from the Composer contract
        string memory lastProjectNameSentToComposer = composer.data();
        console.log("Last project name sent to Composer:", lastProjectNameSentToComposer);

        // Retrieve the last project name from the Adapter contract
        string memory lastProjectNameSentToAdapterContract = adapter.data();
        console.log("Last project name sent to Adapter Contract:", lastProjectNameSentToAdapterContract);

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
