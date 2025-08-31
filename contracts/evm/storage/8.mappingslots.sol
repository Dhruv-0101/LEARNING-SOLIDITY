
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Demo {
    uint256 a = 0x1a01; //slot 0
    uint256 b = 0x2a01; //slot 1
    mapping(uint256 => uint256) c;//maping exist at slot 2
    uint256 d = 0x5a01; //slot 3

    constructor() {
        c[10] = 0xfe3f;
        c[100] = 0xabcd;
    }

    // Function to read the value at a specific key in the mapping
    function getMappingValue(uint256 key, uint256 mappingSlot)
        public
        pure
        returns (uint256)
    {
        uint256 slot = uint256(keccak256(abi.encodePacked(key, mappingSlot)));
        return slot;
    }

    function getSlotValue(uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}
