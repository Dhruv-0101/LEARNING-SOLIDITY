// pragma solidity ^0.8.19;

// import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

// contract Counter is KeeperCompatibleInterface {
//     uint256 public immutable i_updateInterval;
//     uint256 public lastTimeStamp;
//     uint256 public counter;

//     // --- DEPLOYMENT ---
//     // 1. You deploy the contract with an interval of 3600 seconds (1 hour).
//     // Assume the deployment happens at timestamp: 1724164200 (Aug 20, 2025, 6:40:00 PM IST)
//     constructor(uint256 updateInterval) {
//         i_updateInterval = updateInterval; // i_updateInterval is set to 3600
//         lastTimeStamp = block.timestamp; // lastTimeStamp is set to 1724164200
//         counter = 0; // counter starts at 0
//     }

//     // --- WAITING PERIOD ---
//     // Chainlink Automation nodes continuously call this function off-chain (for free).
//     function checkUpkeep(
//         bytes calldata /* checkData */
//     )
//         external
//         view
//         override
//         returns (bool upkeepNeeded, bytes memory performData)
//     {
//         // 2. An hour has NOT passed yet.
//         // Let's say current time is 7:10 PM (timestamp: 1724166000)
//         // (1724166000 - 1724164200) is 1800.
//         // 1800 is NOT > 3600.
//         // So, upkeepNeeded returns `false`. Nothing happens.

//         // 3. An hour HAS passed.
//         // Let's say current time is 7:41 PM (timestamp: 1724167860)
//         // (1724167860 - 1724164200) is 3660.
//         // 3660 IS > 3600.
//         // So, upkeepNeeded returns `true`. This signals a node to take action.
//         upkeepNeeded = (block.timestamp - lastTimeStamp) > i_updateInterval;
//         performData = "";
//     }

//     // --- EXECUTION ---
//     // 4. Because checkUpkeep returned true, a Chainlink Automation node calls this function.
//     // This is an on-chain transaction that you pay for with LINK tokens.
//     function performUpkeep(
//         bytes calldata /* performData */
//     ) external override {
//         // The condition is checked again to ensure it's still valid.
//         // (current block.timestamp - 1724164200) is still > 3600.
//         if ((block.timestamp - lastTimeStamp) > i_updateInterval) {
//             // The logic inside the `if` statement executes:
//             lastTimeStamp = block.timestamp; // lastTimeStamp is updated to ~1724167860
//             counter = counter + 1; // counter becomes 1
//         }
//         // The process now repeats. The contract will wait for another hour to pass
//         // from the new `lastTimeStamp` before checkUpkeep returns true again.
//     }
// }
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";

contract CustomLogic is AutomationCompatibleInterface {
    uint256 public immutable i_updateInterval;
    uint256 public lastTimeStamp;
    uint256 public counter;

    // --- 1. DEPLOYMENT ---
    // You deploy the contract with an interval of 60 seconds.
    // Let's assume deployment happens at timestamp: 1755796560
    // (This corresponds to Aug 20, 2025, 6:46:00 PM IST)
    constructor(uint256 updateInterval) {
        i_updateInterval = updateInterval; // i_updateInterval is set to 60
        lastTimeStamp = block.timestamp;   // lastTimeStamp is set to 1755796560
        counter = 0;                       // counter starts at 0
    }

    // --- 2. CHECKING PERIOD (Off-Chain) ---
    // Chainlink Automation nodes call this function continuously for free to see if work needs to be done.
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        // SCENARIO A: 30 seconds have passed. Current time is 6:46:30 PM (Timestamp: 1755796590)
        // Math: (1755796590 - 1755796560) is 30.
        // 30 is NOT > 60.
        // RESULT: upkeepNeeded returns `false`. Nothing happens. ✅

        // SCENARIO B: 65 seconds have passed. Current time is 6:47:05 PM (Timestamp: 1755796625)
        // Math: (1755796625 - 1755796560) is 65.
        // 65 IS > 60.
        // RESULT: upkeepNeeded returns `true`. This tells the network to execute performUpkeep. ⚙️
        upkeepNeeded = (block.timestamp - lastTimeStamp) > i_updateInterval;
        performData = "";
    }

    // --- 3. EXECUTION (On-Chain) ---
    // Because checkUpkeep returned `true`, a Chainlink node sends a transaction to run this function.
    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        // The condition is checked again on-chain to ensure it's still valid.
        if ((block.timestamp - lastTimeStamp) > i_updateInterval) {
            // The logic inside the `if` statement now runs:
            lastTimeStamp = block.timestamp; // lastTimeStamp is updated to the new time (~1755796625)
            counter = counter + 1;           // counter becomes 1
        }
        // The automation cycle now restarts. It will wait for another 60 seconds to pass
        // from the new `lastTimeStamp` before checkUpkeep returns true again.
    }
}