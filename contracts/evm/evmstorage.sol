// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Demo {
    uint256 public num1; //slot 0
    address public user; //slot1
    uint8 public num2; //slot1
    bool public valuel; //slot1
    bool public value2; //slot1
    bool public value3; //slot1
    bytes16 public data; //slot2
    mapping(address => uint256) public banana; //slot3

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
            num1Slot := num1.slot
            userSlot := user.slot
            num2Slot := num2.slot
            valuelSlot := valuel.slot
            value2Slot := value2.slot
            value3Slot := value3.slot
            dataSlot := data.slot
            bananaSlot := banana.slot
        }
    }
}
