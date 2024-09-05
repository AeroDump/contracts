// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OApp, MessagingFee, Origin} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AeroDumpComposer.
 * @author AeroDump.
 * @notice Routing contract integrated with layerzero omichain messaging.
 * @dev This contract receives project verified address from AeroDumpAttestations.
 * @dev Deployed on a different chain than Attestations(Hedera).
 */
contract AeroDumpComposer is OApp {
    address public data;
    address public adapter;

    constructor(
        address initialOwner,
        address _endpoint
    ) OApp(_endpoint, initialOwner) Ownable(initialOwner) {}

    function send(
        uint32 _dstEid,
        string memory _message,
        bytes calldata _options
    ) external payable {
        // Encodes the message before invoking _lzSend.
        // Replace with whatever data you want to send!
        bytes memory _payload = abi.encode(_message);
        _lzSend(
            _dstEid,
            _payload,
            _options,
            // Fee in native gas and ZRO token.
            MessagingFee(msg.value, 0),
            // Refund address in case of failed source message.
            payable(msg.sender)
        );
    }

    function setAdapterAddress(address _adapter) public {
        adapter = _adapter;
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address, // Executor address as specified by the OApp.
        bytes calldata // Any extra data or options to trigger on receipt.
    ) internal override {
        //update mappings for user
        // Decode the payload to get the message
        // In this case, type is string, but depends on your encoding!
        data = abi.decode(payload, (address));
        // endpoint.sendCompose(adapter, _guid, 0, payload);

        // call adapter to set the msg.sender as verified in the adapter
    }
}
