-include .env

# build:; forge build
deploy_speilo:
	forge script script/deployFoundMe.s.sol --rpc-url $(rpc) --private-key $(PRIVATE_KEY) --broadcast