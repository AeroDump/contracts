// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/layerzero/AerodumpOFTAdapter.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {AeroDumpComposerSecond} from "../../src/layerzero/AeroDumpComposerSecond.sol";

contract Console is Script {
    //running on op sepolia
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        // AeroDumpComposer composer = AeroDumpComposer(0xa7F96A7ba1b3Ee324dD9d9b115EFEa827bE67d2a);
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(
            0x425631DdcF82700a85627DA00c4afE1e6FD752d5
        );
        AeroDumpComposerSecond composerSecond = AeroDumpComposerSecond(
            0x4C90332f18716C69A76799cB30dB3cA085aC80A3
        );
        console.log(adapter.getIsUserVerified(msg.sender));
        console.log(
            adapter.getProjectIdToOwner(adapter.getProjectOwnerToId(msg.sender))
        );
        console.log(adapter.getProjectOwnerToId(msg.sender));

        console.log(composerSecond.AMOUNT());

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
