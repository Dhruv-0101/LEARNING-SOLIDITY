// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract demo {
    function f1() public pure returns (uint256) {
        // f2();
        return 1;
    }

    function f2() private pure returns (uint256) {
        // f4();
        return 2;
    }

    function f3() internal pure returns (uint256) {
        return 3;
    }

    function f4() external pure returns (uint256) {
        return 4;
    }
}

contract otherContract {
    demo obj = new demo(); //creating object
    uint256 public y = obj.f4();
}

contract child is demo {
    uint256 public x = f1();
}
