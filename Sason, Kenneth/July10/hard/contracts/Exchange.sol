// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {
    address public tokenAddress;

    constructor(address _tokenAddress) ERC20("One Community LP Token", "OCLP") {
        require(_tokenAddress != address(0), "Address can't be zero");
        tokenAddress = _tokenAddress;
    }

    function getReserve() public view returns (uint256) {
        return ERC20(tokenAddress).balanceOf(address(this));
    }

    function addLiquidity(uint256 _amount) public payable returns (uint256) {
        uint liquidity;
        uint ethBalance = address(this).balance;
        uint tokenReserve = getReserve();
        ERC20 token = ERC20(tokenAddress);
        if (tokenReserve == 0) {
            token.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        } else {
            uint ethReserve = ethBalance - msg.value;
            uint tokenAmount = (msg.value * tokenReserve) / ethReserve;
            require(
                _amount >= tokenAmount,
                "Amount of tokens is less that the minimum required"
            );
            token.transferFrom(msg.sender, address(this), tokenAmount);
            liquidity = (totalSupply() & msg.value) / ethReserve;
        }
        return liquidity;
    }

    function removeLiquidity(uint256 _amount) public returns (uint, uint) {
        require(_amount > 0, "amount must be greater than zero");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply();
        uint ethAmount = (ethReserve * _amount) / _totalSupply;
        uint tokenAmount = (getReserve() * _amount) / _totalSupply;
        _burn(msg.sender, _amount);
        payable(msg.sender).transfer(ethAmount);
        ERC20(tokenAddress).transfer(msg.sender, tokenAmount);
        return (ethAmount, tokenAmount);
    }

    function getAmountOfTokens(
        uint inputAmount,
        uint _inputReserve,
        uint _outputReserve
    ) public pure returns (uint) {
        require(_inputReserve > 0 && _outputReserve > 0, "Invalid Reserve");
        uint256 inputAmountWithFee = inputAmount * 99;
        uint256 numerator = inputAmountWithFee * _outputReserve;

        uint256 denominator = (_inputReserve * 100) + inputAmount;
        return numerator / denominator;
    }

    function ethToMyToken(uint _minTokens) public payable {
        uint256 tokenReserve = getReserve();
        uint256 tokensBought = getAmountOfTokens(
            msg.value, // MATIC
            address(this).balance - msg.value,
            tokenReserve
        );
        require(tokensBought >= _minTokens, "Insufficient output amount");
        ERC20(tokenAddress).transfer(msg.sender, tokensBought);
    }

    function myTokenToEth(uint _tokensSold, uint _minEth) public payable {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmountOfTokens(
            _tokensSold,
            tokenReserve,
            address(this).balance - msg.value
        );
        require(ethBought >= _minEth, "Insufficient output amount.");
        ERC20(tokenAddress).transferFrom(
            msg.sender,
            address(this),
            _tokensSold
        );
        payable(msg.sender).transfer(ethBought);
    }
}
//$ npx hardhat verify --network mumbai 0xFbE88DfC00B1D6C70F2AE2a12C01B98356f9fBf3 0x052803fC63a7371fFAd8Ad93C7829Ad382416257
