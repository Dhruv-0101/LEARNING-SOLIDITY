// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentRecords {
    // Define a struct to represent a student
    struct Student {
        uint256 id;
        string name;
        uint256 age;
    }

    // Mapping to store student ID to Student struct
    mapping(uint256 => Student) private students;
         //    _id    onestruct        collections

    // Function to add or update a student
    function addOrUpdateStudent(
        uint256 _id,
        string memory _name,
        uint256 _age
    ) public {
        students[_id] = Student(_id, _name, _age);
    }

    // Function to get a student by ID
    function getStudent(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            uint256
        )
    {
        require(bytes(students[_id].name).length != 0, "Student not found");
        Student memory student = students[_id];
        return (student.id, student.name, student.age);
    }

    // Function to delete a student by ID
    function deleteStudent(uint256 _id) public {
        require(bytes(students[_id].name).length != 0, "Student not found");
        delete students[_id];
    }
}
