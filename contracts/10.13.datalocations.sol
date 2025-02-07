// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// storage-Characteristics:
// Persistent: Data is stored on the blockchain and persists between function calls and transactions.
// Expensive: Operations on storage are costly in terms of gas because it involves writing to the blockchain.
// Default Location: State variables are stored in storage by default.

// memory-Characteristics:
// Temporary: Data is not saved on the blockchain and exists only while the function is executing.
// Cheaper: Operations on memory are less expensive compared to storage.
// Explicitly Specified: You need to explicitly specify memory for dynamic arrays and structs.

// 3. calldata-Definition
// -calldata is a read-only data location used for function arguments. It is used when dealing with external function calls and is immutable (cannot be modified).
// Characteristics:

// Read-Only: Data in calldata cannot be modified. It is used for function parameters in external function calls.
// Efficient: Accessing calldata is more gas-efficient for function arguments compared to copying them into memory.
// Default for External Functions: Function parameters of external functions use calldata by default.




