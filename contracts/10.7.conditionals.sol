// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    function Conditionals(int256 a) public pure returns (int256) {
        if (a > 0) {
            return a;
        } else if (a < 0) {
            return -1;
        } else {
            return 1;
        }
    }
}
