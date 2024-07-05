//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract Ownable {
    address public owner;

    /*
     *  set owner
     */
    constructor() {
        owner = msg.sender;
    }

    /*
     * @dev modifier
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "not admin");
        _;
    }

    /*
     * @dev set owner
     */
    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "invalid address");
        owner = _newOwner;
    }

    function onlyOwnerCanCallThisFunc() external onlyOwner {}

    function anyoneCanCallThisFun() external {}
}
