// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {OApp, MessagingFee, Origin} from "@layerzerolabs/oapp-evm/contracts/oapp/OApp.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IAerodumpOFTAdapter} from "../interfaces/IAerodumpOFTAdapter.sol";

/**
 * @title AeroDumpComposer.
 * @author AeroDump.
 * @notice Routing contract integrated with layerzero omichain messaging.
 * @dev This contract receives project verified address from AeroDumpAttestations.
 * @dev Deployed on a different chain than Attestations(Hedera).
 */
contract AeroDumpComposerSecond is OApp {
    /**
     * @notice Addresses for deployed attestations contract on base.
     */
    address public attestations;

    uint256 public AMOUNT;

    /**
     * @notice Is triggered when composed address and id are sent to adapters.
     * @param user Address of the user who has verified his project.
     * @param amount Project id of the project that is verified by user.
     */
    event AeroDumpComposerSecond__ComposeSent(address user, uint256 amount);

    /**
     * @notice Is triggered when adapter addresses are updated.
     * @param attestations Array of addresses of all deployed adapters.
     */
    event AeroDumpComposerSecond__AttestationsAddressesUpdated(
        address attestations
    );

    /**
     * @notice Emitted when a message is sent to a destination endpoint.
     * @param dstEid The LayerZero endpoint ID of the destination chain.
     * @param composedAddress The address that the message is composed for and sent to.
     * @param message The message content that was sent.
     */
    event AeroDumpComposer__MessageSent(
        uint32 dstEid,
        address composedAddress,
        string message
    );

    /**
     * @param initialOwner Owner address.
     * @param _endpoint Address of this Layerzero OApp endpoint.
     */
    constructor(
        address initialOwner,
        address _endpoint
    ) OApp(_endpoint, initialOwner) Ownable(initialOwner) {}

    /**
     * @notice This function sets the adapter addresses for all deployed adapters for different currencies.
     * @dev These addresses are accessed while sending compose to the adapters.
     * @dev Only callable mods.
     * @param _attestations Array of addresses of attestations contract on base.
     */
    function setAttestationsAddress(address _attestations) external onlyOwner {
        attestations = _attestations;

        emit AeroDumpComposerSecond__AttestationsAddressesUpdated(
            _attestations
        );
    }

    // /**
    //  * @notice Layerzero send method, unaltered.
    //  * @dev This function us used to test omnichain messaging, custom _lzSend is already implemented in verifyProject.
    //  * @param _dstEid LayerZero endpoint ID.
    //  * @param _message Message to be sent.
    //  */
    // function send(
    //     uint32 _dstEid,
    //     string memory _message,
    //     address _composedAddress,
    //     bytes calldata _options
    // ) external payable {
    //     // Encodes the message before invoking _lzSend.
    //     bytes memory _payload = abi.encode(_message, _composedAddress);
    //     _lzSend(
    //         _dstEid,
    //         _payload,
    //         _options,
    //         // Fee in native gas and ZRO token.
    //         MessagingFee(msg.value, 0),
    //         // Refund address in case of failed source message.
    //         payable(msg.sender)
    //     );

    //     emit AeroDumpComposer__MessageSent(_dstEid, _composedAddress, _message);
    // }

    /**
     * @notice Called when data is received from the protocol. It overrides the equivalent function in the parent
     * contract.
     * Protocol messages are defined as packets, comprised of the following parameters.
     * @dev This function has custom logic, when the verified project addresses are received, it sends them to the
     * adapters.
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
    ) internal override {
        // Decode the string message and composed address
        uint256 amount = abi.decode(payload, (uint256));
        AMOUNT = amount;

        // endpoint.sendCompose(attestations, _guid, 0, payload);

        emit AeroDumpComposerSecond__ComposeSent(attestations, amount);
    }
}
