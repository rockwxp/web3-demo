// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Bank {
    address public admin;

    mapping(address => uint) public deposits;

    constructor() {
        admin = msg.sender;
    }

    modifier outOfBalance(uint amount) {
        require(deposits[msg.sender] >= amount, "the amount is out of deposit");
        _;
    }

    function deposit(address token, uint amount) public {
        IERC20(token).transferFrom(msg.sender, address(this), amount);

        deposits[msg.sender] += amount;
    }

    function withdraw(address token, uint amount) public outOfBalance(amount) {
        IERC20(token).transfer(msg.sender, amount);
        deposits[msg.sender] -= amount;
    }
}
