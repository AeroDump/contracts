// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract SendCustom is Script {
    //deploy on base sepolia, 0x948EE90e44f83EE3f84B7F91230e17BFA0d0CD41
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations(0x51aED1B696D630063f5f7C1733F3b429C92f9465).send{
            value: 0.08 ether
        }(
            uint32(config.getOpSepoliaConfig().chainEid),
            "hi_there_dude_whytf_you_dont_work"
        );

        vm.stopBroadcast();
    }
}
