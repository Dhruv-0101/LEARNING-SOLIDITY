
// File: @chainlink/contracts/src/v0.8/automation/interfaces/ILogAutomation.sol


pragma solidity ^0.8.0;

/**
 * @member index the index of the log in the block. 0 for the first log
 * @member timestamp the timestamp of the block containing the log
 * @member txHash the hash of the transaction containing the log
 * @member blockNumber the number of the block containing the log
 * @member blockHash the hash of the block containing the log
 * @member source the address of the contract that emitted the log
 * @member topics the indexed topics of the log
 * @member data the data of the log
 */
struct Log {
  uint256 index;
  uint256 timestamp;
  bytes32 txHash;
  uint256 blockNumber;
  bytes32 blockHash;
  address source;
  bytes32[] topics;
  bytes data;
}

interface ILogAutomation {
  /**
   * @notice method that is simulated by the keepers to see if any work actually
   * needs to be performed. This method does does not actually need to be
   * executable, and since it is only ever simulated it can consume lots of gas.
   * @dev To ensure that it is never called, you may want to add the
   * cannotExecute modifier from KeeperBase to your implementation of this
   * method.
   * @param log the raw log data matching the filter that this contract has
   * registered as a trigger
   * @param checkData user-specified extra data to provide context to this upkeep
   * @return upkeepNeeded boolean to indicate whether the keeper should call
   * performUpkeep or not.
   * @return performData bytes that the keeper should call performUpkeep with, if
   * upkeep is needed. If you would like to encode data to decode later, try
   * `abi.encode`.
   */
  function checkLog(
    Log calldata log,
    bytes memory checkData
  ) external returns (bool upkeepNeeded, bytes memory performData);

  /**
   * @notice method that is actually executed by the keepers, via the registry.
   * The data returned by the checkUpkeep simulation will be passed into
   * this method to actually be executed.
   * @dev The input to this method should not be trusted, and the caller of the
   * method should not even be restricted to any single registry. Anyone should
   * be able call it, and the input should be validated, there is no guarantee
   * that the data passed in is the performData returned from checkUpkeep. This
   * could happen due to malicious keepers, racing keepers, or simply a state
   * change while the performUpkeep transaction is waiting for confirmation.
   * Always validate the data passed in.
   * @param performData is the data which was passed back from the checkData
   * simulation. If it is encoded, it can easily be decoded into other types by
   * calling `abi.decode`. This data should not be trusted, and should be
   * validated against the contract's current state.
   */
  function performUpkeep(bytes calldata performData) external;
}

// File: contracts/chainlink/Logtrigger.sol


pragma solidity ^0.8.26;

// 'import' brings in code from the Chainlink contracts library.
// 'Log' is a data structure (struct) that holds event information.
// 'ILogAutomation' is an "interface" - a contract blueprint we must follow.


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