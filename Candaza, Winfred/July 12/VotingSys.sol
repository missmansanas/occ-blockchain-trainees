// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSys {
    mapping(address => bool) public checker;

    address[] public YesVotes;
    address[] public NoVotes;

    function voteYes(address Yes) external {
        require(checker[msg.sender] = false, "You can only vote once");
        YesVotes.push(Yes);
        checker[msg.sender] = true; 
        
    }

    function voteNo(address No) external {
        require(checker[msg.sender] = false, "You can only vote once");
        NoVotes.push(No);
        checker[msg.sender] = true;
    }

    function countNoVotes () public view returns (uint256) {
        uint256 countNo = NoVotes.length;
        return countNo;
    }

    function countYesVotes () public view returns (uint256) {
        uint256 countYes = NoVotes.length;
        return countYes;
    }
}