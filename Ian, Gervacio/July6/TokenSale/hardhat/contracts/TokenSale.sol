//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IWhitelist.sol";

contract TokenSale is ERC20 {
    uint256 public tokenPrice = 0.0001 ether;
    uint256 public tokensPerAddress = 10;
    uint256 public _totalSupply = totalSupply();
    uint256 public maxTotalSupply = 10000 * 10**18;

    address public owner;
    bool public presaleStarted;
    uint256 public presaleEndTime;

    IWhitelist public whitelist;

    mapping(address => uint256) public balances;
    mapping(address => bool) public presaleMinted;

    constructor(address _whitelistAddress) ERC20("One Community token", "OCT") {
        whitelist = IWhitelist(_whitelistAddress);
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner.");
        _;
    }

    //start presale
    //only owner can call this function
    //sets presale started to true
    //auto sets the presale end time

    function startPresale() public onlyOwner {
        presaleStarted = true;
        presaleEndTime = block.timestamp + 24 hours;
    }

    //presale mint function
    //presale = started, presale != ended
    //address calling function should be whitelisted
    //address caling should have not yet availed the presale

    function presaleMint() public payable {
        require(presaleStarted == true && block.timestamp <= presaleEndTime, "Presale is not running");
        require(whitelist.isWhitelisted(msg.sender), "You are not whitelisted.");
        require(presaleMinted[msg.sender] == false, "You have already availed your presale tokens.");

        uint256 mintPrice = tokensPerAddress * tokenPrice;
        require(mintPrice == msg.value, "Amount sent is not correct.");

        _mint(msg.sender, tokensPerAddress);
        balances[msg.sender] += (tokensPerAddress * 10**18);
        _totalSupply += (tokensPerAddress * 10**18);
        presaleMinted[msg.sender] = true;
    }

    function publicMint(uint256 amountToMint) public payable {
        require(presaleStarted == true && block.timestamp > presaleEndTime, "Presale has not yet ended.");
        require(amountToMint >= 1, "Must mint at least one token.");
        require(maxTotalSupply >= (_totalSupply + (amountToMint * 10**18)));

        uint256 mintPrice = amountToMint * tokenPrice;
        require(mintPrice == msg.value, "Amount sent is not correct.");

        _mint(msg.sender, amountToMint * 10**18);
        balances[msg.sender] += (amountToMint * 10**18);
        _totalSupply += (amountToMint * 10**18);
    }

    function withdraw() public onlyOwner {
        uint256 bal = address(this).balance;
        require(bal > 0, "Nothing to withdraw.");

        (bool sent, ) = owner.call{value: bal}(""); //address.call{value: 000}
        //address (owner) calls for a value to be transferred (bal)
        //transaction returns a boolean (true/false) named "sent"
        require(sent == true, "Failed to send balance");
    }
}