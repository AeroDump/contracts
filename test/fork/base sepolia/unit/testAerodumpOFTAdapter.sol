import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";
import {Script} from "forge-std/Script.sol";
import {AerodumpOFTAdapter} from "../../../../src/AerodumpOFTAdapter.sol";
import {AeroDumpAttestations} from "../../../../src/signprotocol/AeroDumpAttestations.sol";
import {HelperConfig} from "../../../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract AerodumpOFTAdapterTest is StdCheats, StdUtils, Test, Script {
    address owner = address(1);
    address[] recipients;

    address projectOwner = address(6);
    address recipient1 = address(2);
    address recipient2 = address(3);
    address recipient3 = address(4);
    address recipient4 = address(5);
    IERC20 public usdc;
    HelperConfig public helperconfig;
    AeroDumpAttestations attestationscontract;
    AerodumpOFTAdapter public adapter;
    uint256 basesepoliafork;
    string BASE_SEPOLIA_RPC_URL = vm.envString("BASE_SEPOLIA_RPC_URL");

    function setUp() public {
        helperconfig = new HelperConfig();
        basesepoliafork = vm.createFork(BASE_SEPOLIA_RPC_URL);
        vm.selectFork(basesepoliafork);
        usdc = IERC20(helperconfig.getBaseSepoliaConfig().tokenAddress);
        deal(address(usdc), projectOwner, 20 * 1e6);
        vm.startPrank(owner);
        attestationscontract = new AeroDumpAttestations(
            owner,
            helperconfig.getBaseSepoliaConfig()._ispAddress
        );
        adapter = new AerodumpOFTAdapter(
            helperconfig.getBaseSepoliaConfig().tokenAddress,
            helperconfig.getBaseSepoliaConfig().layerZeroEndpoint,
            msg.sender,
            address(attestationscontract)
        );
        vm.stopPrank();
    }

    function testLockTokens() public {
        vm.startPrank(projectOwner);
        usdc.approve(address(adapter), 20 * 1e6);
        (uint256 amountSent, uint256 amountRecievedByRemote) = adapter
            .lockTokens(
                1356,
                20 * 1e6,
                19 * 1e6,
                uint32(vm.envUint("BASE_SEPOLIA_CHAIN_ID"))
            );
        assertEq(amountSent, 20 * 1e6);
        assertEq(amountRecievedByRemote, 20 * 1e6);
        assertEq(usdc.balanceOf(address(adapter)), 20 * 1e6);
        AerodumpOFTAdapter.project memory project = adapter
            .getProjectDetailsForProjectOwner();
        assertEq(project.amountLockedInContract, 20 * 1e6);
        assertEq(project.isSentToRecipients, false);
        assertEq(project.isAirdropActive, true);
        vm.stopPrank();
    }

    function testqueueAirdropWithEqualDistribution() public {
        vm.startPrank(projectOwner);
        recipients.push(recipient1);
        recipients.push(recipient2);
        recipients.push(recipient3);
        recipients.push(recipient4);
        usdc.approve(address(adapter), 20 * 1e6);
        // attestationscontract.verifyProject();
        adapter.lockTokens(
            1357,
            20 * 1e6,
            19 * 1e6,
            uint32(vm.envUint("BASE_SEPOLIA_CHAIN_ID"))
        );
        adapter.queueAirdropWithEqualDistribution(
            1357,
            recipients,
            uint32(vm.envUint("BASE_SEPOLIA_CHAIN_ID"))
        );

        (bool upkeepNeeded, bytes memory checkData) = adapter.fakeCheckUpkeep(
            bytes("null")
        );
        if (upkeepNeeded == true) {
            adapter.fakePerformUpkeep(bytes("null"));
        }
        AerodumpOFTAdapter.project memory project = adapter
            .getProjectDetailsForProjectOwner();
        assertEq(project.isSentToRecipients, true);
        assertEq(usdc.balanceOf(recipient1), 5 * 1e6);

        (bool upkeepNeeded2, bytes memory checkData2) = adapter.fakeCheckUpkeep(
            bytes("null")
        );
        if (upkeepNeeded2 == true) {
            adapter.fakePerformUpkeep(bytes("null"));
        }
        AerodumpOFTAdapter.project memory project2 = adapter
            .getProjectDetailsForProjectOwner();
        assertEq(project2.isSentToRecipients, true);
        assertEq(usdc.balanceOf(recipient2), 5 * 1e6);

        (bool upkeepNeeded3, bytes memory checkData3) = adapter.fakeCheckUpkeep(
            bytes("null")
        );
        if (upkeepNeeded3 == true) {
            adapter.fakePerformUpkeep(bytes("null"));
        }
        AerodumpOFTAdapter.project memory project3 = adapter
            .getProjectDetailsForProjectOwner();
        assertEq(project3.isSentToRecipients, true);
        assertEq(usdc.balanceOf(recipient3), 5 * 1e6);

        (bool upkeepNeeded4, bytes memory checkData4) = adapter.fakeCheckUpkeep(
            bytes("null")
        );
        if (upkeepNeeded4 == true) {
            adapter.fakePerformUpkeep(bytes("null"));
        }
        AerodumpOFTAdapter.project memory project4 = adapter
            .getProjectDetailsForProjectOwner();
        assertEq(project4.isSentToRecipients, true);
        assertEq(usdc.balanceOf(recipient4), 5 * 1e6);
        vm.stopPrank();
    }
}
