// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract FixedArrayExample {
    // Define a fixed-size array with 5 elements
    uint256[5] public fixedArray;

    // Function to set the values of the fixed-size array
    function setArray(
        uint256 _array1,
        uint256 _array2,
        uint256 _array3,
        uint256 _array4,
        uint256 _array5
    ) public {
        fixedArray[0] = _array1;
        fixedArray[1] = _array2;

        fixedArray[2] = _array3;
        fixedArray[3] = _array4;

        fixedArray[4] = _array5;
    }

    // Function to get a specific element from the fixed-size array
    function getElement(uint256 index) public view returns (uint256) {
        require(index < 5, "Index out of bounds"); // Check index bounds
        return fixedArray[index];
    }

    // Function to get the entire fixed-size array
    function getArray() public view returns (uint256[5] memory) {
        return fixedArray;
    }

    // Function to update a specific element in the fixed-size array
    function updateElement(uint256 index, uint256 value) public {
        require(index < 5, "Index out of bounds"); // Check index bounds
        fixedArray[index] = value;
    }
}
