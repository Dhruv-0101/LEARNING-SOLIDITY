// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NestedMappingExample {
    // Nested mapping: Mapping from uint => (Mapping from address => bool)
    mapping(uint => mapping(address => bool)) public permissions;
           //row           column      value

    // Function to set permission
    function setPermission(uint roleId, address user, bool status) public {
        permissions[roleId][user] = status;
    }

    // Function to check if a user has a certain role
    function hasPermission(uint roleId, address user) public view returns (bool) {
        return permissions[roleId][user];
    }
}
