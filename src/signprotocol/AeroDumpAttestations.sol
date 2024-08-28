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
    uint64 public verifyUserCertificateSchemaId;
    uint64 public kycVerificationSchemaId;
    uint64 public csvUploadSchemaId;
    uint64 public tokenDepositSchemaId;
    uint64 public userConsentSchemaId;
    uint64 public distributionCertificateSchemaId;
    uint64 public airdropExecutionSchemaId;

    // @dev The next project ID to be assigned.
    uint256 private nextProjectId;

    // @dev Mapping of addresses to boolean indicating whether they are verified project managers.
    mapping(address => bool) private s_isVerified;

    // @dev Mapping of addresses to boolean indicating whether they have KYC verified.
    mapping(address => bool) private s_isKYCVerified;

    // @dev Mapping of addresses to project IDs.
    mapping(address => uint256) private s_projectIds;

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
     * @param _verifyProjectCertificateSchemaId Schema ID for project verification attestations.
     * @param _kycVerificationSchemaId Schema ID for KYC verification attestations.
     * @param _tokenDepositSchemaId Schema ID for token deposit attestations.
     * @param _userConsentSchemaId Schema ID for user consent attestations.
     * @param _distributionCertificateSchemaId Schema ID for distribution certificate attestations.
     * @param _airdropExecutionSchemaId Schema ID for airdrop execution attestations.
     */
    function setSchemaIds(
        uint64 _verifyProjectCertificateSchemaId,
        uint64 _kycVerificationSchemaId,
        uint64 _tokenDepositSchemaId,
        uint64 _userConsentSchemaId,
        uint64 _distributionCertificateSchemaId,
        uint64 _airdropExecutionSchemaId
<<<<<<< HEAD
    )
        external
        onlyOwner
    {
        verifyUserCertificateSchemaId = _verifyProjectCertificateSchemaId;
        kycVerificationSchemaId = _kycVerificationSchemaId;
=======
    ) external onlyOwner {
        verifyProjectCertificateSchemaId = _verifyProjectCertificateSchemaId;
        kycVerificationSchemaId = _kycVerificationSchemaId; // Set the new KYC verification schema ID
        csvUploadSchemaId = _csvUploadSchemaId;
>>>>>>> 9f5d572 (AeroDump working lets go)
        tokenDepositSchemaId = _tokenDepositSchemaId;
        userConsentSchemaId = _userConsentSchemaId;
        distributionCertificateSchemaId = _distributionCertificateSchemaId;
        airdropExecutionSchemaId = _airdropExecutionSchemaId;
    }

    /**
<<<<<<< HEAD
     * @notice Registers a new project with the system.
     * @dev Creates an attestation for the project registration.
     * @param projectName The name of the project being registered.
     */
=======
    //  * @notice Registers a new project with the system.
    //  * @dev Creates an attestation for the project registration.
    //  * @param projectName The name of the project being registered.
    //  */
>>>>>>> 9f5d572 (AeroDump working lets go)
    // function registerProject(string memory projectName) external {
    //     bytes[] memory recipients = new bytes[](1);
    //     recipients[0] = abi.encode(msg.sender);

    //     Attestation memory a = Attestation({
    //         schemaId: projectSchemaId,
    //         linkedAttestationId: 0,
    //         attestTimestamp: 0,
    //         revokeTimestamp: 0,
    //         attester: address(this),
    //         validUntil: 0,
    //         dataLocation: DataLocation.ONCHAIN,
    //         revoked: false,
    //         recipients: recipients,
    //         data: abi.encode(projectName, msg.sender, false)
    //     });

    //     spInstance.attest(a, "", "", "");
    // }

    /**
     * @notice Verifies a project by recording detailed information.
     * @dev Creates an attestation for project verification. This function can only be called once per address.
     * @param projectName The name of the project being verified.
     * @param description A detailed description of the project.
     * @param websiteUrl The official website URL of the project.
     * @param socialMediaUrl The social media URL associated with the project.
     *  ProjectIsVerified if the caller's project is already verified.
     *  ProjectNameCannotBeEmpty if the provided project name is empty.
     *  ProjectDescriptionCannotBeEmpty if the provided project description is empty.
     *  WebsiteURLCannotBeEmpty if the provided website URL is empty.
     *  SocialMediaURLCannotBeEmpty if the provided social media URL is empty.
     */
    function verifyProject(
        string memory projectName,
        string memory description,
        string memory websiteUrl,
        string memory socialMediaUrl
    )
        external
        returns (uint256 projectId)
    {
        require(!s_isVerified[msg.sender], ProjectIsVerified());

        // Perform basic checks on the provided information
        require(bytes(projectName).length > 0, ProjectNameCannotBeEmpty());
        require(bytes(description).length > 0, ProjectDescriptionCannotBeEmpty());
        require(bytes(websiteUrl).length > 0, WebsiteURLCannotBeEmpty());
        require(bytes(socialMediaUrl).length > 0, SocialMediaURLCannotBeEmpty());

        projectId = nextProjectId++;

        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: verifyUserCertificateSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectId, projectName, msg.sender, true, false, description, websiteUrl, socialMediaUrl)
        });

        spInstance.attest(a, "", "", "");
        s_isVerified[msg.sender] = true;

        return projectId;
    }

    /**
     * @notice Records the KYC verification status for a user.
     * @dev Creates an attestation for the user's KYC verification status.
     * @param user The address of the user being verified.
     * @param isVerified A boolean indicating whether the user has passed KYC verification (true) or not (false).
     */
    function recordKYCVerification(address user, bool isVerified) external onlyOwner {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(user);

        Attestation memory a = Attestation({
            schemaId: kycVerificationSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(user, isVerified, block.timestamp)
        });

        spInstance.attest(a, "", "", "");
        s_isKYCVerified[user] = isVerified;
    }

    //UNDO
    /**
     * @notice Records a CSV file upload for a project.
     * @dev Creates an attestation for the CSV file upload, including file hash and recipient count.
     * @param projectName The name of the project associated with the CSV file.
     * @param fileHash The hash of the uploaded CSV file for verification purposes.
     * @param recipientCount The number of recipients included in this CSV upload.
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
     * @dev Creates an attestation for the token deposit, including token address and amount.
     * @param projectName The name of the project associated with the token deposit.
     * @param tokenAddress The address of the ERC20 token being deposited.
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
     * @notice Records user consent for participating in projects.
     * @dev Creates an attestation for the user's consent status.
     * @param consentGiven A boolean indicating whether the user has given consent (true) or not (false).
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
     * @notice Issues a distribution certificate for a completed project distribution.
     * @dev Creates an attestation for the distribution certificate, including total amount and recipient count.
     * @param projectName The name of the project that completed the distribution.
     * @param totalAmount The total amount of tokens distributed in this distribution event.
     * @param recipientCount The number of recipients who received tokens in this distribution.
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
     * @dev Creates or updates an attestation to indicate that a refund agreement has been signed.
     * @param projectName The name of the project for which the refund agreement is being signed.
     */
    // function signRefundAgreement(string memory projectName) external {
    //     bytes[] memory recipients = new bytes[](1);
    //     recipients[0] = abi.encode(msg.sender);

    //     Attestation memory a = Attestation({
    //         schemaId: projectSchemaId,
    //         linkedAttestationId: 0,
    //         attestTimestamp: 0,
    //         revokeTimestamp: 0,
    //         attester: address(this),
    //         validUntil: 0,
    //         dataLocation: DataLocation.ONCHAIN,
    //         revoked: false,
    //         recipients: recipients,
    //         data: abi.encode(projectName, msg.sender, true, true) // name, owner, isVerified, hasRefundAgreement
    //      });

    //     spInstance.attest(a, "", "", "");
    // }

    /**
     * @notice Checks the verification status of a user's project.
     * @dev Returns whether the given address is associated with a verified project.
     * @param user The address of the user to check.
     * @return bool Returns true if the user's project is verified, false otherwise.
     */
    function getIsProjectVerified(address user) external view returns (bool) {
        return s_isVerified[user];
    }

    /**
     * @notice Checks the KYC verification status of a user.
     * @dev Returns whether the given address has passed KYC verification.
     * @param user The address of the user to check.
     * @return bool Returns true if the user has passed KYC verification, false otherwise.
     */
    function isVerifiedWithKYC(address user) external view returns (bool) {
        return s_isKYCVerified[user];
    }

    /**
     * @notice Checks the project ID of a user.
     * @dev Returns the ID of the project associated with the given user.
     * @param user The address of the user to check.
     * @return uint256 The ID of the project associated with the user.
     */
    function getProjectId(address user) external view returns (uint256) {
        return s_projectIds[user];
    }

    function getIsCsvUploaded() external view returns (bool) { }

    function getIsTokensLoked() external view returns (bool) { }
}
