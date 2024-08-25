// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {OFTAdapter} from "@layerzerolabs/oft-evm/contracts/OFTAdapter.sol";
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AerodumpOFTAdapter
 * @author Aerodump
 * @notice This contract integrates with LayerZero protocol to inherit the vault standards for managing airdrop transactions.
 * @dev This contract extends the OFTAdapter contract.
 * @dev Using an existing ERC20 token, this contract can be deployed on different addresses for different tokens.
 * @dev Consider we give in USDC address in constructor, airdrop will be done using *only* USDC.
 */

contract AerodumpOFTAdapter is OFTAdapter, AutomationCompatibleInterface {
    /**
     * @dev Struct representing an airdrop project.
     */
    struct Project {
        bool isAirdropActive;
        uint256 projectId;
        address ownerOfTheProject;
        uint256 amountLockedInContract;
        uint256 incomingChainId;
        bool isSentToRecipients;
        address[] recipients;
        uint256[] outgoingChainIds;
    }

    struct Recipient {
        uint256 projectId;
        uint256 dstChainId;
        address recipient;
        uint256 amountToSend;
    }

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
     * @dev Gobal counter for the project id
     */
    uint256 internal PROJECT_ID;

    /**
     * @dev An arry of "Project" structs.
     */
    Project[] internal projects;

    Recipient[] internal equalDistributionQueue;

    /**
     * @dev A mapping from the address of a project owner to the project id in the struct.
     */
    mapping(address => uint256) public userIndexes;

    /**
     * @dev Modifier to check if the user has a project.
     */
    modifier shouldHaveAnActiveProject() {
        require(
            userIndexes[msg.sender] > 0 &&
                projects[userIndexes[msg.sender]].isAirdropActive,
            "You dont have an active project or your project isn't active!"
        );
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
    ) OFTAdapter(_token, _layerZeroEndpoint, _owner) Ownable(_owner) {
        PROJECT_ID = 1;
        Project memory initialProject = Project({
            isAirdropActive: false,
            projectId: 0,
            ownerOfTheProject: address(0),
            amountLockedInContract: 0,
            incomingChainId: 0,
            isSentToRecipients: false,
            recipients: new address[](0), // Empty address array
            outgoingChainIds: new uint256[](0) // Empty uint256 array
        });
        projects.push(initialProject);
    }

    /**
     * @notice This function locks in funds from the caller, to this contract.
     * @notice Only verified projects and verified project owners with sign KYC are allowed to call this function.
     * @notice Locked tokens can alse be updated by calling this function again.
     * @dev Tokens will remain locked untill the owner calls creditTo().
     * @param _projectId ProjectId of the project the airdrop is associated with.
     * @param _amount Amount of tokens to be locked in this contract in local decimals.
     * @param _minAmount Min amount of tokens to be locked in this contract in local decimals.
     * @param _dstChainId ChainId of the chain that the tokens are on.
     */
    function lockTokens(
        uint256 _projectId,
        uint256 _amount,
        uint256 _minAmount,
        uint32 _dstChainId
    ) external {
        _debit(msg.sender, _amount, _minAmount, _dstChainId);

        if (userIndexes[msg.sender] == 0) {
            Project memory temp;
            temp.isAirdropActive = true;
            temp.projectId = _projectId;
            temp.ownerOfTheProject = msg.sender;
            temp.amountLockedInContract = _amount;
            temp.incomingChainId = _dstChainId;
            temp.isSentToRecipients = false;
            temp.recipients = new address[](0);
            temp.outgoingChainIds = new uint256[](0);
            projects.push(temp);
            userIndexes[msg.sender] = PROJECT_ID;
            PROJECT_ID = PROJECT_ID + 1;
        } else {
            projects[userIndexes[msg.sender]].amountLockedInContract += _amount;
        }
        emit AerodumpOFTAdapter__TokensLocked(
            msg.sender,
            _projectId,
            _amount,
            _dstChainId
        );
    }

    function queueAirdropWithEqualDistribution(
        uint256 _projectId,
        address[] memory _recipients,
        uint256 _dstChainId
    ) external shouldHaveAnActiveProject {
        require(
            projects[userIndexes[msg.sender]].amountLockedInContract > 0,
            "Lock some money first!"
        );
        for (uint256 i = 0; i < _recipients.length; i++) {
            equalDistributionQueue.push(
                Recipient({
                    projectId: _projectId,
                    dstChainId: _dstChainId,
                    recipient: _recipients[i],
                    amountToSend: (
                        projects[userIndexes[msg.sender]].amountLockedInContract
                    ) / _recipients.length
                })
            );
        }
    }

    function creditTo(
        address _to,
        uint256 _amount,
        uint32 _chainId
    ) external shouldHaveAnActiveProject {
        require(
            projects[userIndexes[msg.sender]].isAirdropActive,
            "Your project is not active!"
        );
        require(
            projects[userIndexes[msg.sender]].amountLockedInContract > 0,
            "You have no tokens to credit!"
        );
        _credit(_to, _amount, _chainId);
    }

    /**
     *  @dev this method is called by the Chainlink Automation Nodes to check if `performUpkeep` must be done. Note that `checkData` is used to segment the computation to subarrays.
     *  @dev `checkData` is an encoded binary data and which contains the lower bound and upper bound on which to perform the computation
     *  @dev return `upkeepNeeded`if rebalancing must be done and `performData` which contains an array of indexes that require rebalancing and their increments. This will be used in `performUpkeep`
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
     *  @dev this method is called by the Automation Nodes. it increases all elements whose balances are lower than the LIMIT. Note that the elements are bounded by `lowerBound`and `upperBound`
     *  (provided by `performData`
     *  @dev `performData` is an encoded binary data which contains the lower bound and upper bound of the subarray on which to perform the computation.
     *  it also contains the increments
     *  @dev return `upkeepNeeded`if rebalancing must be done and `performData` which contains an array of increments. This will be used in `performUpkeep`
     */
    function performUpkeep(bytes calldata performData) external override {
        // (uint256[] memory indexes, uint256[] memory increments) = abi.decode(
        //     performData,
        //     (uint256[], uint256[])
        // );
        // uint256 _balance;
        // uint256 _liquidity = liquidity;
        // for (uint256 i = 0; i < indexes.length; i++) {
        //     _balance = balances[indexes[i]] + increments[i];
        //     _liquidity -= increments[i];
        //     balances[indexes[i]] = _balance;
        // }
        // liquidity = _liquidity;
    }

    /**
     * @notice Returns the project details for the project owner.
     * @return Project struct.
     */
    function getProjectDetailsForProjectOwner()
        public
        view
        shouldHaveAnActiveProject
        returns (Project memory)
    {
        return projects[userIndexes[msg.sender]];
    }
}
