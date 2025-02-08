// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CalledContract {//painter
    uint256 public someNumber;

    function setNumber(uint256 _num) public {
        someNumber = _num;
    }
}

contract Caller {//owner
    uint256 public someNumber; // Note that this is the same variable name as in the Called Contract

    function setNumber(address _calledContractAddress, uint256 _num) public {
        // Prepare the data to call setNumber(uint) on the Called contract
        bytes memory data = abi.encodeWithSignature("setNumber(uint256)", _num);

        // Perform the delegatecall
        (bool success, ) = _calledContractAddress.delegatecall(data);
        require(success, "Delegatecall failed");
    }
}
//painter ne kya kiya --- mere resources se mere hi ghar me kam kiya.yani ki mera storage or mere me hi changes
