// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
5.]
    > Create a pure, external function `sum` which takes a fixed size array of **five unsigned integers**.
    > Find the sum of the unsigned integers and return it as a `uint`.
 */
contract lastItem {
    function sum(uint256[5] memory integers) external pure returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i < integers.length; i++) {
            total += integers[i];
        }
        return total;
    }
}
