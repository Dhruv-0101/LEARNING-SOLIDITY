// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 'import' brings in code from the Chainlink contracts library.
// 'Log' is a data structure (struct) that holds event information.
// 'ILogAutomation' is an "interface" - a contract blueprint we must follow.
import {Log, ILogAutomation} from "@chainlink/contracts/src/v0.8/automation/interfaces/ILogAutomation.sol";

/**
 * @title LogTrigger
 * @notice This contract listens for a specific event from another contract and
 * increments a counter each time it's detected.
 */
// By stating 'is ILogAutomation', we promise this contract will have the
// functions required by the Chainlink Automation Log Trigger, like 'checkLog'.
contract LogTrigger is ILogAutomation {
    // This is this contract's own event, used to confirm it did its job.
    event CountedBy(address indexed originalEmitter);

    // A 'public' state variable to store our counter. Anyone can read its value.
    uint256 public counted;

    // This is the first required function. Chainlink calls this off-chain when it sees a matching log.
    // 'log' contains all the data from the 'WantsToCount' event.
    // 'override' indicates we are implementing a function from the 'ILogAutomation' interface.
    // 'pure' means this function doesn't read or write any state variables.
    function checkLog(
        Log calldata log,
        bytes memory /* checkData */
    )
        external
        pure
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        // We extract the address from the log's "topics".
        // Topics are where indexed event parameters are stored.
        // log.topics[0] is the event signature.
        // log.topics[1] is the first indexed parameter - the address we need.
        // We use a helper function to convert it from bytes32 to a usable address.
        address logSender = bytes32ToAddress(log.topics[1]);

        // We tell the Chainlink node that an on-chain action is needed.
        upkeepNeeded = true;
        // We encode the address we found so we can pass it to the next function.
        performData = abi.encode(logSender);
    }

    // This is the second required function. Chainlink calls this on-chain if checkLog returned true.
    // 'performData' contains the encoded address we sent from checkLog.
    function performUpkeep(bytes calldata performData) external override {
        // Increase our counter by 1.
        counted += 1;

        // 'abi.decode' unpacks the 'performData' bytes back into an address type.
        address logSender = abi.decode(performData, (address));

        // We emit our own event to prove that the upkeep ran and to log
        // who the original event emitter was.
        emit CountedBy(logSender);
    }

    // This is a helper function to safely convert the topic data type to an address.
    // It's 'public' so it can be called internally and 'pure' because it only works on its inputs.
    function bytes32ToAddress(bytes32 _bytes32) public pure returns (address) {
        // Solidity addresses are 160 bits (20 bytes). The topic is 256 bits (32 bytes).
        // This conversion safely truncates the bytes32 value to the correct size for an address.
        return address(uint160(uint256(_bytes32)));
    }
}
/*The Chain of Events ⛓️
Here’s the step-by-step flow:

The Signal 📢 (EventEmitter.sol)

Someone calls the emitCountLog() function.

This contract fires off the WantsToCount event like a flare gun, creating a signal on the blockchain.

The Watcher 👀 (Chainlink Automation)

The Chainlink Automation network is constantly watching the EventEmitter contract, specifically looking for that WantsToCount flare.

The Action ⚙️ (LogTrigger.sol)

When a Chainlink node sees the flare, it immediately calls the checkLog function on your LogTrigger contract to verify it.

Because checkLog returns true, the node then calls performUpkeep on LogTrigger to run the main logic (like increasing the counter).*/