// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//LP token

contract Exchange is ERC20 {
    address public tokenAddress;

    constructor(address _tokenAddress) ERC20("One Community LP Token", "OCLP") {
        require(_tokenAddress != address(0), "Cannot be address zero");
        tokenAddress = _tokenAddress; 
    }

    function getReserve() public view returns(uint256){
        return ERC20(tokenAddress).balanceOf(address(this));
        //Look up my custom token ("MTK"0)
        //Check hjow many MTKs this address (smart contract) is holding 
    }

    /*add liquidity function
    *Transfers MTH from the user > this smart contract
    *Mints LP tokens to the user, for using this DEX
    *If reserve is empty, LP minted is equal to the ETH bal
    *Else, LP is minted usiing 
    *(total supply (of tokens in citculation) * msg.value) / ETH bal
    */

    function addLiquidity (uint256 _amount) public payable returns (uint256){
        uint liquidity; //initialize to zerp
        uint ethBalance = address(this).balance; //ETH bal of this contract
        uint tokenReserve = getReserve(); //MTK bal of this contract 
        ERC20 token = ERC20(tokenAddress);

        if(tokenReserve == 0) {
            token.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance; 
            _mint(msg.sender, liquidity); 
        
        }
        else {
            uint ethReserve = ethBalance - msg.value;
            uint tokenAmount = (msg.value * tokenReserve) / ethReserve;

            require(_amount >= tokenAmount, "Amount of tojens is less that the min requirement");

            token.transferFrom(msg.sender, address(this),tokenAmount);
            liquidity = (totalSupply() * msg.value) / ethReserve;
            _mint(msg.sender, liquidity);

        }
        return liquidity; 
    }

    /*remove liquidity function
    *burns LP token from removing liquidity
    *amount burned - amount being removed by user (msg.sender) 
    */

    function removedLiquidity (uint256 _amount) public returns (uint, uint){
        require(_amount > 0, "Amount should be greater than zero");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply();

        uint ethAmount = (ethReserve * _amount) / _totalSupply;
        uint tokenAmount = (getReserve() * _amount)/ _totalSupply;

        _burn(msg.sender, _amount); 

        //transfer eth/matic back to the user
        payable(msg.sender).transfer(ethAmount);
        ERC20(tokenAddress).transfer(msg.sender, tokenAmount);

        return (ethAmount, tokenAmount);
    } 

    function getAmountOfTokens(uint inputAmount, uint inputReserve, uint outputReserve) public pure returns(uint) {
        require (inputReserve > 0 && outputReserve > 0, "Invalid reserve.");

        uint256 inputAmountWithFee = inputAmount * 99 / 100;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = inputReserve + inputAmountWithFee;
        // Δy = (y * Δx) / (x + Δx)

        return (numerator / denominator);
    }

    //ETH > ATK == function to buy MyTokens by paying ETH
    function ethToMyToken(uint _minTokens) public payable {
        uint256 tokenReserve = getReserve();
        uint256 tokensBought = getAmountOfTokens(
            msg.value, //input amount
            address(this).balance - msg.value, // reserved eth in this contract
            tokenReserve //output reserve
        );
        require(tokensBought >= _minTokens, "Insufficient output amount.");
        ERC20(tokenAddress).transfer(msg.sender, tokensBought);
    }
    
    //ATK > ETH -- function to sell MyTokens and get back ETH
    function myTokenToEth(uint _tokensSold, uint _minEth) public payable {
        uint256 tokenReserve = getReserve();
        uint256 ethBought = getAmountOfTokens(
            _tokensSold, //the amt of tokens being sold back to the contract/DEX
            tokenReserve, //tokens held by the contract
            address(this).balance - msg.value //eth held by the contract
        );
        require(ethBought >= _minEth, "Insufficient output amount.");
        ERC20(tokenAddress).transferFrom(msg.sender, address(this), _tokensSold);
        payable(msg.sender).transfer(ethBought);
    }
}
