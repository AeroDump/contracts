// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../src/AerodumpOFTAdapter.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestOFTScript is Script {
    //deploy on eth sepolia
    function run() public {
        vm.startBroadcast();
        console.log("script running");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238,
            0x6EDCE65403992e310A62460808c4b910D972f10f,
            msg.sender
        );
        console.log("adapter", address(adapter));
        uint32 bEid = 40285; //adapter
        adapter.setPeer(bEid, addressToBytes32(address(adapter)));
        vm.stopBroadcast();
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
