// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract enocdedata {
    function encodeData(
        uint256 fixedNumber,
        string memory dynamicString,
        uint256[2] memory fixedArray,
        uint256[] memory dynamicArray
    ) public pure returns (bytes memory) {
        return abi.encode(fixedNumber, dynamicString, fixedArray, dynamicArray);
    }

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
/*

| Address     | Description                              | Offset from 0x80     | Notes                                                            |
| ----------- | ---------------------------------------- | -------------------- | ---------------------------------------------------------------- |
| `0x00`      | Reserved                                 |                      | Solidity internal use                                            |
| `0x40`      | Free memory pointer (`0x200`)            |                      | Points to next free space in memory                              |
| ----------- | ---------------------------------------- | -------------------- | ---------------------------------------------------------------- |
| `0x80`      | `2` (`uint256`)                          | `0x00`               | Static value                                                     |
| `0xA0`      | `0xC0` → offset to `"abc"`               | `0x20`               | `0x140 - 0x80 = 0xC0`                                            |
| `0xC0`      | `1` (first element of `[1,2]`)           | `0x40`               | Fixed-size array, directly embedded                              |
| `0xE0`      | `2` (second element of `[1,2]`)          | `0x60`               | Fixed-size array, directly embedded                              |
| `0x100`     | `0x100` → offset to `[1,2,3]`            | `0x80`               | `0x180 - 0x80 = 0x100`                                           |
| ----------- | ---------------------------------------- | -------------------- | ---------------------------------------------------------------- |
| `0x140`     | Length of `"abc"` = 3                    | `0xC0`               | Dynamic string length prefix                                     |
| `0x160`     | `"abc"` = `0x616263` padded to 32B       | `0xE0`               | String data padded with zeros                                    |
| ----------- | ---------------------------------------- | -------------------- | ---------------------------------------------------------------- |
| `0x180`     | Length of `[1,2,3]` = 3                  | `0x100`              | Dynamic array starts here (offset target of `0x100`)             |
| `0x1A0`     | `1` (first element of `[1,2,3]`)         | `0x120`              | Element 1                                                        |
| `0x1C0`     | `2` (second element)                     | `0x140`              | Element 2                                                        |
| `0x1E0`     | `3` (third element)                      | `0x160`              | Element 3                                                        |
| ----------- | ---------------------------------------- | -------------------- | ---------------------------------------------------------------- |
| `0x200`     | (free memory starts here)                |                      | `0x40` pointer now points here                                   |


At 0xA0 → it stores 0x60, meaning "go 0x60 bytes forward from 0x80" → 0x80 + 0x60 = 0xE0 + 0x60 = 0x140, where "abc" begins.

At 0x100 → it stores 0x100, meaning "go 0x100 bytes forward from 0x80" → 0x80 + 0x100 = 0x180, where [1,2,3] begins.

❓Your core question:
When Solidity is placing static data step-by-step, and it encounters a dynamic value (e.g., a string or dynamic array), it needs to place an offset there.
But since the dynamic content isn't placed yet, and the offset isn't known yet —
what is stored temporarily at that position in memory at that time?

✅ Answer:
Nothing meaningful is stored at that moment.
Solidity just reserves the 32 bytes, leaves them blank (zero) or uninitialized, and moves on.
Later, once the dynamic content is written, it goes back and fills in the actual offset.

🧠 So yes, again:
Offsets are written after static data is placed,
and they are relative to the beginning of the encoding (0x80).


*/
