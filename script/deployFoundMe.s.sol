// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FoundMe} from "../src/FoundMe.sol";
import {Config} from "./config.s.sol";

contract deploy is Script {
    FoundMe foundme;

    function run() public returns (FoundMe) {
        Config config = new Config();
        (address feedContract,) = config.theNetwork();

        vm.startBroadcast();
        foundme = new FoundMe(feedContract);
        vm.stopBroadcast();
        return foundme;
    }
}
