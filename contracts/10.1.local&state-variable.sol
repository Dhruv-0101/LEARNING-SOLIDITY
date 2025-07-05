// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract demo {
    //fucntion ke andar bane woh local variabble and fucntion ke bahar contract scope me bane woh state variable
    uint256 public state_var; //state variable

    function setter() public {
        // we are writing to the state variable
        state_var = 2;
    }

    function getter() public view returns (uint256) {
        // reading from the state variable
        return state_var;
    }

    function pureFunction() public pure returns (uint256) {
        // neither reading nor writing on the state variable
        uint256 local_var; //local variable
        local_var = 1;
        return local_var;
    }

    //etherjs concept

    function setter1(uint256 _value) public {
        // Updating the state variable with the input value
        state_var = _value;
    }
}
