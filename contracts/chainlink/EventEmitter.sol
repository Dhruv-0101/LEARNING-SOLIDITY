// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract EventEmitter {
    event WantsToCount(address indexed eventEmitter);

    function emitCountLog() public {
        emit WantsToCount(msg.sender);
    }
}
