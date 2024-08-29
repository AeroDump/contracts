// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { OFTAdapter } from "@layerzerolabs/oft-evm/contracts/OFTAdapter.sol";
import { AutomationCompatibleInterface } from
    "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { AeroDumpAttestations } from "./signprotocol/AeroDumpAttestations.sol";

/**
 * @title AerodumpOFTAdapter
 * @author Aerodump
 * @notice This contract integrates with LayerZero protocol to inherit the vault standards for managing airdrop
 * transactions.
 * @notice This contract also integrates with chainlink automation to automate the transfer of rewards to recipients.
 * @dev This contract extends the OFTAdapter contract.
 * @dev Using an existing ERC20 token, this contract can be deployed on different addresses for different tokens.
 * @dev Consider we give in USDC address in constructor, airdrop will be done using *only* USDC.
 */
contract AerodumpOFTAdapter is OFTAdapter, AutomationCompatibleInterface {
    /**
     * @dev Struct representing an airdrop project.
     */
    struct project {
        bool isAirdropActive;
        uint256 projectId;
        address ownerOfTheProject;
        uint256 amountLockedInContract;
        uint256 incomingChainId;
        bool isSentToRecipients;
        address[] recipients;
        uint32[] outgoingChainIds;
    }

    /**
     * @dev Struct representing recipient details.
     */
    struct Recipient {
        uint256 projectId;
        uint32 dstChainId;
        address recipient;
        uint256 amountToSend;
    }

    /**
     * @dev Emitted when tokens are locked by a caller into this contract.
     */
    event AerodumpOFTAdapter__TokensLocked(address caller, uint256 projectId, uint256 amount, uint256 dstChainId);

    /**
     * @dev Emitted when tokens are credited to a recipient.
     */
    event AerodumpOFTAdapter__TokensCredited(address recipient, uint256 amount, uint256 dstChainId);

    AeroDumpAttestations attestationContract;

    /**
     * @dev Gobal counter for the project id
     */
    uint256 public PROJECT_ID;

    address public tokenAddress;
    /**
     * @dev Gobal counter indicating the starting index of the equal distribution queue.
     */
    uint256 public equalDistributionQueueFrontIndex;

    /**
     * @dev An arry of "Project" structs.
     */
    project[] public projects;

    /**
     * @dev An arry of "Recipient" structs that are waiting for airdrop with equal distribution.
     */
    Recipient[] public equalDistributionQueue;

    /**
     * @dev A mapping from the address of a project owner to the project id in the struct.
     */
    mapping(address => uint256) public userIndexes;

    /**
     * @dev A mapping from the project id to the project owner in the struct.
     */
    mapping(uint256 => address) public projectIdToOwner;

    /**
     * @dev Modifier to check if the user has a project.
     */
    modifier shouldHaveAnActiveProject() {
        require(
            userIndexes[msg.sender] > 0 && projects[userIndexes[msg.sender]].isAirdropActive,
            "You dont have an active project or your project isn't active!"
        );
        _;
    }

    // @dev Modifier to check if the project is verified
    modifier projectShouldBeVerified() {
        require(attestationContract.getIsProjectVerified(msg.sender), "Project is not verified");
        _;
    }

    // @dev Modifier to check if the project owner is KYC verified
    modifier projectOwnerShouldBeKYCVerified() {
        require(attestationContract.isVerifiedWithKYC(msg.sender), "Project owner is not KYC verified");
        _;
    }

    /**
     * @param _token Address of the existing ERC20 token that will be used for airdrops.
     * @param _layerZeroEndpoint LayerZero endpoint address
     * @param _owner Owner of the contract.
     */
    constructor(
        address _token,
        address _layerZeroEndpoint,
        address _owner,
        address _aeroDumpAttestationsAddress
    )
        OFTAdapter(_token, _layerZeroEndpoint, _owner)
        Ownable(_owner)
    {
        tokenAddress = _token;
        attestationContract = AeroDumpAttestations(_aeroDumpAttestationsAddress);
        PROJECT_ID;
        equalDistributionQueueFrontIndex = 0;
        project memory initialProject = project({
            isAirdropActive: false,
            projectId: 0,
            ownerOfTheProject: address(0),
            amountLockedInContract: 0,
            incomingChainId: 0,
            isSentToRecipients: false,
            recipients: new address[](0), // Empty address array
            outgoingChainIds: new uint32[](0) // Empty uint256 array
         });
        projects.push(initialProject);
    }

    /**
     * @notice This function locks in funds from the caller, to this contract.
     * @notice Only verified projects and verified project owners with sign KYC are allowed to call this function.
     * @notice Locked tokens can alse be updated by calling this function again.
     * @dev Tokens will remain locked untill the owner calls creditTo().
     * @dev Integrated with LayerZero.
     * @param _projectId ProjectId of the project the airdrop is associated with.
     * @param _amount Amount of tokens to be locked in this contract in local decimals.
     * @param _minAmount Min amount of tokens to be locked in this contract in local decimals.
     * @param _dstChainId ChainId of the chain that the tokens are on.
     * @return amountSent Amount of tokens sent by the caller.
     * @return amountRecievedByRemote Amount of tokens received by remote(layerzero/this contract) .
     */
    function lockTokens(
        uint256 _projectId,
        uint256 _amount,
        uint256 _minAmount,
        uint32 _dstChainId
    )
        external
        //projectOwnerShouldBeKYCVerified
        projectShouldBeVerified
        returns (uint256 amountSent, uint256 amountRecievedByRemote)
    {
        //LayerZero function _debit that handles the actual debit using vault standards.
        (amountSent, amountRecievedByRemote) = _debit(msg.sender, _amount, _minAmount, _dstChainId);

        if (userIndexes[msg.sender] == 0) {
            project memory temp;
            temp.isAirdropActive = true;
            temp.projectId = _projectId;
            temp.ownerOfTheProject = msg.sender;
            temp.amountLockedInContract = _amount;
            temp.incomingChainId = _dstChainId;
            temp.isSentToRecipients = false;
            temp.recipients = new address[](0);
            temp.outgoingChainIds = new uint32[](0);
            projects.push(temp);
            userIndexes[msg.sender] = PROJECT_ID;
            projectIdToOwner[_projectId] = msg.sender;
            PROJECT_ID = PROJECT_ID + 1;
        } else {
            projects[userIndexes[msg.sender]].amountLockedInContract += _amount;
        }

        attestationContract.recordLockTokens(_projectId, tokenAddress, _amount);

        emit AerodumpOFTAdapter__TokensLocked(msg.sender, _projectId, _amount, _dstChainId);
        return (amountSent, amountRecievedByRemote);
    }

    /**
     *
     * @notice Queues all the recipients in the same project for airdrop with equal distribution.
     * @dev Callable by the project owner.
     * @dev FOR FE DEVS, METHOD WITH PASING ADDRESSES WITH COMMA AND EQUAL DISTRIBUTION, NO CSV.
     * @param _recipients Recipients to be aidropped.
     */
    function queueAirdropWithEqualDistribution(
        uint256 _projectId,
        address[] memory _recipients,
        uint32 _dstChainId
    )
        external
        shouldHaveAnActiveProject
        projectShouldBeVerified
    //projectOwnerShouldBeKYCVerified
    {
        require(projects[userIndexes[msg.sender]].amountLockedInContract > 0, "Lock some money first!");
        require(_projectId == projects[userIndexes[msg.sender]].projectId, "Wrong project!");
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(attestationContract.isVerifiedWithKYC(_recipients[i]), "Recipient must do KYC!");
            equalDistributionQueue.push(
                Recipient({
                    projectId: _projectId,
                    dstChainId: _dstChainId,
                    recipient: _recipients[i],
                    amountToSend: (projects[userIndexes[msg.sender]].amountLockedInContract) / _recipients.length
                })
            );
        }
    }

    /**
     *  @dev this method is called by the Chainlink Automation Nodes to check if `performUpkeep` must be done. Note that
     * `checkData` is used to segment the computation to subarrays.
     *  @dev `checkData` is an encoded binary data and which contains the lower bound and upper bound on which to
     * perform the computation
     *  @dev return `upkeepNeeded`if rebalancing must be done and `performData` which contains an array of indexes that
     * require rebalancing and their increments. This will be used in `performUpkeep`
     *  @dev Returns true when there are elements in the equalDistributionQueue.
     */
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        if (equalDistributionQueue.length == 0) {
            upkeepNeeded = false;
            return (upkeepNeeded, "null");
        } else {
            upkeepNeeded = true;

            return (upkeepNeeded, "null");
        }
    }

    /**
     * @dev This function is only for testing purposes.
     */
    function fakeCheckUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        returns (bool upkeepNeeded, bytes memory performData)
    {
        if (equalDistributionQueue.length == 0) {
            upkeepNeeded = false;
            return (upkeepNeeded, "null");
        } else {
            upkeepNeeded = true;

            return (upkeepNeeded, "null");
        }
    }

    /**
     *  @dev this method is called by the Automation Nodes. it increases all elements whose balances are lower than the
     * LIMIT. Note that the elements are bounded by `lowerBound`and `upperBound`
     *  (provided by `performData`
     *  @dev `performData` is an encoded binary data which contains the lower bound and upper bound of the subarray on
     * which to perform the computation.
     *  it also contains the increments
     *  @dev return `upkeepNeeded`if rebalancing must be done and `performData` which contains an array of increments.
     * This will be used in `performUpkeep`
     */
    function performUpkeep(bytes calldata /*performData*/ ) external override {
        require(equalDistributionQueueFrontIndex < equalDistributionQueue.length, "Array out of bounds");
        uint256 amountRecieved = creditTo(
            equalDistributionQueue[equalDistributionQueueFrontIndex].recipient,
            equalDistributionQueue[equalDistributionQueueFrontIndex].amountToSend,
            equalDistributionQueue[equalDistributionQueueFrontIndex].dstChainId
        );
        projects[userIndexes[projectIdToOwner[equalDistributionQueue[equalDistributionQueueFrontIndex].projectId]]]
            .amountLockedInContract -= amountRecieved;
        projects[userIndexes[projectIdToOwner[equalDistributionQueue[equalDistributionQueueFrontIndex].projectId]]]
            .isSentToRecipients = true;
        delete equalDistributionQueue[equalDistributionQueueFrontIndex];
        equalDistributionQueueFrontIndex++;
    }

    /**
     * @dev This function is only for testing purposes.
     */
    function fakePerformUpkeep(bytes calldata /*performData */ ) external {
        require(equalDistributionQueueFrontIndex < equalDistributionQueue.length, "Array out of bounds");
        uint256 amountRecieved = creditTo(
            equalDistributionQueue[equalDistributionQueueFrontIndex].recipient,
            equalDistributionQueue[equalDistributionQueueFrontIndex].amountToSend,
            equalDistributionQueue[equalDistributionQueueFrontIndex].dstChainId
        );
        projects[userIndexes[projectIdToOwner[equalDistributionQueue[equalDistributionQueueFrontIndex].projectId]]]
            .amountLockedInContract -= amountRecieved;
        projects[userIndexes[projectIdToOwner[equalDistributionQueue[equalDistributionQueueFrontIndex].projectId]]]
            .isSentToRecipients = true;
        delete equalDistributionQueue[equalDistributionQueueFrontIndex];
        equalDistributionQueueFrontIndex++;
    }

    /**
     * @notice Credits tokens to the recipient.
     * @dev Integrated with LayerZero.
     */
    function creditTo(address _to, uint256 _amount, uint32 _chainId) internal returns (uint256 amountRecieved) {
        //LayerZero function _credit that handles the actual credit to recipients using vault standards.
        amountRecieved = _credit(_to, _amount, _chainId);
        emit AerodumpOFTAdapter__TokensCredited(msg.sender, _amount, _chainId);
        return amountRecieved;
    }

    /**
     * @notice Returns the project details for the project owner.
     * @return Project struct.
     */
    function getProjectDetailsForProjectOwner()
        public
        view
        shouldHaveAnActiveProject
        projectOwnerShouldBeKYCVerified
        projectShouldBeVerified
        returns (project memory)
    {
        return projects[userIndexes[msg.sender]];
    }
}
