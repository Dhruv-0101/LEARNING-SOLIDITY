// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Example {
    // Modifier to check if a value is within a specified range
    modifier valueInRange(
        uint256 _value,
        uint256 _min,
        uint256 _max
    ) {
        require(_value >= _min && _value <= _max, "Value out of range");
        _;
    }

    // Function that uses the valueInRange modifier
    function doSomething(uint256 _value)
        public
        pure
        valueInRange(_value, 10, 100)
        returns (string memory)
    {
        return "good";
    }
}
