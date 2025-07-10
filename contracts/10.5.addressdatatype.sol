// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract AddressExample {
    address public owner; // State variable to store the address of the contract owner
    address public recipient; // State variable to store the recipient address

    // Constructor to initialize the contract with the owner's address
    constructor() {
        owner = msg.sender; // Set the owner to the address that deploys the contract
    }

    // Function to set the recipient's address
    function setRecipient(address _recipient) public {
        recipient = _recipient;
    }

    // Function to send Ether from the contract to the recipient
    function sendEther(uint256 amount) public payable {
        require(msg.sender == owner, "Only the owner can send Ether");
        require(address(this).balance >= amount, "Insufficient balance");

        payable(recipient).transfer(amount);
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {
        // Accepts Ether deposits
    }

    // Function to get the balance of the contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // Function to get the balance of a specific address
    function getAddressBalance(address _addr) public view returns (uint256) {
        return _addr.balance;
    }
}

// pragma solidity >=0.8.2 <0.9.0;

// contract SimpleAddressExample {
//     address public owner; // State variable to store the address of the contract owner
//     address public otherAddress; // State variable to store another address

//     // Constructor to initialize the contract with the owner's address
//     constructor() {
//         owner = msg.sender; // Set the owner to the address that deploys the contract
//     }

//     // Function to set another address
//     function setOtherAddress(address _otherAddress) public {
//         otherAddress = _otherAddress;
//     }

//     // Function to get the owner's address
//     function getOwner() public view returns (address) {
//         return owner;
//     }

//     // Function to get the other address
//     function getOtherAddress() public view returns (address) {
//         return otherAddress;
//     }
// }
