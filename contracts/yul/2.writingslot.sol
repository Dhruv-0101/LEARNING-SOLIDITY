// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract WriteToCDemo {
    // These variables are packed into slot 0. C's byte offset will be 28.
    uint128 public A = 22;
    uint96 public B = 15;
    uint16 public C = 8;


    function writeToC(uint16 newC) external { // 24708 gas
        assembly {
            // 1. Load the entire 32-byte slot from storage
            let slotValue := sload(C.slot)
            
            // 2. Create a bitmask to clear out the specific bits where C is stored
            let clearedC := and(
                slotValue,
                0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffff
            )

            // 3. Shift the new value to its correct position within the slot
            let shiftedNewC := shl(mul(C.offset, 8), newC)
            
            // 4. Combine the cleared slot value with the new shifted value
            let newSlotValue := or(shiftedNewC, clearedC)
            
            // 5. Save the updated 32-byte value back to storage
            sstore(C.slot, newSlotValue)
        }
    }
}