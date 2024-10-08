// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OFTAdapter} from "@layerzerolabs/oft-evm/contracts/OFTAdapter.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {OApp, MessagingFee, Origin} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {ILayerZeroComposer} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroComposer.sol";
import {OptionsBuilder} from "../library/OptionsBuilder.sol";

/**
 * @title AerodumpOFTAdapter
 * @author Aerodump
 * @notice This contract integrates with LayerZero protocol to inherit the vault standards for managing airdrop
 * transactions.
 * @notice This contracts also receives the attestations data from base sepolia, using LayerZero omnichain messaging.
 * @notice This contract also integrates with chainlink automation to automate the transfer of rewards to recipients.
 * @dev This contract extends the OFTAdapter contract.
 * @dev Using an existing ERC20 token, this contract can be deployed on different addresses for different tokens.
 * @dev Consider we give in USDC address in constructor, airdrop will be done using *only* USDC.
 */
contract AerodumpOFTAdapter is
    OFTAdapter,
    AutomationCompatibleInterface,
    ILayerZeroComposer
{
    using OptionsBuilder for bytes;
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
     * @dev Emitted when a user is verified, i.e when attestations contract sends the verified user address to this via
     * compose call.
     */
    event AerodumpOFTAdapter__UserVerified(address user, uint256 projectId);

    /**
     * @dev Emitted when tokens are locked by a caller into this contract.
     */
    event AerodumpOFTAdapter__TokensLocked(
        address caller,
        uint256 projectId,
        uint256 amount,
        uint256 dstChainId
    );

    /**
     * @dev Emitted when tokens are credited to a recipient.
     */
    event AerodumpOFTAdapter__TokensCredited(
        address recipient,
        uint256 amount,
        uint256 dstChainId
    );

    /**
     * @dev Emitted when an airdrop is queued.
     */
    event AerodumpOFTAdapter__AirdropQueued(
        uint256 projectId,
        address[] recipients,
        uint32 dstChainId
    );

    /**
     * @dev Emitted when an airdrop is queued with unequal CSV distribution.
     */
    event AerodumpOFTAdapter__AirdropQueuedWithUnequalCSVDistribution(
        Recipient[] recipients
    );

    /**
     * @dev Emitted when the contract checks if upkeep is needed.
     */
    event AerodumpOFTAdapter__CheckUpkeep(
        bool upkeepNeeded,
        uint256 equalDistributionQueueLength,
        uint256 unequalDistributionCSVQueueLength
    );

    /**
     * @dev Global variable for token address used in this deployment.
     */
    address public TOKEN_ADDRESS;

    /**
     * @notice The address of AeroDumpComposer contract.
     */
    address public composer;

    /**
     * @dev Layerzero eid for AeroDumpComposer.
     */
    uint32 public composerSecondEid;

    /**
     * @dev Layerzero eid for the AeroDumpAttestations.
     */
    uint32 public attestationsEid;

    /**
     * @dev Gobal counter indicating the starting index of the equal distribution queue.
     */
    uint256 public equalDistributionQueueFrontIndex;

    /**
     * @dev Gobal counter indicating the starting index of the unequal distribution queue.
     */
    uint256 public unequalDistributionCSVQueueFrontIndex;

    /**
     * @dev An arry of "Project" structs.
     */
    project[] public projects;

    /**
     * @dev An arry of "Recipient" structs that are waiting for airdrop with equal distribution.
     */
    Recipient[] public equalDistributionQueue;

    /**
     * @dev An array of "Recipient" structs that are waiting for airdrop with unequal distribution.
     */
    Recipient[] public unequalDistributionCSVQueue;

    /**
     * @dev A mapping from the address of a project owner to the project id in the struct.
     */
    mapping(address => uint256) public projectOwnerToId;

    /**
     * @dev A mapping from the project id to the project owner in the struct.
     */
    mapping(uint256 => address) public projectIdToOwner;

    /**
     * @dev A mapping from the verified project owner address to bool.
     */
    mapping(address => bool) public isVerifiedUser;

    /**
     * @dev A mapping from the address of a project owner to bool indicating tokens are locked.
     */
    mapping(address => bool) public is_lockedTokens;

    /**
     * @dev Modifier to check if the user has a project.
     */
    modifier shouldHaveAnActiveProject() {
        require(
            projects[projectOwnerToId[msg.sender]].isAirdropActive == true,
            "You dont have a project or your project isn't active!"
        );
        _;
    }

    /**
     * @dev Modifier to check if caller is AeroDumpComposer.
     */
    modifier onlyComposer() {
        require(msg.sender == composer, "Only composer can call this function");
        _;
    }

    /**
     * @dev Modifier to check if the user is verified in AeroDumpAttestations.
     */
    modifier projectShouldBeVerified() {
        require(isVerifiedUser[msg.sender], "Project owner must be verified!");
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
        address _owner
    )
        // address _aeroDumpAttestationsAddress
        OFTAdapter(_token, _layerZeroEndpoint, _owner)
        Ownable(_owner)
    {
        TOKEN_ADDRESS = _token;
        equalDistributionQueueFrontIndex = 0;
    }

    /**
     *
     * @notice Sets the address for AeroDumpComposer.
     */
    function setComposer(address _composer) external onlyOwner {
        composer = _composer;
    }

    /**
     * @notice Sets the AeroDumpComposer endpoint ID.
     * @param _dstEid The destination endpoint ID.
     */
    function setComposerSecondEid(uint32 _dstEid) external onlyOwner {
        composerSecondEid = _dstEid;
    }

    /**
     * @notice Sets the AeroDumpComposer endpoint ID.
     * @param _dstEid The destination endpoint ID.
     */
    function setAttestationsEid(uint32 _dstEid) external onlyOwner {
        attestationsEid = _dstEid;
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
        payable
        //projectOwnerShouldBeKYCVerified
        projectShouldBeVerified
        returns (uint256 amountSent, uint256 amountRecievedByRemote)
    {
        //LayerZero function _debit that handles the actual debit using vault standards.
        (amountSent, amountRecievedByRemote) = _debit(
            msg.sender,
            _amount,
            _minAmount,
            _dstChainId
        );

        // if (projects[projectOwnerToId[msg.sender]].incomingChainId > 0) {
        //     projects[projectOwnerToId[msg.sender]]
        //         .amountLockedInContract += _amount;
        // } else {
        project memory temp;
        temp.isAirdropActive = true;
        temp.projectId = _projectId;
        temp.ownerOfTheProject = projectIdToOwner[_projectId];
        temp.amountLockedInContract = _amount;
        temp.incomingChainId = _dstChainId;
        temp.isSentToRecipients = false;
        temp.recipients = new address[](0);
        temp.outgoingChainIds = new uint32[](0);
        projects.push(temp);
        // }

        emit AerodumpOFTAdapter__TokensLocked(
            msg.sender,
            _projectId,
            _amount,
            _dstChainId
        );

        // bytes memory payload = abi.encode(msg.sender, _amount);
        // bytes memory aerodumpOptions = OptionsBuilder
        //     .newOptions()
        //     .addExecutorLzReceiveOption(70000, 0);

        // _lzSend(
        //     attestationsEid,
        //     payload, // Send encoded projectName
        //     aerodumpOptions,
        //     MessagingFee(msg.value, 0),
        //     payable(msg.sender)
        // );
        // is_lockedTokens[msg.sender] = true;

        // Prepare params for LayerZero send method
        bytes memory payload = abi.encode(_amount); // Send address of verified user and project ID
        bytes memory options = OptionsBuilder
            .newOptions()
            .addExecutorLzReceiveOption(80000, 0)
            .addExecutorLzComposeOption(0, 80000, 0);

        _lzSend(
            composerSecondEid,
            payload, // Send encoded projectName
            options,
            MessagingFee(msg.value, 0),
            payable(msg.sender)
        );
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
        require(
            projects[projectOwnerToId[msg.sender]].amountLockedInContract > 0,
            "Lock some money first!"
        );
        require(_projectId == projectOwnerToId[msg.sender], "Wrong project!");
        for (uint256 i = 0; i < _recipients.length; i++) {
            // require(
            //     attestationContract.isVerifiedWithKYC(_recipients[i]),
            //     "Recipient must do KYC!"
            // );
            equalDistributionQueue.push(
                Recipient({
                    projectId: _projectId,
                    dstChainId: _dstChainId,
                    recipient: _recipients[i],
                    amountToSend: (
                        projects[projectOwnerToId[msg.sender]]
                            .amountLockedInContract
                    ) / _recipients.length
                })
            );
        }

        emit AerodumpOFTAdapter__AirdropQueued(
            _projectId,
            _recipients,
            _dstChainId
        );
    }

    function queueAirdropWithUnequalCSVDistribution(
        Recipient[] memory _recipientsData
    )
        external
        shouldHaveAnActiveProject
        projectShouldBeVerified
    //projectOwnerShouldBeKYCVerified
    {
        for (uint256 i = 0; i < _recipientsData.length; i++) {
            // require(
            //     attestationContract.isVerifiedWithKYC(_recipients[i]),
            //     "Recipient must do KYC!"
            // );
            require(
                _recipientsData[i].amountToSend <
                    projects[_recipientsData[i].projectId]
                        .amountLockedInContract,
                "Enter Less amount than locked!"
            );

            require(
                projects[_recipientsData[i].projectId].amountLockedInContract >
                    0,
                "Lock some money first!"
            );

            unequalDistributionCSVQueue.push(
                Recipient({
                    projectId: _recipientsData[i].projectId,
                    dstChainId: _recipientsData[i].dstChainId,
                    recipient: _recipientsData[i].recipient,
                    amountToSend: _recipientsData[i].amountToSend
                })
            );
        }
        emit AerodumpOFTAdapter__AirdropQueuedWithUnequalCSVDistribution(
            _recipientsData
        );
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
    ) external view returns (bool upkeepNeeded, bytes memory performData) {
        if (
            equalDistributionQueue.length > 0 ||
            unequalDistributionCSVQueue.length > 0
        ) {
            upkeepNeeded = true;
            return (upkeepNeeded, "null");
        } else {
            upkeepNeeded = false;
            return (upkeepNeeded, "null");
        }
    }

    /**
     * @dev This function is only for testing purposes.
     */
    function fakeCheckUpkeep(
        bytes calldata /* checkData */
    ) external view returns (bool upkeepNeeded, bytes memory performData) {
        if (
            equalDistributionQueue.length > 0 ||
            unequalDistributionCSVQueue.length > 0
        ) {
            upkeepNeeded = true;
            return (upkeepNeeded, "null");
        } else {
            upkeepNeeded = false;
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
    function performUpkeep(bytes calldata /*performData*/) external override {
        equalDistributionHelper();
        unequalDistributionHelper();
    }

    /**
     * @dev This function is only for testing purposes.
     */
    function fakePerformUpkeep(bytes calldata /*performData */) external {
        equalDistributionHelper();
        unequalDistributionHelper();
    }

    /**
     * @notice Handles incoming composed messages from LayerZero.
     * @dev receives verified project id and project owner address from AeroDumpAttestations Through AeroDumpComposer.
     * @dev Decodes the message payload and updates the state, sets isVerifiedUser as true.
     * @param _oApp The address of the originating OApp.
     */
    function lzCompose(
        address _oApp,
        bytes32 /*_guid*/,
        bytes calldata _message,
        address,
        bytes calldata
    ) external payable override {
        // Decode the string message (projectName)
        (address user, uint256 projectId) = abi.decode(
            _message,
            (address, uint256)
        );

        // Verify the user on this contract
        isVerifiedUser[user] = true;
        projectOwnerToId[user] = projectId;
        projectIdToOwner[projectId] = user;
        // Update the state
        // Do something with the projectName (e.g., log it or update state)
        // data = projectName;

        emit AerodumpOFTAdapter__UserVerified(user, projectId);
    }

    /**
     * @notice This function takes in the first element of the equalDistributionQueue and sends the airdrop amount.
     * @dev This internal function is called by the `performUpkeep` function to automate sending of airdrops.
     */
    function equalDistributionHelper() internal {
        if (equalDistributionQueue.length == 0) return;
        require(
            equalDistributionQueueFrontIndex < equalDistributionQueue.length,
            "Array out of bounds"
        );
        uint256 amountRecieved = creditTo(
            equalDistributionQueue[equalDistributionQueueFrontIndex].recipient,
            equalDistributionQueue[equalDistributionQueueFrontIndex]
                .amountToSend,
            equalDistributionQueue[equalDistributionQueueFrontIndex].dstChainId
        );
        projects[
            projectOwnerToId[
                projectIdToOwner[
                    equalDistributionQueue[equalDistributionQueueFrontIndex]
                        .projectId
                ]
            ]
        ].amountLockedInContract -= amountRecieved;
        projects[
            projectOwnerToId[
                projectIdToOwner[
                    equalDistributionQueue[equalDistributionQueueFrontIndex]
                        .projectId
                ]
            ]
        ].isSentToRecipients = true;
        delete equalDistributionQueue[equalDistributionQueueFrontIndex];
        equalDistributionQueueFrontIndex++;
    }

    /**
     * @notice This function takes in the first element of the unequalDistributionQueue and sends the airdrop amount.
     * @dev This internal function is called by the `performUpkeep` function to automate sending of airdrops.
     */
    function unequalDistributionHelper() internal {
        if (unequalDistributionCSVQueue.length == 0) return;
        require(
            unequalDistributionCSVQueueFrontIndex <
                unequalDistributionCSVQueue.length,
            "Array out of bounds"
        );
        uint256 amountRecieved = creditTo(
            unequalDistributionCSVQueue[unequalDistributionCSVQueueFrontIndex]
                .recipient,
            unequalDistributionCSVQueue[unequalDistributionCSVQueueFrontIndex]
                .amountToSend,
            unequalDistributionCSVQueue[unequalDistributionCSVQueueFrontIndex]
                .dstChainId
        );
        projects[
            projectOwnerToId[
                projectIdToOwner[
                    unequalDistributionCSVQueue[
                        unequalDistributionCSVQueueFrontIndex
                    ].projectId
                ]
            ]
        ].amountLockedInContract -= amountRecieved;
        projects[
            projectOwnerToId[
                projectIdToOwner[
                    unequalDistributionCSVQueue[
                        unequalDistributionCSVQueueFrontIndex
                    ].projectId
                ]
            ]
        ].isSentToRecipients = true;
        delete unequalDistributionCSVQueue[
            unequalDistributionCSVQueueFrontIndex
        ];
        unequalDistributionCSVQueueFrontIndex++;
    }

    /**
     * @notice Credits tokens to the recipient.
     * @dev Integrated with LayerZero.
     */
    function creditTo(
        address _to,
        uint256 _amount,
        uint32 _chainId
    ) internal returns (uint256 amountRecieved) {
        //LayerZero function _credit that handles the actual credit to recipients using vault standards.
        amountRecieved = _credit(_to, _amount, _chainId);
        emit AerodumpOFTAdapter__TokensCredited(msg.sender, _amount, _chainId);
        return amountRecieved;
    }

    /**
     * @notice Returns the project details for the project owner.
     * @param _user Address of the project owner.
     * @return Project struct.
     */
    function getProjectDetailsByAddress(
        address _user
    )
        public
        view
        shouldHaveAnActiveProject
        projectShouldBeVerified
        returns (project memory)
    {
        return projects[projectOwnerToId[_user]];
    }

    /**
     * @notice Returns the project details for the project owner.
     * @param _projectId Project Id of the project owner.
     * @return Project struct.
     */
    function getProjectDetailsById(
        uint256 _projectId
    )
        public
        view
        shouldHaveAnActiveProject
        projectShouldBeVerified
        returns (project memory)
    {
        return projects[_projectId];
    }

    /**
     * @notice Returns the project Id of the project owner.
     * @param user Address of the project owner.
     * @return uint256 Project Id.
     */
    function getProjectOwnerToId(address user) public view returns (uint256) {
        return projectOwnerToId[user];
    }

    /**
     * @notice Returns true if the project owner is verified.
     * @param projectOwner Address of the project owner.
     * @return bool Is user verified.
     */
    function getIsUserVerified(
        address projectOwner
    ) public view returns (bool) {
        return isVerifiedUser[projectOwner];
    }

    /**
     * @notice Returns the address of the project owner.
     * @param projectId Project Id of the project owner.
     * @return address Project owner.
     */
    function getProjectIdToOwner(
        uint256 projectId
    ) public view returns (address) {
        return projectIdToOwner[projectId];
    }

    /**
     * @notice Returns the token address used for this deployment.
     * @return address Token address.
     */
    function getTokenAddress() public view returns (address) {
        return TOKEN_ADDRESS;
    }

    /**
     * @notice Returns the first element of the equal distribution queue.
     * @return Recipient struct.
     */
    function getEqualDistributionRecipientQueueFront()
        public
        view
        returns (Recipient memory)
    {
        return equalDistributionQueue[equalDistributionQueueFrontIndex];
    }

    /**
     * @notice Returns the first element of the unequal distribution queue.
     * @return Recipient struct.
     */
    function getUnequalDistributionCSVRecipientQueueFront()
        public
        view
        returns (Recipient memory)
    {
        return
            unequalDistributionCSVQueue[unequalDistributionCSVQueueFrontIndex];
    }

    function getIsLockedTokens(address user) public view returns (bool) {
        return is_lockedTokens[user];
    }
}
