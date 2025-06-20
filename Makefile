-include .env

# build:; forge build
deploy_speilo:
	forge script script/deployFoundMe.s.sol --fork-url $(rpc) --private-key $(PRIVATE_KEY) --broadcast