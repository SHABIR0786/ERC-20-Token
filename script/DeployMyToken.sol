// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract DeployMyToken is Script {
    uint256 public constant INITIAL_VALUE = 1000 ether;

    function run() external returns (MyToken) {
        vm.startBroadcast();
        MyToken mt = new MyToken(INITIAL_VALUE);
        vm.stopBroadcast();
        return mt;
    }
}
