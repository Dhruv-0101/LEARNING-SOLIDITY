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
//memory representation
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

/*
| **Address** | **Description**             | **Offset from `0x80`** | **Bytes (32 bytes)**                                               | **Notes / Offset Calculation**                               |
| ----------- | --------------------------- | ---------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------ |
| `0x80`      | `2` (`uint256`)             | `0x00`                 | `0000000000000000000000000000000000000000000000000000000000000002` | Direct static value                                          |
| `0xA0`      | Offset to `"abc"`           | `0x20`                 | `00000000000000000000000000000000000000000000000000000000000000C0` | Points to `0x140`; so `0x140 - 0x80 = 0xC0`                  |
| `0xC0`      | `[1, 2]` – first element    | `0x40`                 | `0000000000000000000000000000000000000000000000000000000000000001` | Fixed array, stored inline                                   |
| `0xE0`      | `[1, 2]` – second element   | `0x60`                 | `0000000000000000000000000000000000000000000000000000000000000002` | Fixed array, stored inline                                   |
| `0x100`     | Offset to `[1,2,3]`         | `0x80`                 | `0000000000000000000000000000000000000000000000000000000000000100` | Points to `0x180`; so `0x180 - 0x80 = 0x100`                 |
| `0x140`     | Length of `"abc"` = 3       | `0xC0`                 | `0000000000000000000000000000000000000000000000000000000000000003` | String length (dynamic value)                                |
| `0x160`     | `"abc"` = `0x616263` padded | `0xE0`                 | `6162630000000000000000000000000000000000000000000000000000000000` | UTF-8 string `"abc"`, left-aligned, right-padded to 32 bytes |
| `0x180`     | Length of `[1,2,3]` = 3     | `0x100`                | `0000000000000000000000000000000000000000000000000000000000000003` | Dynamic array length                                         |
| `0x1A0`     | `[1,2,3]` – element 1       | `0x120`                | `0000000000000000000000000000000000000000000000000000000000000001` | Element 1 of dynamic array                                   |
| `0x1C0`     | `[1,2,3]` – element 2       | `0x140`                | `0000000000000000000000000000000000000000000000000000000000000002` | Element 2 of dynamic array                                   |
| `0x1E0`     | `[1,2,3]` – element 3       | `0x160`                | `0000000000000000000000000000000000000000000000000000000000000003` | Element 3 of dynamic array                                   |
| `0x200`     | (Free memory starts here)   |                        | *(unallocated)*                                                    | `0x40` memory pointer now points here                        |

| **Offset** | **Description**             | **Bytes (32 bytes)**                                               | **Notes / Offset Calculation**                                |
| ---------- | --------------------------- | ------------------------------------------------------------------ | ------------------------------------------------------------- |
| `0x00`     | `2` (`uint256`)             | `0000000000000000000000000000000000000000000000000000000000000002` | Static value                                                  |
| `0x20`     | Offset to `"abc"`           | `00000000000000000000000000000000000000000000000000000000000000A0` | Offset to start of string `"abc"` = `0xA0` from `0x00`        |
| `0x40`     | `[1, 2]` – element 1        | `0000000000000000000000000000000000000000000000000000000000000001` | Fixed-size array, stored inline                               |
| `0x60`     | `[1, 2]` – element 2        | `0000000000000000000000000000000000000000000000000000000000000002` |                                                               |
| `0x80`     | Offset to `[1,2,3]`         | `00000000000000000000000000000000000000000000000000000000000000E0` | Offset to dynamic array `[1,2,3]` from calldata base (`0xE0`) |
| `0xA0`     | Length of `"abc"` = 3       | `0000000000000000000000000000000000000000000000000000000000000003` | Starts at offset `0xA0` (from pointer at `0x20`)              |
| `0xC0`     | `"abc"` = `0x616263` padded | `6162630000000000000000000000000000000000000000000000000000000000` | Padded string content                                         |
| `0xE0`     | Length of `[1,2,3]` = 3     | `0000000000000000000000000000000000000000000000000000000000000003` | Starts at `0xE0`, from pointer at `0x80`                      |
| `0x100`    | `[1,2,3]` – element 1       | `0000000000000000000000000000000000000000000000000000000000000001` |                                                               |
| `0x120`    | `[1,2,3]` – element 2       | `0000000000000000000000000000000000000000000000000000000000000002` |                                                               |
| `0x140`    | `[1,2,3]` – element 3       | `0000000000000000000000000000000000000000000000000000000000000003` |                                                               |

🧮 Offset Explanation
📌 Memory Offsets (relative to 0x80):
Solidity ABI encoder starts at address 0x80 when writing to memory.
So if your data begins at 0x140, the memory offset is:
👉 0x140 - 0x80 = 0xC0


📌 Calldata Offsets (relative to 0x00):
Calldata starts at 0x00.
So if the string content begins at 0xA0, the offset in the selector is simply 0xA0.

| Feature         | Memory              | Calldata                   |
| --------------- | ------------------- | -------------------------- |
| Base Address    | `0x80`              | `0x00`                     |
| Who uses it?    | Solidity internally | External function input    |
| Can be changed? | ✅ Yes               | ❌ No                       |
| Offset Meaning  | From `0x80`         | From `0x00`                |
| Purpose         | Internal processing | ABI-encoded function input |

✅ "External function input" means:
👉 The data sent from outside the contract (like from a wallet, script, or frontend) when calling a function.

🔧 Example:
You have a smart contract function:
function f(uint x, string memory s, uint[2] memory arr1, uint[] memory arr2) external { }
When someone calls this function from outside (e.g. from JavaScript, Web3.js, Ethers.js, or Remix), the parameters are sent to the Ethereum Virtual Machine (EVM) as calldata.

🔍 Calldata is:
📦 The raw ABI-encoded input data.

📬 Passed along with the transaction.

🧊 Stored temporarily and cannot be modified.

💡 Used only for reading function inputs.

🧠 Why is calldata needed?
The EVM doesn't understand high-level arguments like "abc" or [1,2,3]. So these are encoded as a sequence of 32-byte values according to the ABI (Application Binary Interface) format, and placed in calldata.

🔹 Step 1: You call an external function
Like this in Solidity:

solidity
function f(uint256 a, string memory str, uint256[2] memory arr1, uint256[] memory arr2) external
And the input is:
f(2, "abc", [1, 2], [1, 2, 3])




📦 Step 2: Calldata is created and sent to the EVM
This is a compact read-only byte array.

It starts with the function selector (first 4 bytes)

Then it encodes the values:

Static values go inline (like uint256)

Dynamic values (string, dynamic array) use calldata offsets to point further ahead

✅ So in calldata:

The a = 2 is stored directly.

The string and dynamic array use offsets like 0xA0, 0xE0 to point to their actual locations within the calldata.




🧠 Step 3: EVM decodes calldata and loads it into memory
When Solidity executes the function body:

It copies and organizes the input into memory.

Memory starts storing arguments from address 0x80 onward.

Dynamic types use offsets from 0x80 (the base memory position of arguments).
*/
