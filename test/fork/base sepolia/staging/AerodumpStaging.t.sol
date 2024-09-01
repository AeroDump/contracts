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

contract AerodumpStagingTest is StdCheats, StdUtils, Test, Script {
    address owner = address(1);
    address[] recipients;

    address projectOwner = address(6);
    address projectOwner2 = address(7);
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
        deal(address(usdc), projectOwner2, 20 * 1e6);

        vm.startPrank(owner);
        attestationscontract = new AeroDumpAttestations(
            owner,
            helperconfig.getBaseSepoliaConfig()._ispAddress,
            0x6EDCE65403992e310A62460808c4b910D972f10f
        );
        attestationscontract.setSchemaIds(
            helperconfig
                .getBaseSepoliaConfig()
                ._verifyProjectCertificateSchemaId,
            2,
            3,
            1,
            2,
            3,
            4
        );
        adapter = new AerodumpOFTAdapter(
            helperconfig.getBaseSepoliaConfig().tokenAddress,
            helperconfig.getBaseSepoliaConfig().layerZeroEndpoint,
            msg.sender
        );
        vm.stopPrank();
    }

    function testAerodump() public {
        vm.startPrank(projectOwner);

        uint256 projectId = attestationscontract.verifyProject(
            "test project",
            "test description,",
            "www.testaerodump.com",
            "www.website.com"
        );
        console.log("projectId", projectId);
        // attestationscontract.recordKYCVerification(projectOwner, true);
        vm.stopPrank();
        vm.prank(projectOwner2);
        uint256 projectId2 = attestationscontract.verifyProject(
            "test project",
            "test description,",
            "www.testaerodump.com",
            "www.website.com"
        );
        console.log("projectId2", projectId2);
    }
}
