// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;

//transfer between users

contract BasicBank4  {

    mapping (address => uint) private userFunds;
    address private commissionCollector;
    uint private collectedCommission = 0;

    constructor() {
        commissionCollector = msg.sender;
    }
    
    modifier onlyCommissionCollector {
        require(msg.sender == commissionCollector);
        _;
    }

    function deposit() public payable {
        require(msg.value >= 1 ether); //gönderilen eth miktarı 1 den fazla olmalı
        userFunds[msg.sender] += msg.value; //işlemi yapan kullanıcının adres değeri msg.value kadar artırıldı.
    }

    function withdraw(uint _amount) external {
        require(getBalance(msg.sender) >= _amount);
        userFunds[msg.sender] -= _amount;
        (bool success, ) = msg.sender.call{value: ((_amount/100)*99)}("");
        require(success);
        collectedCommission += _amount/100; //%1 komisyon olarak commission_taker hesabına ekleniyor.
    }   

    function getBalance(address _user) public view returns(uint) {
        return userFunds[_user];
    }

    function getCommissionCollector() public view returns(address) {
        return commissionCollector;
    }

    function transfer(address _userToSend, uint _amount) external{
        require(getBalance(msg.sender) >= _amount);
        userFunds[_userToSend] += _amount;
        userFunds[msg.sender] -= _amount;
    }

    function setCommissionCollector(address _newCommissionCollector) external onlyCommissionCollector{
        collectCommission();
        commissionCollector = _newCommissionCollector;
    }

    function collectCommission() public onlyCommissionCollector{
        userFunds[commissionCollector] += collectedCommission;
        collectedCommission = 0;
    }
}
