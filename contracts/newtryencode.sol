// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract EncodeDecodeData {
    // ENCODE: converts typed data to raw bytes
    function encodeData(
        uint256 fixedNumber,
        string memory dynamicString,
        uint256[2] memory fixedArray,
        uint256[] memory dynamicArray
    ) public pure returns (bytes memory) {
        return abi.encode(fixedNumber, dynamicString, fixedArray, dynamicArray);
    }

    // DECODE: converts raw bytes back to typed data
    function decodeData(bytes memory data)
        public
        pure
        returns (
            uint256,
            string memory,
            uint256[2] memory,
            uint256[] memory
        )
    {
        (
            uint256 fixedNumber,
            string memory dynamicString,
            uint256[2] memory fixedArray,
            uint256[] memory dynamicArray
        ) = abi.decode(data, (uint256, string, uint256[2], uint256[]));
        return (fixedNumber, dynamicString, fixedArray, dynamicArray);
    }
}