pragma solidity ^0.8.0;

contract Example {
    uint public startTime;

    constructor() {
        startTime = block.timestamp; // Stores the deployment time
    }

    function getBlockTime() public view returns (uint) {
        return block.timestamp; // Returns the current block's timestamp
    }
}
/*
Contract is deployed	                       1700000000 (timestamp of the deployment block)
User calls getBlockTime() at a later time	   1700000300 (new block timestamp, 5 minutes later)
Another user calls getBlockTime() even later   1700000500 (new block timestamp, 10 minutes later)

✅ Real-Life Analogy
Imagine a digital clock on a wall:

When you first install the clock (contract deployment), it shows the current time.
Every time you check the clock (block.timestamp inside a function), it updates to the current time.

*/