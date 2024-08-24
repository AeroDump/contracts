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

    event ProjectRegistered(string indexed projectName, address indexed owner);
    event ProjectVerified(string indexed projectName, address indexed owner);
    event RefundAgreementSigned(string indexed projectName, address indexed owner);
    event DistributionCertificateIssued(
        string indexed projectName, uint256 indexed totalAmount, uint256 indexed recipientCount
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
