// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

interface IGasPrice {
    function maxGasPrice() external returns (uint);
}