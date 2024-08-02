// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract StringExample {
    // State variable to store a string
    string public myString;

    // Function to set a new string
    function setString(string memory newString) public {
        myString = newString;
    }

    // Function to get the current string (optional, since we have a public variable)
    function getString() public view returns (string memory) {
        return myString;
    }
}
