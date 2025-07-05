// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract IntegerExample {
    // State variables to store signed integers
    int256 public smallNumber; // 256-bit signed integer
    int8 public tinyNumber; // 8-bit signed integer

    // Constructor to initialize the state variables
    constructor(int256 _smallNumber, int8 _tinyNumber) {
        smallNumber = _smallNumber;
        tinyNumber = _tinyNumber;
    }

    // Function to set new values for the state variables
    function setNumbers(int256 _smallNumber, int8 _tinyNumber) public {
        smallNumber = _smallNumber;
        tinyNumber = _tinyNumber;
    }

    // Function to get the values of the state variables
    function getNumbers() public view returns (int256, int8) {
        return (smallNumber, tinyNumber);
    }

    // Function to demonstrate arithmetic operations with integers
    function addNumbers(int256 a, int256 b) public pure returns (int256) {
        return a + b;
    }

    function subtractNumbers(int256 a, int256 b) public pure returns (int256) {
        return a - b;
    }

    function multiplyNumbers(int256 a, int256 b) public pure returns (int256) {
        return a * b;
    }

    function divideNumbers(int256 a, int256 b) public pure returns (int256) {
        require(b != 0, "Division by zero is not allowed");
        return a / b;
    }
}
//-2^(n-1) to 2^(n-1)-1
//0 to 2^(n)-1
