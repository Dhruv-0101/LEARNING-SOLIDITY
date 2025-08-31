// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Demo {
    uint8 public a = 10; //slot 0
    uint8 public b = 0xff; //slot 0
    bool public c = true; //slot 0

    // Function to read the contents of a storage slot
    function getSlotValue(uint slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}