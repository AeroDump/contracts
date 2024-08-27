// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IVersionable } from "@signprotocol/signprotocol-evm/src/interfaces/IVersionable.sol";
import { Schema } from "@signprotocol/signprotocol-evm/src/models/Schema.sol";
import { Attestation, OffchainAttestation } from "@signprotocol/signprotocol-evm/src/models/Attestation.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ISP } from "@signprotocol/signprotocol-evm/src/interfaces/ISP.sol";

contract MockISP { // is ISP
//     uint64 private _schemaCounter;
//     uint64 private _attestationCounter;
//     mapping(uint64 => Schema) private _schemas;
//     mapping(uint64 => Attestation) private _attestations;
//     mapping(string => OffchainAttestation) private _offchainAttestations;

//     function version() external pure override returns (string memory) {
//         return "1.0.0";
//     }

//     function register(Schema memory schema, bytes calldata) external override returns (uint64 schemaId) {
//         _schemaCounter++;
//         schemaId = _schemaCounter;
//         _schemas[schemaId] = schema;
//         emit SchemaRegistered(schemaId);
//     }

//     function attest(
//         Attestation calldata attestation,
//         string calldata indexingKey,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//         returns (uint64 attestationId)
//     {
//         _attestationCounter++;
//         attestationId = _attestationCounter;
//         _attestations[attestationId] = attestation;
//         emit AttestationMade(attestationId, indexingKey);
//     }

//     function attest(
//         Attestation calldata attestation,
//         uint256,
//         string calldata indexingKey,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         payable
//         override
//         returns (uint64 attestationId)
//     {
//         return attest(attestation, indexingKey, "", "");
//     }

//     function attest(
//         Attestation calldata attestation,
//         IERC20,
//         uint256,
//         string calldata indexingKey,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//         returns (uint64 attestationId)
//     {
//         return attest(attestation, indexingKey, "", "");
//     }

//     function attestOffchain(
//         string calldata offchainAttestationId,
//         address delegateAttester,
//         bytes calldata
//     )
//         external
//         override
//     {
//         _offchainAttestations[offchainAttestationId] = OffchainAttestation({
//             attester: delegateAttester == address(0) ? msg.sender : delegateAttester,
//             timestamp: uint64(block.timestamp)
//         });
//         emit OffchainAttestationMade(offchainAttestationId);
//     }

//     function revoke(uint64 attestationId, string calldata reason, bytes calldata, bytes calldata) external override {
//         _attestations[attestationId].revoked = true;
//         emit AttestationRevoked(attestationId, reason);
//     }

//     function revoke(
//         uint64 attestationId,
//         string calldata reason,
//         uint256,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         payable
//         override
//     {
//         revoke(attestationId, reason, "", "");
//     }

//     function revoke(
//         uint64 attestationId,
//         string calldata reason,
//         IERC20,
//         uint256,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//     {
//         revoke(attestationId, reason, "", "");
//     }

//     function revokeOffchain(
//         string calldata offchainAttestationId,
//         string calldata reason,
//         bytes calldata
//     )
//         external
//         override
//     {
//         delete _offchainAttestations[offchainAttestationId];
//         emit OffchainAttestationRevoked(offchainAttestationId, reason);
//     }

//     function attestBatch(
//         Attestation[] calldata attestations,
//         string[] calldata indexingKeys,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//         returns (uint64[] memory attestationIds)
//     {
//         attestationIds = new uint64[](attestations.length);
//         for (uint256 i = 0; i < attestations.length; i++) {
//             attestationIds[i] = attest(attestations[i], indexingKeys[i], "", "");
//         }
//     }

//     function attestBatch(
//         Attestation[] calldata attestations,
//         uint256[] calldata,
//         string[] calldata indexingKeys,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         payable
//         override
//         returns (uint64[] memory attestationIds)
//     {
//         return attestBatch(attestations, indexingKeys, "", "");
//     }

//     function attestBatch(
//         Attestation[] calldata attestations,
//         IERC20[] calldata,
//         uint256[] calldata,
//         string[] calldata indexingKeys,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//         returns (uint64[] memory attestationIds)
//     {
//         return attestBatch(attestations, indexingKeys, "", "");
//     }

//     function attestOffchainBatch(
//         string[] calldata offchainAttestationIds,
//         address delegateAttester,
//         bytes calldata
//     )
//         external
//         override
//     {
//         for (uint256 i = 0; i < offchainAttestationIds.length; i++) {
//             attestOffchain(offchainAttestationIds[i], delegateAttester, "");
//         }
//     }

//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//     {
//         for (uint256 i = 0; i < attestationIds.length; i++) {
//             revoke(attestationIds[i], reasons[i], "", "");
//         }
//     }

//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         uint256[] calldata,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         payable
//         override
//     {
//         revokeBatch(attestationIds, reasons, "", "");
//     }

//     function revokeBatch(
//         uint64[] calldata attestationIds,
//         string[] calldata reasons,
//         IERC20[] calldata,
//         uint256[] calldata,
//         bytes calldata,
//         bytes calldata
//     )
//         external
//         override
//     {
//         revokeBatch(attestationIds, reasons, "", "");
//     }

//     function revokeOffchainBatch(
//         string[] calldata offchainAttestationIds,
//         string[] calldata reasons,
//         bytes calldata
//     )
//         external
//         override
//     {
//         for (uint256 i = 0; i < offchainAttestationIds.length; i++) {
//             revokeOffchain(offchainAttestationIds[i], reasons[i], "");
//         }
//     }

//     function getSchema(uint64 schemaId) external view override returns (Schema memory) {
//         return _schemas[schemaId];
//     }

//     function getAttestation(uint64 attestationId) external view override returns (Attestation memory) {
//         return _attestations[attestationId];
//     }

//     function getOffchainAttestation(
//         string calldata offchainAttestationId
//     )
//         external
//         view
//         override
//         returns (OffchainAttestation memory)
//     {
//         return _offchainAttestations[offchainAttestationId];
//     }

//     function getDelegatedRegisterHash(Schema memory) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedAttestHash(Attestation calldata) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedAttestBatchHash(Attestation[] calldata) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedOffchainAttestHash(string calldata) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedOffchainAttestBatchHash(string[] calldata) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedRevokeHash(uint64, string memory) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedRevokeBatchHash(uint64[] memory, string[] memory) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedOffchainRevokeHash(string memory, string memory) external pure override returns (bytes32) {
//         return bytes32(0);
//     }

//     function getDelegatedOffchainRevokeBatchHash(
//         string[] memory,
//         string[] memory
//     )
//         external
//         pure
//         override
//         returns (bytes32)
//     {
//         return bytes32(0);
//     }

//     function schemaCounter() external view override returns (uint64) {
//         return _schemaCounter;
//     }

//     function attestationCounter() external view override returns (uint64) {
//         return _attestationCounter;
//     }
}
