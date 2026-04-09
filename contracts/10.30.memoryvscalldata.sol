// ✅ Example of calldata in Solidity

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallDataExample {
    function getFirstCharacter(string calldata name)
        external
        pure
        returns (bytes1)
    {
        return bytes(name)[0]; // Reads but does not modify calldata
    }
}

// Function Parameter (string calldata name)

// The name variable is stored in calldata, meaning it cannot be modified.
// This is gas-efficient because calldata avoids unnecessary copying.

contract MemoryVsCalldata {
    // ✅ Function using 'memory' (can modify string)
    function modifyStringMemory(string memory text)
        public
        pure
        returns (string memory)
    {
        text = "Modified String"; // ✅ Allowed: memory variables can be changed
        return text;
    }

    // ❌ Function using 'calldata' (cannot modify string)
    function readOnlyStringCalldata(string calldata text)
        external
        pure
        returns (string calldata)
    {
        // text = "Modified"; ❌ Not Allowed: calldata is immutable
        return text;
    }
}

