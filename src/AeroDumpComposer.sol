// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OApp, MessagingFee, Origin} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IAerodumpOFTAdapter} from "./interfaces/IAerodumpOFTAdapter.sol";

/**
 * @title AeroDumpComposer.
 * @author AeroDump.
 * @notice Routing contract integrated with layerzero omichain messaging.
 * @dev This contract receives project verified address from AeroDumpAttestations.
 * @dev Deployed on a different chain than Attestations(Hedera).
 */
contract AeroDumpComposer is OApp {
    address public lastVerifiedUser;
    address[] public adapters;

    address public USER;
    uint256 public PROJECTID;

    event ProjectVerified(string projectName);

    constructor(
        address initialOwner,
        address _endpoint
    ) OApp(_endpoint, initialOwner) Ownable(initialOwner) {}

    function send(
        uint32 _dstEid,
        string memory _message,
        address _composedAddress,
        bytes calldata _options
    ) external payable {
        // Encodes the message before invoking _lzSend.
        bytes memory _payload = abi.encode(_message, _composedAddress);
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

    function setAdapterAddresses(
        address[] calldata _adapters
    ) external onlyOwner {
        adapters = _adapters;
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata payload,
        address, // Executor address as specified by the OApp.
        bytes calldata // Any extra data or options to trigger on receipt.
    ) internal override {
        // Decode the string message and composed address
        (address user, uint256 projectId) = abi.decode(
            payload,
            (address, uint256)
        );
        USER = user;
        PROJECTID = projectId;

        // bytes memory newPayload = abi.encode(projectName);

        // Loop through all adapters and send the composed message
        for (uint256 i = 0; i < adapters.length; i++) {
            endpoint.sendCompose(adapters[i], _guid, 0, payload);
            // IAerodumpOFTAdapter(adapters[i]).updateVerifiedUser(projectName);
        }
    }
}
