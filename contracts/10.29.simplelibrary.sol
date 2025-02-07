// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Creating a Library
library MathLibrary {
    function add(uint a, uint b) internal pure returns (uint) {
        return a + b;
    }

    function multiply(uint a, uint b) internal pure returns (uint) {
        return a * b;
    }
}

// Using Library in a Contract
contract Calculator {
    // using MathLibrary for uint;  // Attaching the library to uint type

    function getSum(uint x, uint y) public pure returns (uint) {
        return MathLibrary.add(x,y); // Uses MathLibrary's add function
    }

    // function getProduct(uint x, uint y) public pure returns (uint) {
    //     return x.multiply(y); // Uses MathLibrary's multiply function
    // }
}
