// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceChange {
    function getPrice(AggregatorV3Interface feed) internal view returns (uint256) {
        //address  0x694AA1769357215DE4FAC081bf1f309aDC325306
        //ABI
        AggregatorV3Interface newFeed = AggregatorV3Interface(feed);
        (, int256 answer,,,) = newFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getFinPrice(uint256 _ethAmount, AggregatorV3Interface feed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(feed);
        uint256 ethWithUsd = (ethPrice * _ethAmount) / 1e18;
        return ethWithUsd;
    }

    function getVersion1(AggregatorV3Interface feed) internal view returns (uint256) {
        AggregatorV3Interface newFeed = AggregatorV3Interface(feed);
        return newFeed.version();
    }
}
