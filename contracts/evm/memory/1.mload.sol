// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MemoryExample {
    function storeAndLoad() public pure returns (bytes32) {
        bytes32 freeMemoryPointer;
        assembly {
            // Load the value from memory location 0x40
            freeMemoryPointer := mload(0x40)
        }
        return freeMemoryPointer;
    }
}