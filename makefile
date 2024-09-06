forge script script/riiz0-tests/TestAttestationsScript.s.sol:TestAttestationsScript --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --verifier blockscout --verifier-url $VERIFIER_URL

forge script script/riiz0-tests/TestOFTScript.s.sol:TestOFTScript --rpc-url $BASE_SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --verifier blockscout --verifier-url $VERIFIER_URL

https://testnet.hashio.io/apiforge create --rpc-url "RPC_URL" --private-key "HEX_Encoded_Private_Key" --verify --verifier sourcify --verifier-url https://server-verify.hashscan.io src/TodoList.sol:TodoList