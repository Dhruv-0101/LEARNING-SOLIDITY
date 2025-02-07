// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Classroom {
    struct Student {
        string name;
        uint256 roll;
        bool pass;
    }

    Student public s1;

    function insert() public returns (Student memory) {
        s1.name = "dhruv";
        s1.roll = 12;
        s1.pass = true;
        return s1;
    }
}

// contract Classroom {
//     struct Student {
//         string name;
//         uint roll;
//         bool pass;
//     }

//     Student public s1;

//     function insert() public returns (Student memory) {
//         s1 = Student("Kshitij", 12, true);
//         return s1;
//     }
// }

