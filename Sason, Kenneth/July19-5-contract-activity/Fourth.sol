// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 4.]
    > Create a public mapping called users that will map an address to a User struct.
    > Create an external function called createUser. This function should create a new user and associate it to the msg.sender address in the users mapping. 
    > The balance of the new user should be set to 100 and the isActive boolean should be set to true.
    > Ensure that the createUser function is called with an address that is not associated with an active user. 
    
    > Create an external function called transfer which takes two parameters: an address for the recipient and a uint for the amount.
    > In this function, transfer the amount specified from the balance of the msg.sender to the balance of the recipient address.
    > Ensure that both addresses used in the transfer function have active users.
    > Ensure that the msg.sender has enough in their balance to make the transfer without going into a negative balance.

 */
contract ContractUser {
    struct User {
        address userAddress;
        bool isActive;
        uint256 balance;
    }
    mapping(address => User) public users;

    function createUser(address _userAddress) external {
        require(
            !users[_userAddress].isActive,
            "You are already register here!"
        );
        User memory user = User({
            userAddress: msg.sender,
            isActive: true,
            balance: 100
        });
        users[_userAddress] = user;
    }

    function transfer(address recipient, uint256 amount) external {
        require(
            !users[recipient].isActive,
            "Recipient is invalid. Not registered"
        );
        require(users[msg.sender].isActive, "You are Not registered");
        require(users[msg.sender].balance >= amount, "Not enough balance");
        users[msg.sender].balance -= amount;
        users[recipient].balance += amount;
    }
}
