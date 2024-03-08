// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

contract ManualERC20 {
    uint8 private constant NUM_DECIMALS = 18;

    string private s_name;
    string private s_symbol;

    mapping(address => uint256) private s_balances;
    mapping(address => mapping(address => uint256)) public s_allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    error ManualERC20__InsufficientBalance(uint256 balance, uint256 required);
    error ManualERC20__InsufficientAllowanceOrBalance(
        uint256 allowance,
        uint256 balance,
        uint256 required
    );
    error ManualERC20__ZeroAddressTransfer();

    constructor(string memory _name, string memory _symbol) {
        s_name = _name;
        s_symbol = _symbol;
        s_balances[msg.sender] = totalSupply();
    }

    function name() public view returns (string memory) {
        return s_name;
    }

    function symbol() public view returns (string memory) {
        return s_symbol;
    }

    function decimals() public pure returns (uint8) {
        return NUM_DECIMALS;
    }

    function totalSupply() public pure returns (uint256) {
        return 1000000 ether;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (_to == address(0)) revert ManualERC20__ZeroAddressTransfer();
        if (s_balances[msg.sender] < _value)
            revert ManualERC20__InsufficientBalance(
                s_balances[msg.sender],
                _value
            );

        s_balances[msg.sender] -= _value;
        s_balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        success = true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (s_balances[_from] < _value && s_allowed[_from][msg.sender] < _value)
            revert ManualERC20__InsufficientAllowanceOrBalance(
                s_allowed[_from][msg.sender],
                s_balances[_from],
                _value
            );
        s_balances[_to] += _value;
        s_balances[_from] -= _value;
        s_allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        s_allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return s_allowed[_owner][_spender];
    }
}
