// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ISP } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@signprotocol/signprotocol-evm/src/models/DataLocation.sol";

/**
 * @title AeroDumpAttestations
 * @author AeroDump
 * @notice This contract manages various attestations for a multi-sender platform.
 * @dev It utilizes Sign Protocol's attestation system to store project-related data securely.
 */
contract AeroDumpAttestations is Ownable {
    // @dev The instance of the Sign Protocol interface.
    ISP public spInstance;

    // @dev Custom error for when a user is not authorized to verify a project.
    error ProjectIsVerified();
    error ProjectNameCannotBeEmpty();
    error ProjectDescriptionCannotBeEmpty();
    error WebsiteURLCannotBeEmpty();
    error SocialMediaURLCannotBeEmpty();

    // @dev Schema IDs for different types of attestations.
    uint64 public projectSchemaId;
    uint64 public csvUploadSchemaId;
    uint64 public tokenDepositSchemaId;
    uint64 public userConsentSchemaId;
    uint64 public distributionCertificateSchemaId;
    uint64 public airdropExecutionSchemaId;

    // @dev Mapping of addresses to boolean indicating whether they are verified project managers.
    mapping(address => bool) private s_isVerified;

    /**
     * @dev Constructor initializes the Sign Protocol instance.
     * @param initialOwner The address of the contract owner.
     * @param _spInstance The address of the Sign Protocol instance.
     */
    constructor(address initialOwner, address _spInstance) Ownable(initialOwner) {
        spInstance = ISP(_spInstance);
    }

    /**
     * @notice Sets schema IDs for different types of attestations.
     * @dev This function must be called after deploying the contract to initialize the schema IDs.
     * @param _projectSchemaId Schema ID for project-related attestations.
     * @param _csvUploadSchemaId Schema ID for CSV file upload attestations.
     * @param _tokenDepositSchemaId Schema ID for token deposit attestations.
     * @param _userConsentSchemaId Schema ID for user consent attestations.
     * @param _distributionCertificateSchemaId Schema ID for distribution certificate attestations.
     * @param _airdropExecutionSchemaId Schema ID for airdrop execution attestations.
     */
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

    /**
     * @notice Registers a new project with the system.
     * @dev Creates an attestation for the project registration.
     * @param projectName The name of the project being registered.
     */
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

    function verifyProject(
        string memory projectName,
        string memory projectDescription,
        string memory websiteUrl,
        string memory socialMediaUrl
    )
        external
    {
        require(!s_isVerified[msg.sender], ProjectIsVerified());

        // Perform basic checks on the provided information
        require(bytes(projectName).length > 0, ProjectNameCannotBeEmpty());
        require(bytes(projectDescription).length > 0, ProjectDescriptionCannotBeEmpty());
        require(bytes(websiteUrl).length > 0, WebsiteURLCannotBeEmpty());
        require(bytes(socialMediaUrl).length > 0, SocialMediaURLCannotBeEmpty());

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
            data: abi.encode(projectName, msg.sender, true, false, projectDescription, websiteUrl, socialMediaUrl)
        });

        spInstance.attest(a, "", "", "");
        s_isVerified[msg.sender] = true;
    }

    /**
     * @notice Records a CSV file upload for a project.
     * @dev Creates an attestation for the CSV file upload.
     * @param projectName The name of the project associated with the CSV file.
     * @param fileHash The hash of the uploaded CSV file.
     * @param recipientCount The number of recipients for this upload.
     */
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

    /**
     * @notice Records a token deposit for a project.
     * @dev Creates an attestation for the token deposit.
     * @param projectName The name of the project associated with the token deposit.
     * @param tokenAddress The address of the token being deposited.
     * @param amount The amount of tokens being deposited.
     */
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

    /**
     * @notice Records user consent for a project.
     * @dev Creates an attestation for the user's consent.
     * @param consentGiven A boolean indicating whether the user gave consent.
     */
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

    /**
     * @notice Issues a distribution certificate for a project.
     * @dev Creates an attestation for the distribution certificate.
     * @param projectName The name of the project receiving the distribution.
     * @param totalAmount The total amount distributed.
     * @param recipientCount The number of recipients for this distribution.
     */
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

    /**
     * @notice Signs a refund agreement for a project.
     * @dev Creates an attestation for the signed refund agreement.
     * @param projectName The name of the project associated with the refund agreement.
     */
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

    function checkVerificationStatus(address user) external view returns (bool) {
        return s_isVerified[user];
    }
}
