// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TransferExample {
    function transferEther(address payable recipient) public payable {
        require(
            address(this).balance >= 1 ether,
            "Insufficient contract balance"
        );
        recipient.transfer(1 ether);
    }

    function sendEther(address payable recipient)
        public
        payable
        returns (bool)
    {
        require(
            address(this).balance >= 1 ether,
            "Insufficient contract balance"
        );
        bool sent = recipient.send(1 ether);
        return sent;
    }

    function callEther(address payable recipient)
        public
        payable
        returns (bool, bytes memory)
    {
        require(
            address(this).balance >= 1 ether,
            "Insufficient contract balance"
        );
        (bool success, bytes memory data) = recipient.call{value: 1 ether}("");
        return (success, data);
    }

    // Allow contract to receive Ether
    // receive() external payable {}
}

/*
Difference Between transfer, send, and call
transfer

Gas Limit: 2300 gas
Returns Boolean? ❌ No
Revert on Failure? ✅ Yes (reverts if fails)
Security Risk: ✅ Safe (prevents reentrancy)
send

Gas Limit: 2300 gas
Returns Boolean? ✅ Yes (returns false on failure)
Revert on Failure? ❌ No
Security Risk: ❌ Less secure (must check return value manually)
call

Gas Limit: No limit (all available gas)
Returns Boolean? ✅ Yes (returns success & data)
Revert on Failure? ❌ No
Security Risk: ⚠️ High risk (prone to reentrancy attacks)
*/
