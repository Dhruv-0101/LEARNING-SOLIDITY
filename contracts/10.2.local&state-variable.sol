// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Demo {
    //this is the place to write code
    int256 public counter = 10; //state variable

    function writeStateVariable() public {
        counter = 20; //writing the state variable
    }

    function readAndWriteStateVariable() public returns (int256) {
        counter = 100; //writing the state variable
        return counter; //reading the state variable
    }

    function readStateVariable() public returns (int256) {
        counter = 100; //writing the state variable
        return counter; //reading the state variable
    }

    function returnLocalVariable() public pure returns (bool) {
        bool value = true;
        return value;
    }

    function readStateVariableLocalVariable() public view returns (bool) {
        int256 localVar = counter;
        bool value = true;
        return value;
    }

    function writeStateVariableLocalVariable() public returns (bool) {
        counter = 20;
        bool value = true;
        return value;
    }
}
