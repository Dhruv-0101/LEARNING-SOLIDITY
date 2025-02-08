// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external;
}

contract Token is IERC20 {
    event Transfer(address recipient, uint256 amount);

    function transfer(address _recipient, uint256 _amount) external override {
        emit Transfer(_recipient, _amount);
    }
}

contract AbiEncode {
    function callTokenContractFunction(address _contract, bytes calldata data)
        external
    {
        (bool ok, ) = _contract.call(data);
        require(ok, "transaction failed");
        // Optionally handle returnedData if needed
    }

    function encodeWithSignature(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSignature("transfer(address,uint256)", to, amount);
    }

    function encodeWithSelector(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeWithSelector(IERC20.transfer.selector, to, amount);
    }

    function encodeCall(address to, uint256 amount)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodeCall(IERC20.transfer, (to, amount));
    }
}


// 🚀 Purpose of the Contract
// The contract AbiEncode provides functions to:

// Encode function calls in different ways (encodeWithSignature, encodeWithSelector, encodeCall).
// Send encoded data to another contract (callTokenContractFunction).
// This is useful when interacting with external contracts dynamically without directly importing their interfaces.