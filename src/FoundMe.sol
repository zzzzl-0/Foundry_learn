// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceChange} from "./PriceChange.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error notOwner();

contract FoundMe {
    using PriceChange for uint256;

    uint256 public constant minPrice = 5e18;
    //跟踪 Founder
    address[] private s_founders;
    mapping(address => uint256) private s_foundersNumber;
    address private immutable i_owner;
    AggregatorV3Interface private s_feed;

    constructor(address _feed) {
        s_feed = AggregatorV3Interface(_feed);
        i_owner = msg.sender;
    }

    modifier onlyowner() {
        if (msg.sender != i_owner) {
            revert notOwner();
        }
        _;
    }

    function found() public payable {
        //允许用户发送资金
        //限制用户最低发送$1
        //1e18 = 1ETH = 1000000000000000000 Wei = 1 * 10 *18
        require(msg.value.getFinPrice(s_feed) >= minPrice, "Found false!");
        if (s_foundersNumber[msg.sender] == 0) {
            s_founders.push(msg.sender);
        }
        s_foundersNumber[msg.sender] += msg.value;
    }

    function withdraw() public onlyowner {
        require(address(this).balance > 0, "No funds to withdraw");
        for (uint256 count = 0; count < s_founders.length; count++) {
            address founder = s_founders[count];
            s_foundersNumber[founder] = 0;
        }
        s_founders = new address[](0);
        (bool callsuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess, "call false!");
    }

    function getVersion() public view returns (uint256) {
        return PriceChange.getVersion1(s_feed);
    }

    receive() external payable {
        found();
    }

    fallback() external payable {
        found();
    }

    function getfoundersNumber(address _fundAddress) public view returns (uint256) {
        return s_foundersNumber[_fundAddress];
    }

    function getfounders(uint256 _index) public view returns (address) {
        return s_founders[_index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}
