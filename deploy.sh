source .env

forge build

forge script --private-key $PRIVATE_KEY --chain $TESTNET_CHAIN_ID script/DeployEscrowFactory.s.sol:DeployEscrowFactoryScript --rpc-url $TESTNET_RPC_URL --verify --etherscan-api-key $ETHERSCANKEY  --broadcast