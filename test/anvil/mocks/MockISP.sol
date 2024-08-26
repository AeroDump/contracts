// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ISP, Attestation, OffchainAttestation, Schema } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";
import { ISPHook } from "@signprotocol/signprotocol-evm/src/interfaces/ISPHook.sol";
import { DataLocation } from "@signprotocol/signprotocol-evm/src/models/DataLocation.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockISP is ISP {
    bool public attestationMade;
    Attestation public lastAttestation;
    mapping(uint64 => Schema) public schemas;

    function attest(
        Attestation memory _attestation,
        string memory _proofOfPersonhood,
        string memory _proofOfOwnership,
        string memory _extraData
    )
        external
        override
        returns (uint256)
    {
        attestationMade = true;
        lastAttestation = _attestation;
        return 1; // Return a dummy attestation ID
    }

    function attestMultiple(
        Attestation[] memory _attestations,
        string memory _proofOfPersonhood,
        string memory _proofOfOwnership,
        string memory _extraData
    )
        external
        override
        returns (uint256[] memory)
    {
        attestationMade = true;
        if (_attestations.length > 0) {
            lastAttestation = _attestations[0];
        }
        uint256[] memory ids = new uint256[](_attestations.length);
        for (uint256 i = 0; i < _attestations.length; i++) {
            ids[i] = i + 1; // Return dummy attestation IDs
        }
        return ids;
    }

    function revoke(uint256 _attestationId) external override {
        // Implement if needed for testing
    }

    function getAttestation(uint256 _attestationId) external view override returns (Attestation memory) {
        return lastAttestation;
    }

    function getAttestations(uint256[] memory _attestationIds) external view override returns (Attestation[] memory) {
        Attestation[] memory attestations = new Attestation[](_attestationIds.length);
        for (uint256 i = 0; i < _attestationIds.length; i++) {
            attestations[i] = lastAttestation;
        }
        return attestations;
    }

    function getAttestationCount() external view override returns (uint256) {
        return attestationMade ? 1 : 0;
    }

    function getSchema(uint64 _schemaId) external view override returns (Schema memory) {
        return schemas[_schemaId];
    }

    function getSchemas(uint64[] memory _schemaIds) external view override returns (Schema[] memory) {
        Schema[] memory schemasList = new Schema[](_schemaIds.length);
        for (uint256 i = 0; i < _schemaIds.length; i++) {
            schemasList[i] = schemas[_schemaIds[i]];
        }
        return schemasList;
    }

    function registerSchema(string memory _schema) external override returns (uint64) {
        uint64 schemaId = uint64(schemas.length);
        schemas[schemaId] = Schema({
            registrant: address(this),
            revocable: true,
            dataLocation: DataLocation.STORED_ON_CHAIN,
            maxValidFor: 0,
            hook: ISPHook(address(0)),
            timestamp: uint64(block.timestamp),
            data: _schema
        });
        return schemaId;
    }

    function supportTokenFactory(address _token, uint256 _tokenFactoryId) external override {
        // Implement if needed for testing
    }

    function setAllowAll(bool _allowAll) external override {
        // Implement if needed for testing
    }

    function setAllowedAttester(address _attester, bool _allowed) external override {
        // Implement if needed for testing
    }

    function isAllowedAttester(address _attester) external view override returns (bool) {
        return true; // Always return true for testing purposes
    }
}
