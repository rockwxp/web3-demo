//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./Bank.sol";

contract BigBank is Bank {
    modifier minDepositAmount() {
        require(
            msg.value > 0.001 ether,
            "deposit should more than 0.001 ether"
        );
        _;
    }

    function setAdmin(address _newAdmin) public {
        //require(msg.sender == admin,"you are not admin");
        require(_newAdmin != address(0), "wrong address");
        admin = payable(_newAdmin);
    }

    function deposit() public payable override minDepositAmount {
        super.deposit();
    }
}
