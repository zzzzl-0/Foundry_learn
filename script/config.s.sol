// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mokds/MockAggregator.sol";

contract Config is Script {
    networkConfig public theNetwork;
    uint8 constant decimals = 8;
    int256 constant initialAnswer = 2000e8;

    constructor() {
        if (block.chainid == 1) {
            theNetwork = getEthPrice();
        } else if (block.chainid == 11155111) {
            theNetwork = getSpePrice();
        } else {
            theNetwork = getContractAnvilPrice();
        }
    }

    struct networkConfig {
        address priceFeed;
        uint256 chainid;
    }

    function getSpePrice() public pure returns (networkConfig memory) {
        networkConfig memory speNet = networkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306, 11155111);
        return speNet;
    }

    function getEthPrice() public pure returns (networkConfig memory) {
        networkConfig memory ethNet = networkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, 1);
        return ethNet;
    }

    function getContractAnvilPrice() public returns (networkConfig memory) {
        if (theNetwork.priceFeed != address(0)) {
            return theNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(decimals, initialAnswer);
        vm.stopBroadcast();
        networkConfig memory anviNet = networkConfig({priceFeed: address(mockV3Aggregator), chainid: 0});

        return anviNet;
    }
}
