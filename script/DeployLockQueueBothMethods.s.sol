// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { AerodumpOFTAdapter } from "../src/AerodumpOFTAdapter.sol";
import { AeroDumpAttestations } from "../src/signprotocol/AeroDumpAttestations.sol";
import { HelperConfig } from "../script/HelperConfig.s.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OFTAdapterScript is Script {
    address[] recipients;
    AerodumpOFTAdapter.Recipient[] recipients2;

    function run() public {
        // address privateKey = vm.envAddress("private_key");
        HelperConfig config = new HelperConfig();
        vm.startBroadcast();
        AeroDumpAttestations attestations = new AeroDumpAttestations(
            msg.sender, config.getBaseSepoliaConfig()._ispAddress, 0x6EDCE65403992e310A62460808c4b910D972f10f
        );
        console.log("attestations", address(attestations));

        attestations.setSchemaIds(
            config.getBaseSepoliaConfig()._verifyProjectCertificateSchemaId,
            config.getBaseSepoliaConfig()._kycVerificationSchemaId,
            config.getBaseSepoliaConfig()._tokenDepositSchemaId,
            config.getBaseSepoliaConfig()._distributionCertificateSchemaId
        );
        console.log("schema ids are set");
        AerodumpOFTAdapter adapter = new AerodumpOFTAdapter(
            config.getBaseSepoliaConfig().tokenAddress, config.getBaseSepoliaConfig().layerZeroEndpoint, msg.sender
        );
        console.log("adapter", address(adapter));

        IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).approve(address(adapter), 2 * 1e6);
        console.log("usdc approved for adapter to lock tokens");
        uint256 projectid = attestations.verifyProject("notnull", "notnull", "notnull", "notnull");
        console.log("project verified!! id is", projectid);
        adapter.lockTokens(projectid, 2 * 1e6, 1 * 1e6, uint32(config.getBaseSepoliaConfig().chainId));
        console.log(
            "tokens locked,now our contract owns this much usdc",
            IERC20(config.getBaseSepoliaConfig().tokenAddress).balanceOf(address(adapter))
        );
        //this method not working, generally how FE calls, maybe we can have a helper function to fix that
        // address[] memory recipients;
        // recipients[0] = address(0);
        // recipients[1] = address(1);
        // recipients[2] = address(2);
        // recipients[3] = address(3);
        recipients.push(address(0));
        recipients.push(address(1));
        recipients.push(address(2));
        recipients.push(address(3));
        adapter.queueAirdropWithEqualDistribution(projectid, recipients, uint32(config.getBaseSepoliaConfig().chainId));
        console.log("airdrop queued!!!");
        IERC20(vm.envAddress("BASE_SEPOLIA_USDC")).approve(address(adapter), 3 * 1e6);
        console.log("usdc approved for adapter to lock tokens again for unequal distribution");
        adapter.lockTokens(projectid, 3 * 1e6, 1 * 1e6, uint32(config.getBaseSepoliaConfig().chainId));
        console.log(
            "tokens locked,now our contract owns this much usdc again",
            IERC20(config.getBaseSepoliaConfig().tokenAddress).balanceOf(address(adapter))
        );
        AerodumpOFTAdapter.Recipient memory recipientDat1 = AerodumpOFTAdapter.Recipient({
            projectId: projectid,
            dstChainId: uint32(vm.envUint("BASE_SEPOLIA_CHAIN_ID")),
            recipient: address(12),
            amountToSend: 1 * 1e6
        });

        AerodumpOFTAdapter.Recipient memory recipientDat2 = AerodumpOFTAdapter.Recipient({
            projectId: projectid,
            dstChainId: uint32(vm.envUint("BASE_SEPOLIA_CHAIN_ID")),
            recipient: address(13),
            amountToSend: 2 * 1e6
        });

        recipients2.push(recipientDat1);
        recipients2.push(recipientDat2);
        adapter.queueAirdropWithUnequalCSVDistribution(recipients2);
        console.log("airdrop queued with csv!!!");

        vm.stopBroadcast();
    }
}
