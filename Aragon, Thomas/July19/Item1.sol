// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Contract1 {
    enum ConnectionTypes {
        Unacquainted,
        Friend,
        Family
    }

    // Create a public mapping called connections which will map an address to a mapping of an address to a ConnectionTypes enum value.
    mapping(address => mapping (address => ConnectionTypes)) public connections;

    function connectWith(
        address other,
        ConnectionTypes connectionType
    ) external {
        //In theconnectWith function, create a connection from the msg.sender to the other address.
        connections[msg.sender][other] = connectionType;

    }
}