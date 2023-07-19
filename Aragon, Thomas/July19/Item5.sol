// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
contract Contract5 {
    function sum(uint[5] memory num) external pure returns (uint) {
        uint numberSum;
        for(uint counter = 0; counter < num.length; counter++){
            numberSum += num[counter];
        }

        return numberSum;
    }
}