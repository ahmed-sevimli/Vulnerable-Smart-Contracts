// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherDeposit
{

    address private admin;
    mapping(address => uint) public balances;

    constructor()
    {
        admin =  msg.sender;
    }

    modifier requireAdmin()
    {
        require(msg.sender == admin, "Only the deployer can call this function");
        _;
    }
    
    function deposit() external payable {
        require(msg.value <= msg.sender.balance, "Paran yetmiyor abicim");
        require(msg.value >= 1 ether, "You must send more than 1 Ether");
        balances[msg.sender] += msg.value;
    }

    function withdrawMoneyUsingEther(uint requestedAmount) public
    {
        requestedAmount *= 1000000000000000000;
        require(requestedAmount <= balances[msg.sender]);
        balances[msg.sender] -= requestedAmount;
        payable(msg.sender).transfer(requestedAmount);
    }

    function getBalance(address requestedUser) public view returns (uint256)
    {
        return address(requestedUser).balance;
    }

    function getContractBalance() public view returns (uint256)
    {
        return address(this).balance;
    }

    function withdrawAllMoney() public requireAdmin
    {
        payable(msg.sender).transfer(getContractBalance());
    }

}
