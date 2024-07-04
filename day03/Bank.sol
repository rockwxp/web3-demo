//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bank {
    // admin account
    address payable public owner;
    //saving each account address and money
    mapping(address => uint) public deposits;
    //saving 3 account of top amount of money
    struct AccountInfo {
        address depositor;
        uint amount;
    }
    AccountInfo[3] public topDepositors;

    //some operations only for admin
    modifier onlyAdmin() {
        require(msg.sender == owner, "only for admin");
        _;
    }
    //saving admin's EOA address
    constructor() {
        owner = payable(msg.sender);
    }

    //check amount of money of the contract
    function getTotalBalance() external view returns (uint) {
        return address(this).balance;
    }

    // get money for depositors and record the amount of money for each users
    function deposit() public payable {
        deposits[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, msg.value);
    }

    receive() external payable {
        deposits[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, msg.value);
    }

    fallback() external payable {
        deposits[msg.sender] += msg.value;
        updateTopDepositors(msg.sender, msg.value);
    }

    function withdraw(uint amount) external onlyAdmin {
        require(address(this).balance >= amount, "insufficient balance");
        payable(owner).transfer(amount);
    }

    function updateTopDepositors(address _depositor, uint _amount) internal {
        for (uint8 i = 0; i < 3; i++) {
            if (topDepositors[i].amount < _amount) {
                for (uint8 j = 2; j > i; j--) {
                    topDepositors[j] = topDepositors[j - 1];
                }
                topDepositors[i] = AccountInfo(_depositor, _amount);
                break;
            }
        }
    }

    function getTopDepositors() public view returns (AccountInfo[3] memory) {
        return topDepositors;
    }
}
