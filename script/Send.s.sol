// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {OptionsBuilder} from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

contract SendScript is Script {
    //running on eth sepolia
    function run() public {
        // bytes memory options = OptionsBuilder
        //     .newOptions()
        //     .addExecutorLzReceiveOption(200000, 0);
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        // AeroDumpAttestations(0x09dc432D56616A204B79ABAd351D84aD78153d5D).send{
        //     value: 100000
        // }(uint32(40245), "hi_there", options);
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
