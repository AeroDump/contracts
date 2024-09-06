// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ISP } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@signprotocol/signprotocol-evm/src/models/DataLocation.sol";
import { OApp, MessagingFee, Origin } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import { OptionsBuilder } from "../library/OptionsBuilder.sol";

/**
 * @title AeroDumpAttestations
 * @author AeroDump
 * @notice This contract manages various attestations for a multi-sender platform.
 * @dev It utilizes Sign Protocol's attestation system to store project-related data securely.
 */
contract AeroDumpAttestations is Ownable, OApp {
    event AeroDumpAttestations__TokensLocked(address projectOwner, uint256 amount);

    using OptionsBuilder for bytes;
    // @dev The instance of the Sign Protocol interface.

    ISP public spInstance;

    uint256 public AMOUNT;

    // @dev Custom error for when a user is not authorized to verify a project.
    error ProjectIsVerified();
    error ProjectNameCannotBeEmpty();
    error ProjectDescriptionCannotBeEmpty();
    error WebsiteURLCannotBeEmpty();
    error SocialMediaURLCannotBeEmpty();

    // @dev Schema IDs for different types of attestations.
    uint64 public verifyCertificateSchemaId;
    uint64 public kycVerificationSchemaId;
    uint64 public tokenDepositSchemaId;
    uint64 public distributionCertificateSchemaId;

    // @dev The next project ID to be assigned.
    uint256 private nextProjectId;

    // @dev Layerzero eid for AeroDumpComposer
    uint32 public composerEid;

    // @dev Mapping of addresses to boolean indicating whether they are verified project managers.
    mapping(address => bool) private s_isVerified;
    mapping(address => bool) private s_isKYCVerified; // New mapping for KYC verification status
    mapping(address => uint256) private s_projectIds; // Add this mapping to keep track of project IDs
    mapping(address => bool) private s_lockedTokens; // New mapping for locked tokens

    /**
     * @dev Constructor initializes the Sign Protocol instance.
     * @param initialOwner The address of the contract owner.
     * @param _spInstance The address of the Sign Protocol instance.
     * @param _endpoint The address of this OApp Layerzero endpoint.
     */
    constructor(
        address initialOwner,
        address _spInstance,
        address _endpoint
    )
        OApp(_endpoint, initialOwner)
        Ownable(initialOwner)
    {
        spInstance = ISP(_spInstance);
    }

    /**
     * @notice Sets schema IDs for different types of attestations.
     * @dev This function must be called after deploying the contract to initialize the schema IDs.
     * @param _verifyCertificateSchemaId Schema ID for project verification attestations.
     * @param _kycVerificationSchemaId Schema ID for KYC verification attestations.
     * @param _tokenDepositSchemaId Schema ID for token deposit attestations.
     * @param _distributionCertificateSchemaId Schema ID for distribution certificate attestations.
     */
    function setSchemaIds(
        uint64 _verifyCertificateSchemaId,
        uint64 _kycVerificationSchemaId,
        uint64 _tokenDepositSchemaId,
        uint64 _distributionCertificateSchemaId
    )
        external
        onlyOwner
    {
        verifyCertificateSchemaId = _verifyCertificateSchemaId;
        kycVerificationSchemaId = _kycVerificationSchemaId;
        tokenDepositSchemaId = _tokenDepositSchemaId;
        distributionCertificateSchemaId = _distributionCertificateSchemaId;
    }

    /**
     * @notice Sets the AeroDumpComposer endpoint ID.
     * @param _dstEid The destination endpoint ID.
     */
    function setComposerEid(uint32 _dstEid) external onlyOwner {
        composerEid = _dstEid;
    }

    /**
     * @notice Verifies a project by recording detailed information.
     * @dev Creates an attestation for project verification. This function can only be called once per address.
     * @dev Integrated with LayerZero omnichain messaging to send the verified address to AeroDumpComposer.
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
        payable
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
            schemaId: verifyCertificateSchemaId,
            linkedAttestationId: 0,
            attestTimestamp: 0,
            revokeTimestamp: 0,
            attester: address(this),
            validUntil: 0,
            dataLocation: DataLocation.ONCHAIN,
            revoked: false,
            recipients: recipients,
            data: abi.encode(projectName, description, websiteUrl, socialMediaUrl)
        });

        spInstance.attest(a, "", "", "");
        s_isVerified[msg.sender] = true;
        s_projectIds[msg.sender] = projectId;

        // Prepare params for LayerZero send method
        bytes memory payload = abi.encode(msg.sender, projectId); // Send address of verified user and project ID
        bytes memory options =
            OptionsBuilder.newOptions().addExecutorLzReceiveOption(100_000, 0).addExecutorLzComposeOption(0, 100_000, 0);

        _lzSend(
            composerEid,
            payload, // Send encoded projectName
            options,
            MessagingFee(msg.value, 0),
            payable(msg.sender)
        );

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
            data: abi.encode(user, isVerified)
        });

        spInstance.attest(a, "", "", "");
        s_isKYCVerified[user] = isVerified;
    }

    /**
     * @notice Records a token deposit for a project.
     * @dev Creates an attestation for the token deposit, including token address and amount.
     * @param tokenAddress The address of the ERC20 token being deposited.
     * @param amount The amount of tokens being deposited.
     */
    function recordLockTokens(
        address projectOwner,
        // uint256 projectId,
        address tokenAddress,
        uint256 amount
    )
        internal
    {
        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);
        uint256 projectId = getProjectId(projectOwner);
        s_lockedTokens[projectOwner] = true;

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
            data: abi.encode(projectId, tokenAddress, amount)
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
            data: abi.encode(projectName, totalAmount, recipientCount)
        });

        spInstance.attest(a, "", "", "");
    }

    /**
     * @notice Layerzero send method, unaltered.
     * @dev This function us used to test omnichain messaging, custom _lzSend is already implemented in verifyProject.
     * @param _dstEid LayerZero endpoint ID.
     * @param _message Message to be sent.
     */
    function send(uint32 _dstEid, string memory _message) external payable {
        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        bytes memory options = OptionsBuilder.newOptions().addExecutorLzReceiveOption(60_000, 0);
        _lzSend(
            _dstEid,
            _payload,
            options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    /**
     * @dev Called when data is received from the protocol. It overrides the equivalent function in the parent contract.
     * Protocol messages are defined as packets, comprised of the following parameters.
     * @param _origin A struct containing information about where the packet came from.
     * @param _guid A global unique identifier for tracking the packet.
     * @param payload Encoded message.
     */
    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address, // Executor address as specified by the OApp.
        bytes calldata // Any extra data or options to trigger on receipt.
    )
        internal
        override
    {
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        (uint256 amount) = abi.decode(payload, (uint256));
        AMOUNT = amount;
        // AMOUNT = amount;
        // recordLockTokens(
        //     projectOwner,
        //     0x5fd84259d66Cd46123540766Be93DFE6D43130D7,
        //     amount
        // );
        //s_lockedTokens[projectOwner] = true;
        emit AeroDumpAttestations__TokensLocked(address(0), amount);
    }

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
    function getProjectId(address user) public view returns (uint256) {
        return s_projectIds[user];
    }

    /**
     * @notice Checks the locked tokens of a user.
     * @dev Returns whether the given address has locked tokens.
     * @return bool Returns true if the user has locked tokens, false otherwise.
     */
    function getIsTokensLocked(address user) external view returns (bool) {
        return s_lockedTokens[user];
    }

    function getIsCsvUploaded() external view returns (bool) { }
}
