// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";
contract RockTokenBank is IERC1363Receiver {
    mapping(address => uint256) private deposits;

    function deposit(address token, uint256 amount) public {
        require(amount > 0, "deposit should more than 0");

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
    }

    function withdraw(address token, uint256 amount) public {
        require(amount > 0, "withdraw should more than 0");
        require(amount <= deposits[msg.sender]);
        deposits[msg.sender] -= amount;
        require(IERC20(token).transfer(msg.sender, amount), "withdraw failed");
    }

    function onTransferReceived(
        address operater,
        address to,
        uint256 amount,
        bytes memory data
    ) external returns (bytes4) {
        require(amount > 0, "amount should more than 0");
        deposits[to] += amount;
        return IERC1363Receiver.onTransferReceived.selector;
    }
}
