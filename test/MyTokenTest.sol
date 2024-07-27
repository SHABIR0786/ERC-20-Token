// SPDX-License-Identifier: MIT 

pragma solidity ^0.8;
import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.sol";
contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();

        vm.prank(address(deployer));
        myToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, myToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllownce = 1000;
        
        vm.prank(bob);

        myToken.approve(alice, initialAllownce);

        uint256 transferAmount = 500;
        vm.prank(alice);

        myToken.transferFrom(bob, alice, transferAmount);

        assertEq(myToken.balanceOf(alice), transferAmount);
        assertEq(myToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}