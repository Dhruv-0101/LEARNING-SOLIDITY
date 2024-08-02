// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FixedSizeArray {
    // Declare a fixed-size array of uint with length 5
    uint256[5] public fixedArray; //storage

    // Function to get the length of the fixed-size array
    function getLength() public view returns (uint256) {
        return fixedArray.length;
    }

    function insertElement(uint256 _element, uint256 _index) external {
        fixedArray[_index] = _element;
    }

    function getElement(uint256 _index) external view returns (uint256) {
        return fixedArray[_index];
    }

    function getArray() external view returns (uint256[5] memory) {
        return fixedArray;
    }
}
//     // Function to update an element in the fixed-size array
//     function updateElement(uint index, uint value) public {
//         require(index < fixedArray.length, "Index out of bounds");
//         fixedArray[index] = value;
//     }
// }
