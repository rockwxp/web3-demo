//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./IBank.sol";

contract Ownable {
    event Received(address indexed recipient, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event FallbackCalled(address indexed sender, uint256 amount, bytes data);

    address payable public admin;

    constructor() {
        admin = payable(msg.sender);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "only for admin");
        _;
    }

    function setAdmin(address _address, address _newAdmin) external onlyAdmin {
        IBank(_address).setAdmin(_newAdmin);
    }

    function withdraw(address _address, uint amount) external {
        IBank(_address).withdraw(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function transferToAccount(
        uint amount,
        address payable _to
    ) external onlyAdmin {
        require(address(this).balance >= amount, "insufficient balance");
        _to.transfer(amount);
    }

    function getTopDepositors(
        address _address
    ) external view returns (address[3] memory) {
        return IBank(_address).getTopDepositors();
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FallbackCalled(msg.sender, msg.value, "function fallback");
    }
}
