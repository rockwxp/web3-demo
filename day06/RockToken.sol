// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/interfaces/IERC1363Receiver.sol";

contract RockToken is ERC20 {
    constructor() ERC20("RockToken", "R") {}

    error TransferFailed(address to, uint256 value);
    error ReceiveFailed(address to);

    function mint() external {
        super._mint(msg.sender, 10 * 18);
    }

    function transferAndCall(
        address to,
        uint256 value,
        bytes calldata data
    ) public returns (bool) {
        transfer(to, value);
        _checkOnTransferReceived(msg.sender, to, value, data);
        return true;
    }

    function _checkOnTransferReceived(
        address from,
        address to,
        uint256 value,
        bytes memory data
    ) private {
        if (to.code.length > 0) {
            revert ReceiveFailed(to);
        }

        bytes4 retval = IERC1363Receiver(to).onTransferReceived(
            from,
            to,
            value,
            data
        );
        if (retval != IERC1363Receiver.onTransferReceived.selector) {
            revert ReceiveFailed(to);
        }
    }
}
