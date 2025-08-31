// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Test {
    function test() external pure returns (uint data1, uint data2, uint data3) {
        assembly {
            // Set the free memory pointer to 0xa0
            mstore(0x40, 0xa0)
        }

        uint8[3] memory items = [1,2,3];

        assembly {
            data1 := mload(0xa0)
            data2 := mload(add(0xa0, 0x20)) // 0xa0 + 0x20 = 0xc0
            data3 := mload(add(0xa0, 0x40)) // 0xa0 + 0x40 = 0xe0
        }
        
        return (data1, data2, data3);
    }
}