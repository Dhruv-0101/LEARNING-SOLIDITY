// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    int256 public num;

    function requireCheck(int256 a) public {
        num = 100;
        require(a > 0, "a is not greater than zero");
        num = a;
    }

    function conditionals(int256 b) public returns (string memory) {
        num = 200;
        if (b > 0) {
            num = b;
        } else {
            return "b is not greater than zero";
        }
    }
}
