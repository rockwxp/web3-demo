//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Bank {
    address payable public admin;
    mapping(address => uint) public deposits;
    address[3] public topDepositors;

    modifier onlyAdmin() {
        require(msg.sender == admin, "only for admin");
        _;
    }

    constructor() {
        admin = payable(msg.sender);
    }

    function getContractBalance() external view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable virtual {
        deposits[msg.sender] += msg.value;
        updateTopAccount(msg.sender, deposits[msg.sender]);
    }

    function withdraw(uint amount) external virtual onlyAdmin {
        require(address(this).balance >= amount, "insufficient balance");
        payable(admin).transfer(amount);
    }

    function updateTopAccount(address _depositor, uint _amount) internal {
        for (uint8 i = 0; i < 3; i++) {
            if (deposits[topDepositors[i]] < _amount) {
                for (uint8 j = 2; j > i; j--) {
                    topDepositors[j] = topDepositors[j - 1];
                }
                topDepositors[i] = _depositor;
                break;
            }
        }
    }

    function getTopDepositors() public view returns (address[3] memory) {
        return topDepositors;
    }
}
