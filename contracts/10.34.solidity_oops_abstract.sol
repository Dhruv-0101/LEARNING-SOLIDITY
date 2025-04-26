// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

abstract contract Parent {
    string public str;
    address public manager;

    constructor() {
        str = "Hello World";
        manager = msg.sender;
    }

    function setter(string memory _str) public virtual;
}

contract Child is Parent {
    uint256 public x;

    function setter(string memory _str) public override {
        str = _str;
    }
}
