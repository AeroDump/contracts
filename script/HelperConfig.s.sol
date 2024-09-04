//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 chainId;
        address tokenAddress;
        address ZROTokenAddress;
        address layerZeroEndpoint;
        uint64 _verifyProjectCertificateSchemaId;
        uint64 _kycVerificationSchemaId;
        uint64 _tokenDepositSchemaId;
        uint64 _distributionCertificateSchemaId;
        address _initialOwner;
        address _ispAddress;
        uint256 chainEid;
    }

    uint64 public constant VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID = 293; //Correct Value
    uint64 public constant KYC_VERIFICATION_SCHEMA_ID = 1;
    uint64 public constant TOKEN_DEPOSIT_SCHEMA_ID = 298; //Correct Value
    uint64 public constant DISTRIBUTION_CERTIFICATE_SCHEMA_ID = 2;
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
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5 Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40245
        });
        return baseSepoliaConfig;
    }

    function getEthSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory ethSepoliaConfig = NetworkConfig({
            chainId: 11155111,
            tokenAddress: 0xf08A50178dfcDe18524640EA6618a1f965821715,
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5 Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40161
        });
        return ethSepoliaConfig;
    }

    function getOpSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory opSepoliaConfig = NetworkConfig({
            chainId: 11155420,
            tokenAddress: 0x5fd84259d66Cd46123540766Be93DFE6D43130D7,
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5 Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40232
        });
        return opSepoliaConfig;
    }

    function getAnvilConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory AnvilConfig = NetworkConfig({
            chainId: 0,
            tokenAddress: address(5),
            ZROTokenAddress: address(0),
            layerZeroEndpoint: address(6),
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: address(1),
            _ispAddress: address(2),
            chainEid: 0
        });
        return AnvilConfig;
    }

    function getActiveConfig() public view returns (NetworkConfig memory) {
        return ActiveConfig;
    }
}
