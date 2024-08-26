// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionable } from "@signprotocol/signprotocol-evm/src/interfaces/IVersionable.sol";
import { Schema } from "@signprotocol/signprotocol-evm/src/models/Schema.sol";
import { Attestation, OffchainAttestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockISP is IVersionable {
    mapping(uint64 => Schema) private _mockSchemas;
    uint64 public schemaCounter = 1;
    bool public attestationMade;
    Attestation public lastAttestation;
    address[] public allowedAttesters;

    function register(Schema memory schema, bytes calldata delegateSignature) external returns (uint64 schemaId) {
        schemaId = schemaCounter++;
        _mockSchemas[schemaId] = schema;
        return schemaId;
    }

    function attest(
        Attestation calldata attestation,
        string calldata indexingKey,
        bytes calldata delegateSignature,
        bytes calldata extraData
    )
        external
        returns (uint64 attestationId)
    {
        attestationMade = true;
        lastAttestation = attestation;
        return attestationId;
    }

    function revoke(
        uint64 attestationId,
        string calldata reason,
        bytes calldata delegateSignature,
        bytes calldata extraData
    )
        external
    {
        // No-op implementation
    }

    function getSchema(uint64 schemaId) external view returns (Schema memory) {
        return _mockSchemas[schemaId];
    }

    function getAttestation(uint64 attestationId) external view returns (Attestation memory) {
        return lastAttestation;
    }

    function setAllowedAttester(address attester, bool allowed) external {
        if (allowed) {
            allowedAttesters.push(attester);
        } else {
            for (uint256 i = 0; i < allowedAttesters.length; i++) {
                if (allowedAttesters[i] == attester) {
                    delete allowedAttesters[i];
                    break;
                }
            }
        }
    }

    function isAllowedAttester(address attester) external view returns (bool) {
        return contains(allowedAttesters, attester);
    }

    function contains(address[] memory array, address value) private pure returns (bool) {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) return true;
        }
        return false;
    }

    // Implement missing functions like attestBatch, revokeBatch, etc. based on the ISP interface
    function version() external pure override returns (string memory) { }
}
