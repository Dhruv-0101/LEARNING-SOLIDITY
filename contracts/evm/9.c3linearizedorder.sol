// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint public x = 1; // x is a uint256 (32 bytes)
}

// Contract B - Inherits from A
contract B is A {
    uint public y = 2; // y is a uint256 (32 bytes)
}

// Contract C - Inherits from B
contract C is B {
    uint public z = 3; // z is a uint256 (32 bytes)

    function getSlotValue(uint slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}