// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    int256 public count;

    // increment function
    function increment() external {
        count += 1;
    }

    // decrement function
    function decrement() external {
        count -= 1;
    }

    // read function (optional, public variable already creates getter)
    function getCount() external view returns (int256) {
        return count;
    }
}
