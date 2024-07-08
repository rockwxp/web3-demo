// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";
contract Bank {
    address public admin;

    mapping(address => uint) public deposits;

    IERC20 public baceERC20;

    constructor(IERC20 iERC20) {
        admin = msg.sender;

        baceERC20 = iERC20;
    }

    modifier outOfBalance(uint amount) {
        require(deposits[msg.sender] >= amount, "the amount is out of deposit");
        _;
    }

    function deposit(uint amount) public {
        baceERC20.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
    }

    function withdraw(uint amount) public outOfBalance(amount) {
        baceERC20.transfer(address(this), amount);
        deposits[msg.sender] -= amount;
    }
}
