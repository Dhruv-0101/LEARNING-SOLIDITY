// SPDX-License-Identifier: MIT
// Specifies the open-source license for the code.

pragma solidity ^0.8.26;

// Defines the version of the Solidity compiler this code is written for.

/**
 * @title EventEmitter
 * @notice This contract's only job is to emit an event that a Log Trigger
 * automation can listen for.
 */
contract EventEmitter {
    // Declares the smart contract.

    /**
     * @notice This is the event that will trigger the LogTrigger contract.
     * @param eventEmitter The address that emitted this event.
     */
    // 'event' declares a loggable event. Think of it as a signal.
    // 'WantsToCount' is the name of our signal.
    // 'address' is the type of data we want to log.
    // 'indexed' makes this data searchable, which is crucial for the Log Trigger.
    // 'eventEmitter' is the name of the variable holding the address.
    event WantsToCount(address indexed eventEmitter);

    /**
     * @notice When called, this function emits the WantsToCount event.
     */
    // 'function' defines a new function.
    // 'emitCountLog' is its name.
    // 'public' means anyone can call this function.
    function emitCountLog() public {
        // 'emit' is the action of firing the event we declared above.
        // 'WantsToCount()' specifies which event to fire.
        // 'msg.sender' is a global variable that always contains the address
        // of the person or contract calling the current function.
        // So, this line logs the caller's address.
        emit WantsToCount(msg.sender);
    }
}
