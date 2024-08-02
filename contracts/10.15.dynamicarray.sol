// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract DynamicArrayExample {
    // Define a dynamic array of uint256
    uint256[] public dynamicArray;

    // Function to add an element to the end of the dynamic array
    function addElement(uint256 _element) public {
        dynamicArray.push(_element);
    }

    // Function to get the length of the dynamic array
    function getArrayLength() public view returns (uint256) {
        return dynamicArray.length;
    }

    // Function to get a specific element from the dynamic array
    function getElement(uint256 _index) public view returns (uint256) {
        require(_index < dynamicArray.length, "Index out of bounds");
        return dynamicArray[_index];
    }

    // Function to remove the last element from the dynamic array
    function removeLastElement() public {
        require(dynamicArray.length > 0, "Array is empty");
        dynamicArray.pop();
    }

    // Function to update an element at a specific index in the dynamic array
    function updateElement(uint256 _index, uint256 _value) public {
        require(_index < dynamicArray.length, "Index out of bounds");
        dynamicArray[_index] = _value;
    }

    // Function to remove an element at a specific index (by shifting)
    function removeElementAt(uint256 _index) public {
        require(_index < dynamicArray.length, "Index out of bounds");
        for (uint256 i = _index; i < dynamicArray.length - 1; i++) {
            dynamicArray[i] = dynamicArray[i + 1];
        }
        dynamicArray.pop(); // Remove the last duplicate element
    }

    // Function to get the entire dynamic array
    function getArray() public view returns (uint256[] memory) {
        return dynamicArray;
    }
}
