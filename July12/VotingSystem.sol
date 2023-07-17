// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    uint256 private yesCounter; // number of 'yes' votes
    uint256 private noCounter; // number of 'no' votes
    uint256 private percentage; // percentage of 'yes' votes against the total number of votes

    address public owner; // indicates the address of the owner

    // specifies the vote casted
    enum Vote {
        no,
        yes
    }

    // information of the voter
    struct Member {
        string firstName;
        string lastName;
        uint256 birthday;
        address accountAddress;
        Vote vote;
    }

    bool public votingPeriodStarted; // indicates if voting period has already started
    uint256 public votingPeriodEndTime; // indicates the end time of the voting period
    bool public greenlight; // indicates if upgrade will be greenlighted (must have at least 51% of the total votes)

    mapping(address => bool) public hasVoted; // indicates if user has already voted
    Member[] public _member; // stores the information of the voter

    constructor() {
        owner = msg.sender;
    }

    // checks if the user is the owner of the contract
    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    // checks if the user has already voted
    modifier onlyAlreadyVoted {
        require(hasVoted[msg.sender], "Only available to those who already casted their vote.");
        _;
    }

    // starts the voting period (only the owner can access this function)
    function startVotingPeriod() external onlyOwner {
        votingPeriodStarted = true;
        votingPeriodEndTime = block.timestamp + 24 hours; // sets the voting period to 24 hours
    }

    // allows the members to cast their votes
    function castVote(string memory _firstName, string memory _lastName, uint256 _birthday, Vote _vote) public {
        /* 
        - Can only be done during the voting period
        - Members can only cast their votes once
        */
        require(votingPeriodStarted, "Voting period hasn't started yet.");
        require(block.timestamp <= votingPeriodEndTime, "Voting period has already ended.");
        require(!hasVoted[msg.sender], "You have already voted.");

        _member.push(Member(_firstName, _lastName, _birthday, msg.sender, _vote));
        if (_vote == Vote.yes){
           yesCounter += 1;
        }
        else{
            noCounter += 1;
        }

        hasVoted[msg.sender] = true;
    }

    // checks the current results of the polls (only accessible to those who already voted, publicly accessible once voting period ends)
    function viewCurrentResults() public view onlyAlreadyVoted returns (uint256, uint256){
        return (yesCounter, noCounter);
    }

    // gets the results of the polls to decide if the upgrade will be greenlighted (only accessible to the owner)
    function getResults() public onlyOwner {
        // requires that the voting period has already ended
        require(block.timestamp > votingPeriodEndTime, "Voting period is still on-going.");

        //
        percentage = yesCounter / (yesCounter + noCounter) * 1000;

        // checks for at least 51% of the total votes
        if (percentage >= 505) {
            greenlight == true;
        }
    }

}