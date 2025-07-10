// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Book {
    uint256 length;
    uint256 breadth;
    uint256 height;

    function setDimension(
        uint256 _length,
        uint256 _breadth,
        uint256 _height
    ) public {
        length = _length;
        breadth = _breadth;
        height = _height;
    }

    function getDimension()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return (length, breadth, height);
    }
}

contract D {
    Book obj = new Book();

    function getInstance() public view returns (Book) {
        return obj;
    }

    function writeDimension(
        uint256 _length,
        uint256 _breadth,
        uint256 _height
    ) public {
        obj.setDimension(_length, _breadth, _height);
    }

    function readDimension()
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        return obj.getDimension();
    }
}
/*
🔹 Your Code Summary (with Real-Life Analogy):
Book contract = A bag 📦 that stores dimensions.

D contract = A person 👤 who uses a bag.

🔸 What Happens:
Book obj = new Book();
👉 D creates a new private bag (new Book contract).

writeDimension(...)
👉 D puts items in its own bag.

readDimension()
👉 D looks inside its own bag.

getInstance()
👉 D tells you where the bag is (its address).

🔹 Key Point:
✅ All changes happen in the new bag created inside D,
not in any external or main Book contract.


*/