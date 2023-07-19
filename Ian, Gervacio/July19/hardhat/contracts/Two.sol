/*
 2.]
    > Create an external, pure function called sumAndAverage that has four uint parameters.
    > Find both the sum and the average of the four numbers. Return these two values in this order as unsigned integers.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Dos {
    function sumAndAverage(uint256 uno, uint256 dos, uint256 tres, uint256 quatro) external pure returns(uint256, uint256) {
    uint sum = uno + dos + tres + quatro;
    uint average = sum/4;

    return(sum, average);
    }
}
