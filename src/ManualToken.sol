// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract ManualToken {

    mapping(address=>uint256) s_balance;
    function name() public pure returns (string memory) {
        return "Manual Token";
    }

    function symbol() public pure returns (string memory) {
        return "$";
    }

    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balance[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 previousBalances = balanceOf(msg.sender) + balanceOf(_to);
        s_balance[_to] += _value;
        s_balance[msg.sender] -= _value;
        require(previousBalances == balanceOf(_to) + balanceOf(msg.sender));
        return true;
    }

}