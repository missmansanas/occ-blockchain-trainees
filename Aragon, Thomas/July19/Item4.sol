// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Contract4 {
    struct User {
        uint256 balance;
        bool isActive;
    }

    mapping(address => User) public users;

    function createUser() external {
        require(!users[msg.sender].isActive, "User is already active.");

        users[msg.sender].balance = 100 ether;
        users[msg.sender].isActive = true;
    }

    function transfer(address addressTo, uint amount) external {
        require(users[msg.sender].isActive == true && users[addressTo].isActive == true, "Both users must be active for this transaction to process.");
        require(users[msg.sender].balance >= amount, "You don't have enough balance to transfer this amount.");
        users[msg.sender].balance -= amount;
        users[addressTo].balance += amount;
    }
}