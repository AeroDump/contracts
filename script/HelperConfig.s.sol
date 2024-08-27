// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import { Script, console2 } from "forge-std/Script.sol";
import { TestAeroDumpAttestations } from "../test/anvil/TestAeroDumpAttestations.t.sol";

contract HelperConfig is Script {
    uint64 public constant PROJECT_SCHEMA_ID = 1;
    uint64 public constant VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID = 2;
    uint64 public constant CSV_UPLOAD_SCHEMA_ID = 3;
    uint64 public constant TOKEN_DEPOSIT_SCHEMA_ID = 4;
    uint64 public constant USER_CONSENT_SCHEMA_ID = 5;
    uint64 public constant DISTRIBUTION_CERTIFICATE_SCHEMA_ID = 6;
    uint64 public constant AIRDROP_EXECUTION_SCHEMA_ID = 7;

    address[] public verifierAddresses;

    struct Config {
        uint64 _projectSchemaId;
        uint64 _verifyProjectCertificateSchemaId;
        uint64 _csvUploadSchemaId;
        uint64 _tokenDepositSchemaId;
        uint64 _userConsentSchemaId;
        uint64 _distributionCertificateSchemaId;
        uint64 _airdropExecutionSchemaId;
        address _initialOwner;
        address _ispAddress;
    }

    function getSepoliaConfig() public pure returns (Config memory) {
        Config memory SepoliaConfig = Config({
            _projectSchemaId: PROJECT_SCHEMA_ID,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
            _csvUploadSchemaId: CSV_UPLOAD_SCHEMA_ID,
            _tokenDepositSchemaId: TOKEN_DEPOSIT_SCHEMA_ID,
            _userConsentSchemaId: USER_CONSENT_SCHEMA_ID,
            _distributionCertificateSchemaId: DISTRIBUTION_CERTIFICATE_SCHEMA_ID,
            _airdropExecutionSchemaId: AIRDROP_EXECUTION_SCHEMA_ID,
            _initialOwner: 0xfe63Ba8189215E5C975e73643b96066B6aD41A45,
            _ispAddress: 0x878c92FD89d8E0B93Dc0a3c907A2adc7577e39c5 // Sepolia testnet address
         });
        return SepoliaConfig;
    }

    function getAnvilConfig() public pure returns (Config memory) {
        console2.log("testing on anvil");
        Config memory AnvilConfig = Config({
            _projectSchemaId: PROJECT_SCHEMA_ID,
            _verifyProjectCertificateSchemaId: VERIFY_PROJECT_CERTIFICATE_SCHEMA_ID,
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
}
