// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Contract2 {
    function sumAndAverage(uint num1, uint num2, uint num3, uint num4) external pure returns(uint, uint){
        uint sum = num1 + num2 + num3 + num4;
        return (sum, sum / 4);
    }
}