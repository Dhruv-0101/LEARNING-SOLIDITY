// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BitShiftOperations {
    // Function to perform multiplication using left shift
    function multiply(uint8 a, uint8 shifts) public pure returns (uint256) {
        return (a << shifts);
    }

    // Function to perform division using right shift
    function divide(uint8 a, uint8 shifts) public pure returns (uint256) {
        return (a >> shifts);
    }
}