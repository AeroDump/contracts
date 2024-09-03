// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import { OApp, Origin } from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {
    ILayerZeroEndpointV2,
    MessagingFee,
    MessagingReceipt
} from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroEndpointV2.sol";
import { ILayerZeroComposer } from "@layerzerolabs/lz-evm-protocol-v2/contracts/interfaces/ILayerZeroComposer.sol";
import { OFTComposeMsgCodec } from "@layerzerolabs/oft-evm/contracts/libs/OFTComposeMsgCodec.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { AeroDumpAttestations } from "./signprotocol/AeroDumpAttestations.sol";

contract AeroDumpComposer is Ownable, ILayerZeroComposer {
    address public immutable endpoint;
    address public immutable attestationsContract;
    address[] public oftAdapters;

    event MessageComposedAndSent(uint32 indexed destinationEid, address indexed oftAdapter, bytes payload);
    event LockTokensRequested(uint256 projectId, address tokenAddress, uint256 amount);

    constructor(address _endpoint, address _attestationsContract, address InitialOwner) Ownable(InitialOwner) {
        endpoint = _endpoint;
        attestationsContract = _attestationsContract;
    }

    function addOFTAdapter(address oftAdapter) external {
        // Function to add new OFTAdapter addresses
        oftAdapters.push(oftAdapter);
    }

    function lzCompose(
        address _oApp,
        bytes32 _guid,
        bytes calldata _message,
        address, // executor
        bytes calldata // options
    )
        external
        payable
        override
    {
        require(_oApp == attestationsContract, "!attestationsContract");
        require(msg.sender == endpoint, "!endpoint");

        // Decode the message type and data
        (uint8 messageType, bytes memory data) = abi.decode(_message, (uint8, bytes));

        // Loop through all OFTAdapters and send the composed message
        for (uint256 i = 0; i < oftAdapters.length; i++) {
            // Compose a message for each OFTAdapter
            _sendToOFTAdapter(oftAdapters[i], _guid, abi.encode(messageType, data));
        }
    }

    function forwardLockTokensRequest(uint256 projectId, address tokenAddress, uint256 amount) external onlyOwner {
        // Encode the message with the required parameters
        bytes memory encodedMessage = abi.encode(projectId, tokenAddress, amount);

        // Define the MessagingFee (for simplicity, let's assume zero fees here, but you should calculate the actual
        // fees)
        MessagingFee memory fee = MessagingFee({
            nativeFee: 0, // Set the appropriate native fee here
            lzTokenFee: 0 // Set the appropriate lzToken fee here
         });

        // Send the composed message to the Attestations contract
        _lzSend(
            attestationsContract, // Destination chain ID or address of the Attestations contract
            encodedMessage, // Encoded message containing the parameters for recordLockTokens
            "", // Options
            fee, // Fee
            msg.sender // Refund address
        );
    }

    function _lzSend(
        address _to,
        bytes memory _message,
        string memory _options,
        MessagingFee memory _fee,
        address _refundAddress
    )
        internal
    {
        // Implement the LayerZero send function
        // Ensure this implementation correctly interacts with LayerZero's endpoint
        (bool success,) = endpoint.call{ value: _fee.nativeFee }(
            abi.encodeWithSignature(
                "send(address,bytes32,bytes,bytes,bytes)",
                _to,
                keccak256(abi.encodePacked(_message)),
                _message,
                _options,
                _refundAddress
            )
        );
        require(success, "Failed to send message");
    }

    function _sendToOFTAdapter(address oftAdapter, bytes32 _guid, bytes memory _message) internal {
        // Sending a composed message to each OFTAdapter
        (bool success,) = endpoint.call{ value: msg.value }(
            abi.encodeWithSignature("sendCompose(address,bytes32,uint16,bytes)", oftAdapter, _guid, 0, _message)
        );
        require(success, "Failed to send composed message to OFTAdapter");
    }

    function _lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) internal {
        // Decode the payload to get the message type
        (uint8 messageType, bytes memory data) = abi.decode(_payload, (uint8, bytes));

        // Handle the message based on its type
        if (messageType == 2) {
            // Decode the data for messageType 2
            (uint256 projectId, address tokenAddress, uint256 amount) = abi.decode(data, (uint256, address, uint256));

            // Call the recordLockTokens function in the AeroDumpAttestations contract
            AeroDumpAttestations(attestationsContract).recordLockTokens(projectId, tokenAddress, amount);
        } else {
            revert("Unknown message type");
        }
    }
}
