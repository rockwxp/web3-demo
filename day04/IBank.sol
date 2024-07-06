//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IBank {
    function withdraw(uint amount) external;

    function getTopDepositors() external view returns (address[3] memory);

    function setAdmin(address _newAdmin) external;

    function withdraw(uint amount, address payable _to) external;
}
