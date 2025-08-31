
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
contract Demo {
    uint256 a = 0x1a01; //slot 0
    uint256 b = 0x2a01; //slot 1
    uint256[] c; //slot 2 = length of c
    uint256 d = 0x5a01; //slot 3

    constructor() {
        c.push(0xb);
        c.push(0xef2134);
        c.push(0x2342);
    }

    function getArrayElementSlot(uint256 index, uint256 storedArraySlot)
        public
        pure
        returns (uint256)
    {
        uint256 arrayElementSlot = uint256(
            keccak256(abi.encodePacked(storedArraySlot))
        ) + index;
        return arrayElementSlot;
    }

    function getSlotValue(uint256 slot) public view returns (bytes32) {
        bytes32 value;
        assembly {
            value := sload(slot)
        }
        return value;
    }
}
