// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Demo {
    uint256 a = 1234;
    uint8 b = 0x12;
    uint8[6] c = [1, 2, 3, 4, 5, 6];
    uint256[2] d = [10, 20];

    // Function to read the contents of a storage slot
    function getSlotValue(uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}
//1️⃣ Why Can’t c[0] Fit into Slot 1?
// Your Slot 1 contains uint8 b, which takes only 1 byte. Theoretically, there are 31 empty bytes left in Slot 1. So, why does Solidity not use this leftover space for c[0]?

// Reason: Arrays Start in a Fresh Slot
// Even if there is space left in Slot 1, Solidity does not mix array elements with individual variables because:

// Fixed-size arrays and structs always start at a fresh storage slot.
// This ensures sequential storage and predictable access patterns.
// Solidity does not "backfill" leftover space with array elements.