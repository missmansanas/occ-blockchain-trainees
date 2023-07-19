/**
5.]
    > Create a pure, external function `sum` which takes a fixed size array of **five unsigned integers**.
    > Find the sum of the unsigned integers and return it as a `uint`.
 */

 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Five {
    function sum(uint256[5] memory numbers) external pure returns (uint256) {
        uint256 totalSum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            totalSum += numbers[i];
        }
        return totalSum;
    }
}

