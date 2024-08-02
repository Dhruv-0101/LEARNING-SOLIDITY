// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentManagement {
    // Define a struct to represent a student
    struct Student {
        uint256 id;
        string name;
        uint256 age;
    }

    // Array to store students
    Student[] public students;

    // Mapping to store student ID to array index
    mapping(uint256 => uint256) public studentIdToIndex;

    // Function to add a new student
    function addStudent(
        uint256 _id,
        string memory _name,
        uint256 _age
    ) public {
        // Create a new student struct and add it to the array
        students.push(Student(_id, _name, _age));
        // Update the mapping with the new student's index
        studentIdToIndex[_id] = students.length - 1;
    }

    // Function to get a student by index
    function getStudentByIndex(uint256 _index)
        public
        view
        returns (
            uint256,
            string memory,
            uint256
        )
    {
        require(_index < students.length, "Index out of bounds");
        Student memory student = students[_index];
        return (student.id, student.name, student.age);
    }

    // Function to get a student by ID
    function getStudentById(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            uint256
        )
    {
        uint256 index = studentIdToIndex[_id];
        require(index < students.length, "Student not found");
        Student memory student = students[index];
        return (student.id, student.name, student.age);
    }

    // Function to update a student's details by ID
    function updateStudent(
        uint256 _id,
        string memory _name,
        uint256 _age
    ) public {
        uint256 index = studentIdToIndex[_id];
        require(index < students.length, "Student not found");
        Student storage student = students[index];
        student.name = _name;
        student.age = _age;
    }

    // Function to remove a student by ID
    function removeStudent(uint256 _id) public {
        uint256 index = studentIdToIndex[_id];
        require(index < students.length, "Student not found");

        // Move the last student to the place of the one to be removed
        students[index] = students[students.length - 1];
        // Update the index mapping
        studentIdToIndex[students[index].id] = index;

        // Remove the last student
        students.pop();
        // Remove the index mapping
        delete studentIdToIndex[_id];
    }
}
