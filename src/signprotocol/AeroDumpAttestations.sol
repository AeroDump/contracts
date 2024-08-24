// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ISPHook } from "@signprotocol/signprotocol-evm/src/interfaces/ISPHook.sol";

contract AeroDumpAttestations is Ownable, ISPHook {
    error ProjectAlreadyRegistered();
    error NotAuthorizedToVerify();
    error ProjectNotRegisrtered();
    error NotProjectOwner();
    error ProjectNotVerified();
    error NoRefundAgreement();

    struct Project {
        address owner;
        bool isVerified;
        bool hasRefundAgreement;
    }

    mapping(string => Project) private s_projects;
    mapping(address => bool) private s_verifiers;

    event ProjectRegistered(string indexed projectName, address indexed projectOwner);
    event ProjectVerified(string indexed projectName, address indexed projectOwner);
    event CSVFileUploaded(
        address indexed projectOwner, bytes32 indexed fileHash, uint256 indexed timestamp, uint256 recipientCount
    );
    event ProjectTokenDeposited(
        string indexed projectName, address indexed tokenAddress, uint256 indexed amount, uint256 timestamp
    );
    event UserConsentRecorded(address indexed user, bool indexed consentGiven, uint256 indexed timestamp);
    event NewsletterSent(
        string indexed projectName, bytes32 indexed messageHash, uint256 indexed recipientCount, uint256 timestamp
    );
    event RefundAgreementSigned(string indexed projectName, address indexed projectOwner);
    event DistributionCertificateIssued(
        string indexed projectName, uint256 indexed totalAmount, uint256 indexed recipientCount
    );
    event AirdropExecuted(
        address indexed projectOwner,
        uint256 indexed recipientCount,
        uint256 indexed totalAmount,
        bytes32 transactionHash
    );

    constructor(address initialOwner) Ownable(initialOwner) { }

    function addVerifier(address verifier) external onlyOwner {
        s_verifiers[verifier] = true;
    }

    function registerProject(string memory projectName) external {
        require(s_projects[projectName].owner == address(0), ProjectAlreadyRegistered());
        s_projects[projectName].owner = msg.sender;
        emit ProjectRegistered(projectName, msg.sender);
    }

    function verifyProject(string memory projectName) external {
        require(s_verifiers[msg.sender], NotAuthorizedToVerify());
        require(s_projects[projectName].owner != address(0), ProjectNotRegisrtered());

        s_projects[projectName].isVerified = true;

        emit ProjectVerified(projectName, s_projects[projectName].owner);
    }

    function recordCSVFileUpload(bytes32 fileHash, uint256 recipientCount) external {
        emit CSVFileUploaded(msg.sender, fileHash, block.timestamp, recipientCount);
    }

    function recordProjectTokenDeposit(string memory projectName, address tokenAddress, uint256 amount) external {
        require(s_projects[projectName].owner == msg.sender, NotProjectOwner());
        emit ProjectTokenDeposited(projectName, tokenAddress, amount, block.timestamp);
    }

    function recordUserConsent(bool consentGiven) external {
        emit UserConsentRecorded(msg.sender, consentGiven, block.timestamp);
    }

    function recordNewsletterSent(string memory projectName, bytes32 messageHash, uint256 recipientCount) external {
        require(s_projects[projectName].owner == msg.sender, NotProjectOwner());
        emit NewsletterSent(projectName, messageHash, recipientCount, block.timestamp);
    }

    function signRefundAgreement(string memory projectName) external {
        require(s_projects[projectName].owner == msg.sender, NotProjectOwner());
        s_projects[projectName].hasRefundAgreement = true;
        emit RefundAgreementSigned(projectName, msg.sender);
    }

    function issueDistributionCertificate(
        string memory projectName,
        uint256 totalAmount,
        uint256 recipientCount
    )
        external
    {
        require(s_projects[projectName].owner == msg.sender, NotProjectOwner());
        require(s_projects[projectName].isVerified, ProjectNotVerified());
        require(s_projects[projectName].hasRefundAgreement, NoRefundAgreement());

        emit DistributionCertificateIssued(projectName, totalAmount, recipientCount);
    }

    function recordAirdropTransaction(uint256 recipientCount, uint256 totalAmount, bytes32 transactionHash) external {
        emit AirdropExecuted(msg.sender, recipientCount, totalAmount, transactionHash);
    }

    function didReceiveAttestation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        bytes calldata extraData
    )
        external
        payable
        override
    { }

    function didReceiveAttestation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        IERC20 resolverFeeERC20Token,
        uint256 resolverFeeERC20Amount,
        bytes calldata extraData
    )
        external
        override
    { }

    function didReceiveRevocation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        bytes calldata extraData
    )
        external
        payable
        override
    { }

    function didReceiveRevocation(
        address attester,
        uint64 schemaId,
        uint64 attestationId,
        IERC20 resolverFeeERC20Token,
        uint256 resolverFeeERC20Amount,
        bytes calldata extraData
    )
        external
        override
    { }
}
