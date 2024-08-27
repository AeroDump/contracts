// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Test, console2 } from "forge-std/Test.sol";
import { AeroDumpAttestations } from "../../src/signprotocol/AeroDumpAttestations.sol";

contract TestAeroDumpAttestations is Test {
    AeroDumpAttestations public aeroDumpAttestations;
    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(1);
        user1 = address(2);
        user2 = address(3);

        vm.startPrank(owner);
        aeroDumpAttestations = new AeroDumpAttestations(owner, address(1));

        // Set schema IDs
        aeroDumpAttestations.setSchemaIds(1, 2, 3, 4, 5, 6, 7);
        vm.stopPrank();
    }

    // function testRegisterProject() public {
    //     vm.startPrank(user1);
    //     aeroDumpAttestations.registerProject("TestProject");
    //     vm.stopPrank();

    //     uint64 attestationId = mockISP.attestationCounter();
    //     Attestation memory attestation = mockISP.getAttestation(attestationId);

    //     assertEq(attestation.schemaId, 1);
    //     assertEq(attestation.attester, address(aeroDumpAttestations));
    //     assertEq(attestation.recipients.length, 1);
    //     assertEq(abi.decode(attestation.recipients[0], (address)), user1);
    // }

    // function testVerifyProject() public {
    //     vm.startPrank(user1);
    //     aeroDumpAttestations.verifyProject(
    //         "TestProject", "Description", "https://example.com", "https://twitter.com/example"
    //     );
    //     vm.stopPrank();

    //     uint64 attestationId = mockISP.attestationCounter();
    //     Attestation memory attestation = mockISP.getAttestation(attestationId);

    //     assertEq(attestation.schemaId, 1);
    //     assertEq(attestation.attester, address(aeroDumpAttestations));
    //     assertEq(attestation.recipients.length, 1);
    //     assertEq(abi.decode(attestation.recipients[0], (address)), user1);

    //     (
    //         string memory name,
    //         address projectOwner,
    //         bool isVerified,
    //         bool hasRefundAgreement,
    //         string memory description,
    //         string memory websiteUrl,
    //         string memory socialMediaUrl
    //     ) = abi.decode(attestation.data, (string, address, bool, bool, string, string, string));

    //     assertEq(name, "TestProject");
    //     assertEq(projectOwner, user1);
    //     assertTrue(isVerified);
    //     assertFalse(hasRefundAgreement);
    //     assertEq(description, "Description");
    //     assertEq(websiteUrl, "https://example.com");
    //     assertEq(socialMediaUrl, "https://twitter.com/example");
    // }

    // function testRecordCSVFileUpload() public {
    //     vm.startPrank(user1);
    //     aeroDumpAttestations.recordCSVFileUpload("TestProject", bytes32("fileHash"), 100);
    //     vm.stopPrank();

    //     uint64 attestationId = mockISP.attestationCounter();
    //     Attestation memory attestation = mockISP.getAttestation(attestationId);

    //     assertEq(attestation.schemaId, 2);
    //     assertEq(attestation.attester, address(aeroDumpAttestations));
    //     assertEq(attestation.recipients.length, 1);
    //     assertEq(abi.decode(attestation.recipients[0], (address)), user1);

    //     (string memory projectName, address uploader, bytes32 fileHash, uint256 timestamp, uint256 recipientCount) =
    //         abi.decode(attestation.data, (string, address, bytes32, uint256, uint256));

    //     assertEq(projectName, "TestProject");
    //     assertEq(uploader, user1);
    //     assertEq(fileHash, bytes32("fileHash"));
    //     assertEq(recipientCount, 100);
    // }

    // function testCheckVerificationStatus() public {
    //     vm.startPrank(user1);
    //     aeroDumpAttestations.verifyProject(
    //         "TestProject", "Description", "https://example.com", "https://twitter.com/example"
    //     );
    //     vm.stopPrank();

    //     assertTrue(aeroDumpAttestations.checkVerificationStatus(user1));
    //     assertFalse(aeroDumpAttestations.checkVerificationStatus(user2));
    // }

    // // Add more test functions for other AeroDumpAttestations methods
}
