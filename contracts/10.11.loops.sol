// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoopExamples {
    // For loop example
    function forLoopExample(uint256 n) public pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i <= n; i++) {
            sum = sum + i;
        }
        return sum;
    }

    // While loop example
    function whileLoopExample(uint256 n) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        while (i <= n) {
            sum += i;
            i++;
        }
        return sum;
    }

    // Do-while loop example
    function doWhileLoopExample(uint256 n) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        if (n > 0) {
            // Ensuring the do-while loop runs at least once if n is greater than 0
            do {
                sum = sum + i;
                i = i + 1;
            } while (i <= n);
        }
        return sum;
    }
}
