// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EventVault {
    event Deposit(
        address indexed user,
        uint256 indexed amount,
        uint256 timestamp
    );

    event Withdraw(
        address indexed user,
        uint256 indexed amount,
        uint256 timestamp
    );

    event MessagePosted(
        address indexed user,
        string message,
        uint256 timestamp
    );

    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount, block.timestamp);
    }

    function postMessage(string calldata message) external {
        emit MessagePosted(msg.sender, message, block.timestamp);
    }
}
//0x162Ab8aFF3Fcb10c271451ce32cc1bB323cF91CA