// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Library {
    // Define a struct to represent a book
    struct Book {
        uint256 id;
        string title;
        string author;
    }

    // Array to store books
    Book[] public books;

    // Mapping to store book ID to array index
    mapping(uint256 => uint256) public bookIdToIndex;

    // Function to add a new book
    function addBook(
        uint256 _id,
        string memory _title,
        string memory _author
    ) public {
        // Create a new book struct and add it to the array
        books.push(Book(_id, _title, _author));
        // Update the mapping with the new book's index
        bookIdToIndex[_id] = books.length - 1;
    }

    // Function to get a book by index
    function getBookByIndex(uint256 _index)
        public
        view
        returns (
            uint256,
            string memory,
            string memory
        )
    {
        require(_index < books.length, "Index out of bounds");
        Book memory book = books[_index];
        return (book.id, book.title, book.author);
    }

    // Function to get a book by ID
    function getBookById(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            string memory
        )
    {
        uint256 index = bookIdToIndex[_id];
        require(index < books.length, "Book not found");
        Book memory book = books[index];
        return (book.id, book.title, book.author);
    }
}
