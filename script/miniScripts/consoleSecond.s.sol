// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AeroDumpAttestations} from "../../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ConsoleSecond is Script {
    //running on base sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        // AeroDumpComposer composer = AeroDumpComposer(0xa7F96A7ba1b3Ee324dD9d9b115EFEa827bE67d2a);
        AeroDumpAttestations attestations = AeroDumpAttestations(
            0xc32b58a3Aa4B65CBef6c64691E20b15e5553aCA4
        );
        console.log(attestations.AMOUNT());
        console.log(attestations.getIsTokensLocked(msg.sender));

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
