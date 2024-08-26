//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";

/**
 * uint256 _CIP,
 *         uint256 _baseRiskRate,
 *         uint256 _riskPremiumRate,
 *         address _indai,
 *         address _priceContract
 */
contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 chainId;
        address tokenAddress;
        address layerZeroEndpoint;
    }

    NetworkConfig public ActiveConfig;

    constructor() {
        // if (block.chainid == 10) {
        //     ActiveConfig = getOptimismMainnetConfig();
        // } else {
        //     ActiveConfig = getAnvilConfig();
        // }
    }

    function getBaseSepoliaConfig() public view returns (NetworkConfig memory) {
        console.log("forking base sepolia now....");
        NetworkConfig memory baseSepoliaConfig = NetworkConfig({
            tokenAddress: vm.envAddress("BASE_SEPOLIA_USDC"),
            layerZeroEndpoint: vm.envAddress("BASE_SEPOLIA_LAYERZERO_ENDPOINT"),
            chainId: vm.envUint("BASE_SEPOLIA_CHAIN_ID")
        });
        return baseSepoliaConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {}

    function getActiveConfig() public view returns (NetworkConfig memory) {
        return ActiveConfig;
    }
}
