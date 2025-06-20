// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FoundMe} from "../src/FoundMe.sol";
import {MockV3Aggregator} from "./mokds/MockAggregator.sol";

contract FoundMeIntegrationTest is Test {
    FoundMe foundme;
    MockV3Aggregator mockFeed;
    address owner;
    address user1;
    address user2;
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_ANSWER = 2000e8; // $2000

    receive() external payable {}

    function setUp() public {
        owner = address(this);
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        mockFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        foundme = new FoundMe(address(mockFeed));
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function testFullFlow() public {
        // user1 捐赠 0.01 ether
        vm.prank(user1);
        foundme.found{value: 0.01 ether}();
        assertEq(foundme.getfoundersNumber(user1), 0.01 ether);
        assertEq(foundme.getfounders(0), user1);
        assertEq(address(foundme).balance, 0.01 ether);

        // user2 捐赠 0.02 ether
        vm.prank(user2);
        foundme.found{value: 0.02 ether}();
        assertEq(foundme.getfoundersNumber(user2), 0.02 ether);
        assertEq(foundme.getfounders(1), user2);
        assertEq(address(foundme).balance, 0.03 ether);

        // 预言机价格变动
        mockFeed.updateAnswer(3000e8); // $3000
        assertEq(mockFeed.latestAnswer(), 3000e8);

        // owner 提现
        uint256 ownerBalanceBefore = owner.balance;
        foundme.withdraw();
        assertEq(address(foundme).balance, 0);
        assertEq(owner.balance, ownerBalanceBefore + 0.03 ether);
        // founders 记录被清空
        assertEq(foundme.getfoundersNumber(user1), 0);
        assertEq(foundme.getfoundersNumber(user2), 0);
    }

    function testDonateBelowMinPriceReverts() public {
        // 设定预言机价格很低，导致 0.001 ether 捐赠不满足 minPrice
        mockFeed.updateAnswer(1e8); // $1
        vm.prank(user1);
        vm.expectRevert();
        foundme.found{value: 0.001 ether}();
    }

    function testReceiveFunction() public {
        vm.prank(user1);
        (bool success, ) = address(foundme).call{value: 0.01 ether}("");
        assertTrue(success);
        assertEq(foundme.getfoundersNumber(user1), 0.01 ether);
    }

    function testFallbackFunction() public {
        vm.prank(user2);
        (bool success, ) = address(foundme).call{value: 0.01 ether}(abi.encodePacked(bytes4(0x12345678)));
        assertTrue(success);
        assertEq(foundme.getfoundersNumber(user2), 0.01 ether);
    }

    function testOnlyOwnerModifier() public {
        // 非 owner 调用 withdraw 必须 revert
        address notOwner = vm.addr(99);
        vm.prank(notOwner);
        vm.expectRevert();
        foundme.withdraw();
    }

    function testWithdrawZeroBalanceReverts() public {
        foundme = new FoundMe(address(mockFeed));
        vm.expectRevert(bytes("No funds to withdraw"));
        foundme.withdraw();
    }

    function testGetFoundersOutOfBounds() public {
        // founders 为空时访问越界
        vm.expectRevert();
        foundme.getfounders(0);
    }
} 