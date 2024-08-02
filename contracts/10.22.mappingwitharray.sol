// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AddressToArrayMapping {
    // Mapping from an address to an array of uint256 values
    mapping(address => uint256[]) private addressToValues;

    // Function to add a value to the array for a given address
    function addValue(address _address, uint256 _value) public {
        addressToValues[_address].push(_value);
    }

    // Function to get the array of values for a given address
    function getValues(address _address)
        public
        view
        returns (uint256[] memory)
    {
        return addressToValues[_address];
    }

    // Function to remove a value at a specific index for a given address
    function removeValueAt(address _address, uint256 _index) public {
        require(
            _index < addressToValues[_address].length,
            "Index out of bounds"
        );

        // Shift elements to the left to overwrite the value at _index
        for (
            uint256 i = _index;
            i < addressToValues[_address].length - 1;
            i++
        ) {
            addressToValues[_address][i] = addressToValues[_address][i + 1];
        }

        // Remove the last element
        addressToValues[_address].pop();
    }
}
