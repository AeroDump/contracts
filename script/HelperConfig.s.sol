//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {TestAeroDumpAttestations} from "../test/anvil/TestAeroDumpAttestations.t.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 chainId;
        address tokenAddress;
        address layerZeroEndpoint;
        uint64 _verifyProjectCertificateSchemaId;
        uint64 _kycVerificationSchemaId;
        uint64 _csvUploadSchemaId;
        uint64 _tokenDepositSchemaId;
        uint64 _userConsentSchemaId;
        uint64 _distributionCertificateSchemaId;
        uint64 _airdropExecutionSchemaId;
        address _initialOwner;
        address _ispAddress;
    }

    uint64 public constant VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID = 293; //Correct Value
    uint64 public constant KYC_VERIFICATION_SCHEMA_ID = 1;
    uint64 public constant CSV_UPLOAD_SCHEMA_ID = 2;
    uint64 public constant TOKEN_DEPOSIT_SCHEMA_ID = 298; //Correct Value
    uint64 public constant USER_CONSENT_SCHEMA_ID = 3;
    uint64 public constant DISTRIBUTION_CERTIFICATE_SCHEMA_ID = 4;
    uint64 public constant AIRDROP_EXECUTION_SCHEMA_ID = 5;
    address[] public verifierAddresses;
    NetworkConfig public ActiveConfig;

    constructor() {
        // if (block.chainid == 10) {
        //     ActiveConfig = getOptimismMainnetConfig();
        // } else {
        //     ActiveConfig = getAnvilConfig();
        // }
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory baseSepoliaConfig = NetworkConfig({
            chainId: vm.envUint("BASE_SEPOLIA_CHAIN_ID"),
            tokenAddress: vm.envAddress("BASE_SEPOLIA_USDC"),
            layerZeroEndpoint: vm.envAddress("BASE_SEPOLIA_LAYERZERO_ENDPOINT"),
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _csvUploadSchemaId: CSV_UPLOAD_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _userConsentSchemaId: USER_CONSENT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _airdropExecutionSchemaId: AIRDROP_EXECUTION_SCHEMA_ID,
            _initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5 Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
        });
        return baseSepoliaConfig;
    }

    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory AnvilConfig = NetworkConfig({
            chainId: 0,
            tokenAddress: address(5),
            layerZeroEndpoint: address(6),
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _csvUploadSchemaId: CSV_UPLOAD_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _userConsentSchemaId: USER_CONSENT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _airdropExecutionSchemaId: AIRDROP_EXECUTION_SCHEMA_ID,
            _initialOwner: address(1),
            _ispAddress: address(2)
        });
        return AnvilConfig;
    }

    function getActiveConfig() public view returns (NetworkConfig memory) {
        return ActiveConfig;
    }
}
