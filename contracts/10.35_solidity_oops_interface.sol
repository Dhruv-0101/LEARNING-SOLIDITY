// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

// Define the interface
interface IGreeter {
    function greet() external view returns (string memory);
}

// Implement the interface in a contract
contract Greeter is IGreeter {
    function greet() external pure override returns (string memory) {
        return "Hello, world!";
    }
}

contract Greet is IGreeter {
    function greet() external pure override returns (string memory) {
        return "Hello!";
    }
}

// A contract that interacts with the Greeter contract through the interface
contract GreeterUser {
    function getGreeting(address _greeter)
        external
        view
        returns (string memory)
    {
        return IGreeter(_greeter).greet();
    }
}
