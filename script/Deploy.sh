source .env
forge script script/BasicBank.s.sol:DeployBasicBank --rpc-url $ETH_RPC_URL --private-key $PRIVATE_KEY  --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY  -vvvv --force
