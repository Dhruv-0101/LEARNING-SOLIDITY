// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract parentcontract {
    uint256 public num = 100;
    address public add1 = msg.sender;

    function funA() public pure returns (string memory) {
        return "function A";
    }

    function funB() public pure returns (string memory) {
        return "function B";
    }

    function funC() public pure virtual returns (string memory) {
        return "function C";
    }

    function funD() public pure returns (string memory) {
        return "function D";
    }
}

contract childcontract is parentcontract {
    uint256 public num1 = 50;

    // address public add1 = msg.sender;
    // function funA() public pure returns (string memory) {
    //     return "function A";
    // }
    // function funB() public pure returns (string memory) {
    //     return "function B";
    // }
    function funC() public pure override returns (string memory) {
        return "function call for checking virtial";
    }
    // function funD() public pure returns (string memory) {
    //     return "function D";
}
