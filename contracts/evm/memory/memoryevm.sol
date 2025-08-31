// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// contract MemoryExample {
//     function storeAtMemory() public pure {
//         uint256 valueToStore = 1;
//         assembly {
//             // Store the value 1 at memory location 0x00
//             mstore(0x00, valueToStore)
//         }
//     }
// }



contract MemoryExample {
    function storeAndRetrieveMemory() public pure returns (uint256) {
        uint256 valueToStore = 1;
        uint256 retrievedValue;
        assembly {
            mstore8(0x00, valueToStore) // Store 1 at memory location 0x00
            retrievedValue := mload(0x00) // Load the stored value
        }
        return retrievedValue; // Should return 1
    }
}

/*
🚀 Final Answer
If Using mstore:
Retrieve with:
retrievedValue := mload(0x00) // Reads full 32 bytes
✅ Works because the value is right-aligned.

If Using mstore8:
Retrieve with:
retrievedValue := byte(0, mload(0x00)) // Extracts the first byte
✅ Works because the value is stored in the leftmost byte.
*/


