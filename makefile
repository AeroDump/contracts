#Base Deployment
forge script script/simpleDeploy/AttestationsDeploy.s.sol:AttestationsDeploy --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --verifier blockscout --verifier-url $VERIFIER_URL

forge script script/miniScripts/Bridge.s.sol:BridgeScript --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --verifier blockscout --verifier-url $VERIFIER_URL

forge script script/miniScripts/VerifyProject.s.sol:SendScript --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --verifier blockscout --verifier-url $VERIFIER_URL

#Hedera Deployment
forge script script/simpleDeploy/ComposerDeploy.s.sol:ComposerDeploy --rpc-url $HEDERA_TESTNET_RPC_URL --private-key $PRIVATE_KEY --broadcast
forge script script/simpleDeploy/OFTAdapterDeploy.s.sol:OFTAdapterDeploy --rpc-url $HEDERA_TESTNET_RPC_URL --private-key $PRIVATE_KEY --broadcast

forge script script/miniScripts/BridgeSecondScript.s.sol:BridgeSecondScript --rpc-url $HEDERA_MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast

forge script script/miniScripts/console.s.sol:Console --rpc-url $HEDERA_MAINNET_RPC_URL --private-key $PRIVATE_KEY --broadcast
