// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;
contract A {
    function callB(address _bAddress, address _cAddress) public payable {
        // A sends ETH to B via regular call, passing C's address
        (bool success, ) = _bAddress.call{value: msg.value}(
            abi.encodeWithSignature("delegateLog(address)", _cAddress)
        );
        require(success, "call to B failed");
    }
}

contract B {
    address public sender;
    uint public value;

    function delegateLog(address _cAddress) public payable {
        sender = msg.sender;  // msg.sender = A's address (B is the caller of C via delegatecall)
        value = msg.value;    // msg.value = ETH sent by A
        bytes memory data = abi.encodeWithSignature("log()");
        (bool success, ) = _cAddress.delegatecall(data); // B delegates to C
        require(success, "delegatecall failed");
    }
}

contract C {
    address public sender;
    uint public value;

    function log() public payable {
        sender = msg.sender; // = A's address (NOT B's!) — preserved through delegatecall
        value = msg.value;   // = Ether originally sent by A — also preserved
        // These are stored in B's storage, not C's!
    }
}

// Summary:
// When B does delegatecall → C:
//   • C's code runs in B's storage context
//   • msg.sender inside C = A's address (the original caller of B)
//   • msg.value inside C = ETH originally sent to B by A
//   • C's own state variables are NOT affected
/*
// Summary:
//
// Call Flow:
//   • External user (EOA) calls A.callB()
//   • Contract A calls B.delegateLog() using .call and forwards ETH
//   • Contract B then uses delegatecall to execute C.log()
//
// Behavior during delegatecall (B → C):
//
//   • C.log() ka code execute hota hai, BUT storage B ka use hota hai
//
//   • msg.sender inside B.delegateLog() = address of contract A
//   • msg.sender inside C.log() = SAME as in B → address of contract A
//
//   • msg.value inside B = ETH sent by EOA via A
//   • msg.value inside C = SAME ETH (delegatecall preserves it)
//
//   • State changes in C.log() are applied to B's storage
//     (i.e., B.sender and B.value get updated, NOT C.sender and C.value)
//
// Final Result:
//
//   • B.sender = address of A
//   • B.value = msg.value
//
//   • C's storage remains unchanged
*/