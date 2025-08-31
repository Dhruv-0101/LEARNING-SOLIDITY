// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Demo {
    uint256 public num1; // slot 0 - 256 bits (32 bytes), occupies the entire slot

    // slot 1 is shared by multiple smaller variables due to Solidity storage packing
    address public user; // slot 1 (bits 0-159) - 160 bits (20 bytes)
    uint8 public num2;   // slot 1 (bits 160-167) - 8 bits (1 byte)
    bool public valuel;  // slot 1 (bits 168-175) - 8 bits (1 byte)
    bool public value2;  // slot 1 (bits 176-183) - 8 bits (1 byte)
    bool public value3;  // slot 1 (bits 184-191) - 8 bits (1 byte)
    // Total used in slot 1: 160 + 8 + 8 + 8 + 8 = 192 bits (24 bytes), leaving 64 bits unused in this slot

    bytes16 public data;  // slot 2 - 128 bits (16 bytes), leaving 128 bits unused in this slot

    mapping(address => uint256) public banana; 
    // slot 3 - This is a special slot (mapping doesn't store data directly).
    // The slot is used as a "starting point" for the mapping.
    // Each key (address) is hashed with this slot number using keccak256 to find the actual storage location.
    // Actual data for each mapping entry is stored in a new slot computed as:
    // keccak256(abi.encode(key, slot_number))

    function getSlots()
        public
        pure
        returns (
            uint256 num1Slot,
            uint256 userSlot,
            uint256 num2Slot,
            uint256 valuelSlot,
            uint256 value2Slot,
            uint256 value3Slot,
            uint256 dataSlot,
            uint256 bananaSlot
        )
    {
        assembly {
            num1Slot := num1.slot      // Returns slot 0
            userSlot := user.slot      // Returns slot 1
            num2Slot := num2.slot      // Returns slot 1
            valuelSlot := valuel.slot  // Returns slot 1
            value2Slot := value2.slot  // Returns slot 1
            value3Slot := value3.slot  // Returns slot 1
            dataSlot := data.slot      // Returns slot 2
            bananaSlot := banana.slot  // Returns slot 3
        }
    }
}
