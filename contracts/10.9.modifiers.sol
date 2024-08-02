// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    modifier onlytrue() {
        require(false == true, "_a is not equal to true");
        _;
    }

    function check1() public pure onlytrue returns (uint256) {
        return 1;
    }

    function check2() public pure onlytrue returns (uint256) {
        return 1;
    }

    function check3() public pure onlytrue returns (uint256) {
        return 1;
    }
}
