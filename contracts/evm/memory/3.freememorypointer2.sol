// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MemoryDemo
 * @dev Demonstrates reading the free memory pointer before and after allocation
 * in a single function call.
 */
contract MemoryDemo {

    /**
     * @notice Captures the free memory pointer's value, then allocates memory for
     * two arrays, and captures the pointer's new value.
     * @return pointerBefore The free memory pointer before allocation (e.g., 0x80).
     * @return pointerAfter The free memory pointer after allocation (e.g., 0x100).
     */
    function getPointersBeforeAndAfter()
        public
        pure
        returns (bytes32 pointerBefore, bytes32 pointerAfter)
    {
        // Step 1: Capture the pointer's value BEFORE memory is used.
        assembly {
            pointerBefore := mload(0x40)
        }

        // Step 2: Allocate memory for two arrays. This action updates the
        // value stored at memory address 0x40.
        uint8[3] memory items1 = [1, 2, 3];
        uint8[3] memory items2 = [4, 5, 6];

        // Step 3: Capture the pointer's new value AFTER the allocation.
        assembly {
            pointerAfter := mload(0x40)
        }
    }
}