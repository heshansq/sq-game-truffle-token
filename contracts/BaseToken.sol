// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./Token.sol";

contract BaseToken is Token {

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint256 public totalSupplyVal;
    string public name;
    string public symbol;
    uint8 public decimals;
    string public version = "1.0";
    address payable public fundsWallet;
    uint256 uintOfEthCanBuy;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        totalSupplyVal = 100 ether;
        fundsWallet = payable(msg.sender);
        balances[fundsWallet] = totalSupplyVal;
        name = "PokemonTD";
        symbol = "PKTD";
        uintOfEthCanBuy = 10000;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[msg.sender] >= _value ,"sender value needs to be higher than sending value");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        allowed[_to][msg.sender] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function totalSupply() public override view returns (uint256 supply) {
        return totalSupplyVal;
    }

    function transferEthToOwner(uint256 _amount) public payable override returns (bool success) {
        fundsWallet.transfer(_amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns(bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[_from] >= _value ,"sender value needs to be higher than sending value");

        balances[_from] -= _value;
        balances[_to] += _value;

        //check a way to implement struct here
        allowed[_from][_to] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function transferFromWithSpender(address _from, address _to, address _spender, uint256 _value) public override returns(bool success) {
        require(_value > 0, "value is lower than 1, you cant transfer");
        require(balances[_from] >= _value ,"sender value needs to be higher than sending value");
        require(allowed[_from][_spender] >= _value, "allowed value criteria never met");

        balances[_from] -= _value;
        balances[_to] += _value;

        //check a way to implement struct here
        allowed[_from][_spender] -= _value;
        emit Transfer(_from, _to, _value);

        return true;
    }

    function balanceOf(address _owner) public view override returns(uint256 _balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns(bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function approveSpender(address _spender, address _owner, uint256 _value) public returns(bool success) {
        allowed[_owner][_spender] = _value;
        emit Approval(_owner, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns(uint256 remaining){
        return allowed[_owner][_spender];
    }

}