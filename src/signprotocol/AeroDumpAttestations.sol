// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ISP } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@signprotocol/signprotocol-evm/src/models/DataLocation.sol";

contract AeroDump is Ownable {
    ISP public spInstance;

    error ProjectAlreadyRegistered();
    error NotAuthorizedToVerify();
    error ProjectNotRegisrtered();
    error NotProjectOwner();
    error ProjectNotVerified();
    error NoRefundAgreement();

    struct Project {
        address projectOwner;
        bool isVerified;
        bool hasRefundAgreement;
    }

    uint64 public projectVerificationSchemaId;
    uint64 public csvUploadSchemaId;
    uint64 public tokenDepositSchemaId;
    uint64 public userConsentSchemaId;
    uint64 public distributionCertificateSchemaId;
    uint64 public airdropExecutionSchemaId;

    mapping(string => Project) private s_projects;
    mapping(address => bool) private s_verifiers;

    constructor(address initialOwner, address _spInstance) Ownable(initialOwner) {
        spInstance = ISP(_spInstance);
    }

    function addVerifier(address verifier) external onlyOwner {
        s_verifiers[verifier] = true;
    }

    function registerProject(string memory projectName) external {
        require(s_projects[projectName].projectOwner == address(0), ProjectAlreadyRegistered());
        s_projects[projectName].projectOwner = msg.sender;

        bytes[] memory recipients = new bytes[](1);
        recipients[0] = abi.encode(msg.sender);

        Attestation memory a = Attestation({
            schemaId: projectVerificationSchemaId,
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

    function verifyProject(string memory projectName) external {
        require(s_verifiers[msg.sender], NotAuthorizedToVerify());
        require(s_projects[projectName].projectOwner != address(0), ProjectNotRegisrtered());

        s_projects[projectName].isVerified = true;
    }

    function recordCSVFileUpload(bytes32 fileHash, uint256 recipientCount) external { }

    function recordProjectTokenDeposit(string memory projectName, address tokenAddress, uint256 amount) external {
        require(s_projects[projectName].projectOwner == msg.sender, NotProjectOwner());
    }

    function recordUserConsent(bool consentGiven) external { }

    function recordNewsletterSent(string memory projectName, bytes32 messageHash, uint256 recipientCount) external {
        require(s_projects[projectName].projectOwner == msg.sender, NotProjectOwner());
    }

    function signRefundAgreement(string memory projectName) external {
        require(s_projects[projectName].projectOwner == msg.sender, NotProjectOwner());
        s_projects[projectName].hasRefundAgreement = true;
    }

    function issueDistributionCertificate(
        string memory projectName,
        uint256 totalAmount,
        uint256 recipientCount
    )
        external
    {
        require(s_projects[projectName].projectOwner == msg.sender, NotProjectOwner());
        require(s_projects[projectName].isVerified, ProjectNotVerified());
        require(s_projects[projectName].hasRefundAgreement, NoRefundAgreement());
    }

    function recordAirdropTransaction(uint256 recipientCount, uint256 totalAmount, bytes32 transactionHash) external { }
}
