// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/** 
 2.]
    > Create an external, pure function called sumAndAverage that has four uint parameters.
    > Find both the sum and the average of the four numbers. Return these two values in this order as unsigned integers.
*/
contract Calculate {
    function sumAndAverage(
        uint256 first,
        uint256 second,
        uint256 third,
        uint256 fourth
    ) external pure returns (uint256, uint256) {
        uint256 sum = first + second + third + fourth;
        uint256 average = sum / 4;
        return (sum, average);
    }
}
