// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenStaking is ERC20 {
    mapping (address => uint256) public staked;  //amount staked by user
    mapping (address => uint256) private stakedFromTS; //timestamp of the staking

    constructor() ERC20("Fixed Staking", "FIX") {
        _mint(msg.sender, 100000000000000000000);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "You cannot take 0 stake.");
        //require statements take 2 arguments
        //the condition, and the error message if the condition is not met
        require(balanceOf(msg.sender) >= 0, "Insufficient balance in your account");
        _transfer(msg.sender, address(this), amount); //from address, to address, amount

        if (staked[msg.sender] > 0) {
            claim();
        }

        staked[msg.sender] += amount;
        stakedFromTS[msg.sender] = block.timestamp;
    }

    function unstake(uint256 amount) external {
        require(amount > 0, "You cannot take unstake 0 amount");
        require(staked[msg.sender] >= amount, "The amount you're staking sxceeds the amount you've staked");

        claim();
        staked[msg.sender]-= amount;
        _transfer(address(this), msg.sender, amount);
        }

        function claim() public {
            require(staked[msg.sender] > 0, "You do not have any amount staked.");

            uint256 secondStaked = block.timestamp - stakedFromTS[msg.sender];
            uint256 rewards = staked[msg.sender] * secondStaked / 3.145e7;
            _mint(msg.sender, rewards);
            stakedFromTS[msg.sender] = block.timestamp;
        }

    }
