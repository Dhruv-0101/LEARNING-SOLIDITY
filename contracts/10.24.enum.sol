// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OrderStatus {
    // Define an enum to represent the status of an order
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Cancelled
    }

    // Variable to store the current status of an order
    Status public currentStatus;

    // Function to set the status of the order
    function setStatus(Status _status) public {
        currentStatus = _status;
    }

    // Function to get the current status of the order as a string
    function getStatus() public view returns (string memory) {
        if (currentStatus == Status.Pending) return "Pending";
        if (currentStatus == Status.Shipped) return "Shipped";
        if (currentStatus == Status.Accepted) return "Accepted";
        if (currentStatus == Status.Rejected) return "Rejected";
        if (currentStatus == Status.Cancelled) return "Cancelled";
        return "Unknown";
    }
}
