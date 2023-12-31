// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IWhitelist {
    function isWhitelisted(address _address) external view returns (bool);
}
