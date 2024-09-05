// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
<<<<<<< HEAD
import { AerodumpOFTAdapter } from "../src/AerodumpOFTAdapter.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OptionsBuilder } from "../src/library/OptionsBuilder.sol";

contract SendScript is Script {
    using OptionsBuilder for bytes;

    //running on eth sepolia
    function run() public {
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(20_000, 0);

=======
import {AeroDumpAttestations} from "../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract SendCustom is Script {
    //deploy on base sepolia, 0x948EE90e44f83EE3f84B7F91230e17BFA0d0CD41
    function run() public {
>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        console.log("script running");
        AeroDumpAttestations(0x2AEf4AB12A5b8dBD420AbC44CE5C3ac562352526).send{
            value: 0.04 ether
        }(
            uint32(config.getOpSepoliaConfig().chainEid),
            "hi_there_dude_whytf_you_dont_work"
        );

<<<<<<< HEAD
        // AeroDumpAttestations(0x09dc432D56616A204B79ABAd351D84aD78153d5D).send{
        //     value: 0.1 ether
        // }(uint32(40245), "hi_there", options);
=======
>>>>>>> df66cca134d4030db9ae253db97fd4bf757e2aa3
        vm.stopBroadcast();
    }
}
