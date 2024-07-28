// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {MyToken} from "../src/MyToken.sol";
import {DeployMyToken} from "../script/DeployMyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;
    DeployMyToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether; // 1 million tokens with 18 decimal places

    function setUp() public {
        deployer = new DeployMyToken();
        myToken = deployer.run();
        // myToken.transfer(msg.sender, INITIAL_SUPPLY);
        vm.prank(msg.sender);
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

    function testTransfer() public {
        uint256 transferAmount = 50 ether;

        vm.prank(bob);
        myToken.transfer(alice, transferAmount);

        assertEq(myToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(myToken.balanceOf(alice), transferAmount);
    }

    function testMint() public {
        uint256 mintAmount = 100 ether;

        vm.prank(msg.sender);
        myToken.mint(bob, mintAmount);

        assertEq(myToken.balanceOf(bob), STARTING_BALANCE + mintAmount);
    }

    function testBurn() public {
        uint256 burnAmount = 50 ether;

        vm.prank(bob);
        myToken.burn(burnAmount);

        assertEq(myToken.balanceOf(bob), STARTING_BALANCE - burnAmount);
    }

    function testTransferExceedsBalance() public {
        uint256 transferAmount = 200 ether;
        vm.prank(bob);
        vm.expectRevert();
        myToken.transfer(alice, transferAmount);
    }

    function testApproveAndTransferFromExceedsAllowance() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        myToken.approve(alice, initialAllowance);

        uint256 transferAmount = 1500;
        vm.prank(alice);
        vm.expectRevert();
        myToken.transferFrom(bob, alice, transferAmount);
    }

    function testTotalSupply() public view {
        uint256 expectedTotalSupply = myToken.totalSupply();
        uint256 actualTotalSupply = myToken.balanceOf(msg.sender) + myToken.balanceOf(bob) + myToken.balanceOf(alice);
        assertEq(expectedTotalSupply, actualTotalSupply);
    }
}
