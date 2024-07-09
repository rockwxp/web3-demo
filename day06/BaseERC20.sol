// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Bank {
    function tokensReceived(address account, uint amount) external;
}

contract BaseERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;
        totalSupply = 100000000 * (10 ** 18);
        balances[msg.sender] = totalSupply;
    }

    modifier outOfBalance(address _from, uint256 _value) {
        require(
            balances[_from] >= _value,
            "ERC20: transfer amount exceeds balance"
        );
        _;
    }

    function transferFromAndCallBank(
        address bank,
        uint256 _amount
    ) public returns (bool) {
        require(
            bank.code.length > 0,
            "ERC20: transfer to non-contract address"
        );

        balances[msg.sender] -= _amount;
        balances[bank] += _amount;

        Bank(bank).tokensReceived(msg.sender, _amount);
        emit Transfer(msg.sender, bank, _amount);
        return true;
    }

    modifier outOfAllowance(
        address owner,
        address spender,
        uint256 _value
    ) {
        require(
            allowances[owner][spender] >= _value,
            "ERC20: transfer amount exceeds allowance"
        );
        _;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public outOfBalance(msg.sender, _value) returns (bool success) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        outOfBalance(_from, _value)
        outOfAllowance(_from, msg.sender, _value)
        returns (bool success)
    {
        allowances[_from][msg.sender] -= _value;
        balances[_from] -= _value;
        balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}
