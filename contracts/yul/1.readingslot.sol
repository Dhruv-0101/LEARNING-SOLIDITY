// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OffsetAndShfiting {
    uint128 public A = 22;
    uint96 public B = 15;
    uint16 public C = 8;
    uint8 public D = 1;

    function readValueBySlot(uint256 slot) external view returns (bytes32 value) {
        assembly {
            value := sload(slot)
            //0x0001000800000000000000000000000f00000000000000000000000000000016
        }
    }

    function getOffsetOfC() external pure returns (uint256 slot, uint256 offset) {
        assembly {
            slot := C.slot
            offset := C.offset //offset tell the position of C.
            //In short go 28 bytes to the left to find the vlaue of C
        }
    }

    function readValue0fC() external view returns (uint256 c) { // 2533 gas
        assembly {
            let value := sload(C.slot)
            // C.offset = 28
            let shifted := shr(mul(C.offset, 8), value) //shifting right by 28*8 bits
            // 0x00000000000000000000000000000000000000000000000000000000000010008
            // 'and' operation will be applied
            // 0x0000000000000000000000000000000000000000000000000000000000000ffff
            c := and(0xffff, shifted)
        }
    }
}