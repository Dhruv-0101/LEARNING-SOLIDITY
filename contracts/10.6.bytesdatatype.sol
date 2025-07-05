// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    bytes3 public arr1 = "ab1";
    // So 31 in the output 0x616231 is just the hex code for the character '1' (ASCII 49).

    function returnArray() public view returns (bytes1) {
        return arr1[0];
    }

    function returnwholeArray() public view returns (bytes3) {
        return arr1;
    }
}
// In Solidity, when you assign a string like "ab1" to a fixed-size byte array like bytes3, each character is stored as ASCII bytes.
// | Character | ASCII (decimal) | Hex      |
// | --------- | --------------- | -------- |
// | `a`       | 97              | `0x61`   |
// | `b`       | 98              | `0x62`   |
// | `1`       | 49              | `0x31` ✅ |
