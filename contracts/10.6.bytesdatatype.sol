// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    bytes2 public arr1 = "ab";

    function returnArray() public view returns (bytes1) {
        return arr1[0];
    }
}
