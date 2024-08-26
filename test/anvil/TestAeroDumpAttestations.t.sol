// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Test, console2 } from "forge-std/Test.sol";
import { DeployAeroDumpAttestations } from "../../script/DeployAeroDumpAttestations.s.sol";
import { HelperConfig } from "../../script/HelperConfig.s.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";
import { MockISP } from "../../test/anvil/mocks/MockISP.sol";

contract TestAeroDumpAttestations is Test {
    AeroDumpAttestations public aeroDumpAttestations;
    HelperConfig public helperConfig;
    MockISP public mockISP;
    address public initialOwner;
    address public user1;
    address public user2;

    function setUp() public {
        DeployAeroDumpAttestations deployer = new DeployAeroDumpAttestations();
        aeroDumpAttestations = deployer.run();
        helperConfig = new HelperConfig();

        HelperConfig.Config memory config = helperConfig.getAnvilConfig();
        initialOwner = config._initialOwner;
        mockISP = MockISP(config._ispAddress);

        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        vm.prank(initialOwner);
        aeroDumpAttestations.setSchemaIds(
            config._projectSchemaId,
            config._csvUploadSchemaId,
            config._tokenDepositSchemaId,
            config._userConsentSchemaId,
            config._distributionCertificateSchemaId,
            config._airdropExecutionSchemaId
        );
    }
}
