// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NameToAddressMapping {
    // Mapping from string (name) to address
    mapping(string => address) private nameToAddress;

    // Function to set an address for a given name
    function setAddress(string memory _name, address _address) public {
        nameToAddress[_name] = _address;
    }

    // Function to get the address associated with a given name
    function getAddress(string memory _name) public view returns (address) {
        require(nameToAddress[_name] != address(0), "Address not found");
        return nameToAddress[_name];
    }

    // Function to delete the address associated with a given name
    function deleteAddress(string memory _name) public {
        require(nameToAddress[_name] != address(0), "Address not found");
        delete nameToAddress[_name];
    }
}

