//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/Test.sol";
import { MockV3Aggregator } from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import { IERC20, IERC20Metadata } from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

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
    address public constant HEDERA_USDC_ADDERSS = 0x0000000000000000000000000000000000068cDa;

    constructor() {
        // if (block.chainid == 10) {
        //     ActiveConfig = getOptimismMainnetConfig();
        // } else {
        //     ActiveConfig = getAnvilConfig();
        // }
    }

    function getHederaTestnetConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory hederaTestnetConfig = NetworkConfig({
            chainId: 296,
            tokenAddress: HEDERA_USDC_ADDERSS, //EVM Compatible USDC Address
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0xbD672D1562Dd32C23B563C989d8140122483631d,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: msg.sender,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5
                // Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40_285
        });
        return hederaTestnetConfig;
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
            _initialOwner: msg.sender,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5
                // Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40_245
        });
        return baseSepoliaConfig;
    }

    function getEthSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory ethSepoliaConfig = NetworkConfig({
            chainId: 11_155_111,
            tokenAddress: 0xf08A50178dfcDe18524640EA6618a1f965821715,
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: msg.sender,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5
                // Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40_161
        });
        return ethSepoliaConfig;
    }

    function getOpSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory opSepoliaConfig = NetworkConfig({
            chainId: 11_155_420,
            tokenAddress: 0x5fd84259d66Cd46123540766Be93DFE6D43130D7,
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: msg.sender,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5
                // Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40_232
        });
        return opSepoliaConfig;
    }

    function getArbSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory arbSepoliaConfig = NetworkConfig({
            chainId: 421_614,
            tokenAddress: 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d,
            ZROTokenAddress: 0x6985884C4392D348587B19cb9eAAf157F13271cd,
            layerZeroEndpoint: 0x6EDCE65403992e310A62460808c4b910D972f10f,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _kycVerificationSchemaId: KYC_VERIFICATION_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _initialOwner: msg.sender,
            _ispAddress: 0x4e4af2a21ebf62850fD99Eb6253E1eFBb56098cD, //0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5
                // Sepolia
            // testnet address0x6EDCE65403992e310A62460808c4b910D972f10f
            chainEid: 40_231
        });
        return arbSepoliaConfig;
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

    function getUSDCDecimals() public pure returns (uint8) {
        return 6; // Assuming USDC has 6 decimal places
    }
}
