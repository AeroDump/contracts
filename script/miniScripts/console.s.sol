// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AeroDumpComposer } from "../../../src/layerzero/AeroDumpComposer.sol";
import { AerodumpOFTAdapter } from "../../src/layerzero/AerodumpOFTAdapter.sol";
import { HelperConfig } from "../../../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Console is Script {
    //deploy on hedera testnet
    function run() public {
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpComposer composer = AeroDumpComposer(0xa7F96A7ba1b3Ee324dD9d9b115EFEa827bE67d2a);
        AerodumpOFTAdapter adapter = AerodumpOFTAdapter(0xB2315a96B687E1dce36cc87bc0050D8E65775D22);
        console.log(adapter.getIsUserVerified(msg.sender));

        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
