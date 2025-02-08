// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalledContract { //painter
    uint256 public someNumber;

    // Function to set the value of someNumber
    function setNumber(uint256 _num) public {
        someNumber = _num;
    }
}

contract Caller { //owner
    uint256 public someNumber; // Note that this is the same variable name as in the Called Contract

    // Function to call setNumber on another contract
    function setNumber(address _calledContractAddress, uint256 _num) public {
        // Prepare the data to call setNumber(uint) on the Called contract
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", _num);

        // Perform the call
        (bool success, ) = _calledContractAddress.call(data);

        // Check if the call was successful
        require(success, "call failed");
    }
}
