// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageExample {
    struct SomeStruct {
        uint256 firstValue; // 32 bytes
        uint16 secondValue; // 2 bytes
        bool thirdValue; // 1 byte
    }

    uint256 a = 1234; // Stored in slot 0
    uint256 b = 0x123456; // Stored in slot 1
    SomeStruct structVariable = SomeStruct(0x234, 5, true); // Stored in slot 2

    // Function to read the contents of a storage slot
    function getSlotValue(uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}

