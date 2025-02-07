// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    uint[3] public arr = [10, 20, 30];

    // Function using storage (modifies the state variable directly)
    function storageArr() external returns (uint[3] memory) {
        uint[3] storage stoArr = arr;
        stoArr[0] = 1; // Changes reflect in 'arr'
        return arr; // Returning 'arr' instead of 'stoArr' (storage variables can't be returned)
    }

    // Function using memory (creates a copy and doesn't modify the original state)
    function memoryArr() external view returns (uint[3] memory) {
        uint[3] memory memArr = arr;
        memArr[0] = 1; // Changes do NOT reflect in 'arr'
        return memArr;
    }
}

