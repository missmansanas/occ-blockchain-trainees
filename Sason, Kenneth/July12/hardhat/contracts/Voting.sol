//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Vote {
    uint256 public teamNaruto;
    uint256 public teamProvinciano;

    mapping(address => bool) public hasVoted;
    mapping(address => string) public voterName;

    string[] private narutoFans;
    string[] private provincianoFans;

    function voteNaruto(string memory _name) public {
        require(hasVoted[msg.sender] == false, "You voted already!");
        voterName[msg.sender] = _name;
        teamNaruto += 1;
        hasVoted[msg.sender] = true;
        narutoFans.push(_name);
    }

    function getNarutoFans() public view returns (string[] memory) {
        return narutoFans;
    }

    function getProvincianoFans() public view returns (string[] memory) {
        return provincianoFans;
    }

    function voteProvinciano(string memory _name) public {
        require(hasVoted[msg.sender] == false, "You voted already!");
        voterName[msg.sender] = _name;
        teamProvinciano += 1;
        hasVoted[msg.sender] = true;
        provincianoFans.push(_name);
    }
}
