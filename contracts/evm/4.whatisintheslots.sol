// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


contract Demo {
    uint8 public a = 0x1e; //slot 0
    uint256 public b = 0xffe123; //slot 1
    bool public c = true; //slot 2
    string public d = "hello"; //slot 3


    // Function to read the contents of a storage slot
    function getSlotValue(uint slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}

