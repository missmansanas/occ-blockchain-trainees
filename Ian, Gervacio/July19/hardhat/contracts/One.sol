// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract One {
    enum ConnectionTypes {
        Unacquainted,
        Friend,
        Family
    }

    mapping(address => ConnectionTypes) public connections;

    function connectWith(address other, ConnectionTypes connectionType) external {
        //In theconnectWith function, create a connection from the msg.sender to the other address.
        connections[other] = connectionType;
    }

}