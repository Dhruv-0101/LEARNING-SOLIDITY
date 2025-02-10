
// 1️⃣ Stack 🗄️ (Temporary & Fast)
// Location: CPU-like register inside the EVM.
// Lifetime: Only exists while a function is executing.
// Access: LIFO (Last In, First Out) structure.
// Size Limit: 1024 slots, each 32 bytes (256 bits).
// Gas Cost: Very cheap (almost free).
// Use Cases:
// Storing temporary variables.
// Function arguments & return values.
// Opcode calculations (e.g., ADD, MUL).

// function addNumbers(uint256 a, uint256 b) public pure returns (uint256) {
//     return a + b; // Uses the stack
// }
//🔹 Here, a and b are stored in the stack because they are temporary and disappear after function execution.



// 2️⃣ Memory 🧠 (Temporary & Resizable)
// Location: Off-stack volatile storage (RAM-like).
// Lifetime: Exists only during function execution.
// Access: Random access, unlike the stack.
// Size Limit: No strict limit, but expands dynamically in 32-byte chunks.
// Gas Cost:
// Cheap for small sizes, but gets expensive as it grows.
// Expanding memory doubles the cost every 32 bytes.
// Use Cases:
// Storing temporary dynamic data (e.g., arrays, structs).
// Handling function parameters and return data.
// Solidity’s abi.encode and abi.encodePacked.

// function storeInMemory() public pure returns (uint256[] memory) {
//     uint256; // Stored in memory
//     tempArray[0] = 10;
//     return tempArray; // Disappears after function execution
// }
// 🔹 tempArray is stored in memory, so it gets deleted once the function ends.



// 3️⃣ Storage 📦 (Persistent & Expensive)
// Location: Ethereum blockchain (permanent storage).
// Lifetime: Persists across transactions & contract calls.
// Access: Slow (compared to stack & memory).
// Size Limit: No hard limit, but modifying storage is VERY expensive.
// Gas Cost:
// Writing: 20,000 gas per slot (very expensive).
// Reading: 800 gas per slot (cheaper but still costly).
// Use Cases:
// Storing contract state variables.
// Data that must persist across function calls.

// contract Example {
//     uint256 public storedNumber; // Stored in storage

//     function updateNumber(uint256 _num) public {
//         storedNumber = _num; // Writing to storage (expensive)
//     }
// }

// storedNumber is stored in storage, meaning it remains even after the function ends and across transactions.


// Best Practices 🚀
// ✔️ Use stack for temporary small variables.
// ✔️ Use memory for dynamic arrays, structs, and function variables.
// ✔️ Use storage ONLY when necessary (because it costs gas).
//stack and memory both till fucntion execution



// contract Token {
//     mapping(address => uint256) public balances; // Storage (permanent)

//     function setBalance(uint256 _amount) public {
//         balances[msg.sender] = _amount; // Storage write (expensive)
//     }

//     function tempCalculation() public pure returns (uint256) {
//         uint256 a = 10; // Stack (cheap)
//         uint256; // Memory (temporary)
//         tempArray[0] = a * 2;
//         return tempArray[0]; // Disappears after execution
//     }
// }

// 🔹 balances[msg.sender] is in storage because it needs to persist.
// 🔹 a is stored in the stack because it’s temporary.
// 🔹 tempArray is in memory because it’s temporary but dynamic.