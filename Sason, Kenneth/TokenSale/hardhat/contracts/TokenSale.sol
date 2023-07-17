// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IWhitelist.sol";

contract TokenSale is ERC20 {
    uint256 public tokenPrice = 0.0001 ether;
    uint256 public tokensPerAddress = 10;
    uint256 public _totalSupply = totalSupply();
    uint256 public maxTotalSupply = 10000 * 10 ** 8;

    address public owner;
    bool public presaleStared;
    uint256 public presaleEndTime;

    IWhitelist public whitelist;
    mapping(address => uint256) public balances;
    mapping(address => bool) public presaleMinted;

    constructor(address _whitelistAddress) ERC20("One Community Token", "OCT") {
        whitelist = IWhitelist(_whitelistAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function startPresale() public onlyOwner {
        presaleStared = true;
        presaleEndTime = block.timestamp + 24 hours;
    }

    function presaleMint() public payable {
        require(
            presaleStared && block.timestamp <= presaleEndTime,
            "Presale is not available"
        );
        require(whitelist.isWhitelisted(msg.sender), "You are not whitelisted");
        require(whitelist.isWhitelisted(msg.sender), "You are not whitelisted");
        require(!presaleMinted[msg.sender], "Already minted in the presale");

        uint256 mintPrice = tokensPerAddress * tokenPrice;
        require(mintPrice == msg.value, "Incorrect ammount");
        _mint(msg.sender, tokensPerAddress * 10 ** 18);
        balances[msg.sender] += tokensPerAddress * 10 ** 18;
        _totalSupply += (tokensPerAddress * 10 ** 18);
        presaleMinted[msg.sender] = true;
    }

    function publicMint(uint256 amountToMint) public payable {
        require(
            presaleStared == true && block.timestamp <= presaleEndTime,
            "presale hasn'ended "
        );
        require(amountToMint >= 1, "Must mint at least one 1 token");
        uint256 mintPrice = amountToMint * tokenPrice;
        require(mintPrice == msg.value, "amount incorrect");
        _mint(msg.sender, amountToMint * 10 ** 18);
        balances[msg.sender] += (amountToMint * 10 ** 18);
        _totalSupply += (amountToMint * 10 ** 18);
    }

    function withdraw() public onlyOwner {
        uint256 bal = address(this).balance;
        require(bal > 0, "nothing to withdraw");
        (bool sent, ) = owner.call{value: bal}("");
        require(sent, "Failed to send balance");
    }
}
