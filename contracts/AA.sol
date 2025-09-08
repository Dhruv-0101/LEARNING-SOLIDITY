// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    uint256 public count;

    function increment() public {
        count += 1;
    }

    function getCount() public view returns (uint256) {
        return count;
    }
}
//0xF37Bc74fD3816881eaA4FF74E3be9b587C975d01
//0x826c958a3D0201a255bd60b520F5de7b7aa4E7E3
