// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
GOAL:
- Show transient storage WITHOUT confusion
- Read value in SAME transaction
*/

contract TransientFeel {

    bytes32 constant SLOT = 0;

    /*
    This function:
    1️⃣ Writes to transient storage
    2️⃣ Immediately reads it
    3️⃣ Returns it

    SAME TRANSACTION
    */
    function writeAndRead() external returns (uint256) {

        // ✍️ Write temporary value
        assembly {
            tstore(SLOT, 777)
        }

        uint256 value;

        // 👀 Read temporary value
        assembly {
            value := tload(SLOT)
        }

        // ✅ WILL ALWAYS RETURN 777
        return value;
    }

    /*
    New transaction = transient wiped
    */
    function readLater() external view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
        // ❌ Will ALWAYS return 0
    }
}
