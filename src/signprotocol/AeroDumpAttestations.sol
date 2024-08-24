// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ISP } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@signprotocol/signprotocol-evm/src/models/DataLocation.sol";

contract AeroDumpAttestations is Ownable {
    ISP public spInstance;

    error NotAuthorizedToVerify();

    uint64 public projectSchemaId;
    uint64 public csvUploadSchemaId;
    uint64 public tokenDepositSchemaId;
    uint64 public userConsentSchemaId;
    uint64 public distributionCertificateSchemaId;
    uint64 public airdropExecutionSchemaId;

    mapping(address => bool) private s_verifiers;

    constructor(address initialOwner, address _spInstance) Ownable(initialOwner) {
        spInstance = ISP(_spInstance);
    }

    function setSchemaIds(
        uint64 _projectSchemaId,
        uint64 _csvUploadSchemaId,
        uint64 _tokenDepositSchemaId,
        uint64 _userConsentSchemaId,
        uint64 _distributionCertificateSchemaId,
        uint64 _airdropExecutionSchemaId
    )
        external
        onlyOwner
    {
        projectSchemaId = _projectSchemaId;
        csvUploadSchemaId = _csvUploadSchemaId;
        tokenDepositSchemaId = _tokenDepositSchemaId;
        userConsentSchemaId = _userConsentSchemaId;
        distributionCertificateSchemaId = _distributionCertificateSchemaId;
        airdropExecutionSchemaId = _airdropExecutionSchemaId;
    }

    function addVerifier(address verifier) external onlyOwner {
        s_verifiers[verifier] = true;
    }

    function registerProject(string memory projectName) external {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: projectSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, msg.sender, false)
        });

        spInstance.attest(a, "", "", "");
    }

    function verifyProject(string memory projectName, address projectOwner) external {
        require(s_verifiers[msg.sender], NotAuthorizedToVerify());

        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(projectOwner);

        Attestation memory a = Attestation({
            schemaId: projectSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, projectOwner, true, false) // name, owner, isVerified, hasRefundAgreement
         });

        spInstance.attest(a, "", "", "");
    }

    function recordCSVFileUpload(string memory projectName, bytes32 fileHash, uint256 recipientCount) external {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: csvUploadSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, msg.sender, fileHash, block.timestamp, recipientCount)
        });

        spInstance.attest(a, "", "", "");
    }

    function recordProjectTokenDeposit(string memory projectName, address tokenAddress, uint256 amount) external {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: tokenDepositSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, msg.sender, tokenAddress, amount, block.timestamp)
        });

        spInstance.attest(a, "", "", "");
    }

    function recordUserConsent(bool consentGiven) external {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: userConsentSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(msg.sender, consentGiven, block.timestamp)
        });

        spInstance.attest(a, "", "", "");
    }

    function issueDistributionCertificate(
        string memory projectName,
        uint256 totalAmount,
        uint256 recipientCount
    )
        external
    {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: distributionCertificateSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, msg.sender, totalAmount, recipientCount)
        });

        spInstance.attest(a, "", "", "");
    }

    function signRefundAgreement(string memory projectName) external {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: projectSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, msg.sender, true, true) // name, owner, isVerified, hasRefundAgreement
         });

        spInstance.attest(a, "", "", "");
    }
}
