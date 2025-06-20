// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FoundMe} from "../src/FoundMe.sol";
import {deploy} from "../script/deployFoundMe.s.sol";

contract FoundMeTest is Test {
    FoundMe foundme;
    uint256 constant ethNumber = 0.1 ether;
    uint256 constant ethNumbers = 0.2 ether;
    address user1 = makeAddr("user");

    function setUp() external {
        deploy de = new deploy();
        foundme = de.run();
        vm.deal(user1, ethNumber);
    }

    function testMinPrice() public view {
        assertEq(foundme.minPrice(), 5e18);
    }

    function testOwner() public view {
        assertEq(foundme.getOwner(), msg.sender);
    }

    function testGetVersion() public view {
        if (block.chainid == 1) {
            assertEq(foundme.getVersion(), 6);
        } else if (block.chainid == 11155111) {
            assertEq(foundme.getVersion(), 4);
        } else {
            assertEq(foundme.getVersion(), 4);
        }
    }

    function testRevertFunrigt() public {
        vm.expectRevert();
        foundme.found();
    }

    function testfoundtoright() public {
        vm.prank(user1);
        foundme.found{value: ethNumber}();
        uint256 foundersNumber = foundme.getfoundersNumber(user1);
        assertEq(foundersNumber, ethNumber);
    }

    function testarrytoFounders() public {
        vm.prank(user1);
        foundme.found{value: ethNumber}();
        address founder = foundme.getfounders(0);
        assertEq(founder,user1);
    }

    modifier fund1 {
        vm.prank(user1);
        foundme.found{value: ethNumber}();
        _;
    }

    function testOnlyownerWithdraw() public fund1 {
        vm.prank(user1);
        vm.expectRevert();
        foundme.withdraw();
    }

    function testSingleFounderWithdraw() public fund1 {
        // vm.prank(user1);
        uint256 startOwnerbalance = foundme.getOwner().balance;
        uint256 startFounderbalance = address(foundme).balance;

        vm.prank(foundme.getOwner());
        foundme.withdraw();

        uint256 endingOwnerbalance = foundme.getOwner().balance;
        uint256 endingFounderbalance = address(foundme).balance;

        assertEq(endingFounderbalance,0);
        assertEq(endingOwnerbalance,startOwnerbalance + startFounderbalance);
    }

    function testMutpliFounders() public {
        uint160 foundernum = 10;
        uint160 starfounder = 1;
        for(uint160 i = starfounder ; i < foundernum ; i++) {
            hoax(address(i),ethNumbers);
            foundme.found{value:ethNumber}();
        }
        uint256 startOwnerbalance = foundme.getOwner().balance;
        uint256 startFounderbalance = address(foundme).balance;

        vm.prank(foundme.getOwner());
        foundme.withdraw();
        assertEq(startOwnerbalance+startFounderbalance,foundme.getOwner().balance);
        assertEq(address(foundme).balance ,0); 
    }
}
