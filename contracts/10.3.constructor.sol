// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Student {
    string public name;
    uint256 public age;
    uint256 public id;

    // Constructor to initialize the contract with a student's details
    constructor(
        string memory _name,
        uint256 _age,
        uint256 _id
    ) {
        name = _name;
        age = _age;
        id = _id;
    }

    // Function to update the student's details
    function updateDetails(
        string memory _name,
        uint256 _age,
        uint256 _id
    ) public {
        name = _name;
        age = _age;
        id = _id;
    }

    // Function to get the student's details
    function getDetails()
        public
        view
        returns (
            string memory,
            uint256,
            uint256
        )
    {
        return (name, age, id);
    }
}
