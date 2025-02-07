// 1. Stack (Temporary Execution Space)
// -->The Stack is the fastest but most limited storage location.
// -->It is used for small computations and local function variables.
// -->Solidity functions use the stack to store temporary values during execution.
// -->It has a strict size limit (1024 slots), so only small values (like uint, bool, address) are stored here.
// -->It is automatically cleared when the function execution ends.
// -->No gas cost, as it directly uses CPU registers.


// 2. Memory (Temporary, Used Inside Functions)
// -->Memory is similar to RAM and is used to store temporary variables like arrays, structs, and strings inside a function.
// --> Data in memory exists only during function execution and is cleared afterward.
// -->Moderate gas cost—reading is cheap, but writing consumes gas.
// -->Used when dealing with dynamic data types (arrays, structs, mappings, strings).


// 3. Storage (Permanent, Contract-Level Data)
// -->Storage is the most important type of memory in Solidity.
// -->It stores contract state variables that persist on the blockchain.
// -->Expensive gas cost—modifying storage variables is costly since it changes the blockchain state.
// -->Unlike stack and memory, storage remains even after function execution and transactions.
// -->Used for permanent contract state data, such as mappings and large arrays.