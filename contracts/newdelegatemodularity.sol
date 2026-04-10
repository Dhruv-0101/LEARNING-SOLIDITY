// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
===========================================
🧠 DELEGATECALL MODULARITY - FULL EXPLANATION
===========================================

🎯 Goal:
Ek Main contract hai jo multiple modules (A, B, C) ka logic use karta hai
using delegatecall — bina apni storage lose kiye.

-------------------------------------------
🔥 CORE IDEA:
-------------------------------------------
delegatecall me:

    code     → Module contract ka run hota hai
    storage  → Main contract ka use hota hai
    msg.sender → preserve hota hai
    msg.value  → preserve hota hai

-------------------------------------------
📌 CALL FLOW:
-------------------------------------------

EOA (user)
   ↓
calls Main.deposit()
   ↓
Main.delegatecall(ModuleA.deposit)
   ↓
ModuleA ka code run hota hai
BUT storage Main ka update hota hai

-------------------------------------------
💥 RESULT:
-------------------------------------------
Main.balance update hota hai
ModuleA.balance unchanged rehta hai

-------------------------------------------
⚠️ IMPORTANT:
-------------------------------------------
Storage layout SAME hona chahiye

Example:
Main.balance  ↔ ModuleA.balance
Main.name     ↔ ModuleB.name
Main.owner    ↔ ModuleC.owner

-------------------------------------------
🔥 REMIX TEST STEPS:
-------------------------------------------

1. Deploy ModuleA, ModuleB, ModuleC
2. Deploy Main
3. Call:
   Main.deposit(moduleA_address) with VALUE = 1 ether
4. Check:
   Main.balance → updated
   ModuleA.balance → 0

===========================================
*/


contract Main {

    /*
    ===========================================
    🧠 SHARED STORAGE (VERY IMPORTANT)
    ===========================================

    Ye variables sab modules ke saath match hone chahiye

    ModuleA.balance ↔ Main.balance
    ModuleB.name    ↔ Main.name
    ModuleC.owner   ↔ Main.owner
    */

    address public owner;
    uint public balance;
    string public name;

    constructor() {
        owner = msg.sender;
    }

    /*
    ===========================================
    🔥 GENERIC DELEGATECALL FUNCTION
    ===========================================

    Ye low-level function hai jo kisi bhi module ko call kar sakta hai
    with custom calldata

    module = jis contract ka code chalana hai
    data   = encoded function call

    Example:
    deposit() → 0xd0e30db0
    */
    function execute(address module, bytes calldata data) external payable {
        (bool success, ) = module.delegatecall(data);
        require(success, "delegatecall failed");
    }


    /*
    ===========================================
    🔥 HELPER FUNCTION: DEPOSIT
    ===========================================

    Ye internally encode karta hai:
    "deposit()" function call

    User ko manually calldata dene ki zarurat nahi

    IMPORTANT:
    msg.value Main me aata hai (NOT ModuleA me)
    but ModuleA ka code run hota hai
    */
    function deposit(address moduleA) external payable {
        bytes memory data = abi.encodeWithSignature("deposit()");
        (bool success, ) = moduleA.delegatecall(data);
        require(success, "deposit failed");
    }


    /*
    ===========================================
    🔥 HELPER FUNCTION: SET NAME
    ===========================================

    encode karta hai:
    setName(string)

    ModuleB ka code run karega
    but Main.name update hoga
    */
    function setName(address moduleB, string memory _name) external {
        bytes memory data = abi.encodeWithSignature("setName(string)", _name);
        (bool success, ) = moduleB.delegatecall(data);
        require(success, "setName failed");
    }


    /*
    ===========================================
    🔥 HELPER FUNCTION: CHANGE OWNER
    ===========================================

    ModuleC ka code run karega
    but Main.owner update hoga
    */
    function changeOwner(address moduleC, address _new) external {
        bytes memory data = abi.encodeWithSignature("changeOwner(address)", _new);
        (bool success, ) = moduleC.delegatecall(data);
        require(success, "changeOwner failed");
    }


    /*
    ===========================================
    🔥 RECEIVE FUNCTION
    ===========================================

    ETH receive karne ke liye zaruri hai

    NOTE:
    delegatecall ETH transfer nahi karta
    ETH always Main contract me hi rehta hai
    */
    receive() external payable {}
}


/*
===========================================
🧩 MODULE A → BALANCE LOGIC
===========================================

IMPORTANT:
Ye contract ka storage use nahi hoga
Sirf code use hoga

balance variable Main ke balance ko represent karega
*/
contract ModuleA {
    uint public balance;

    function deposit() public payable {
        balance += msg.value;

        /*
        Yaha actually update ho raha hai:
        Main.balance

        NOT:
        ModuleA.balance
        */
    }
}


/*
===========================================
🧩 MODULE B → NAME LOGIC
===========================================
*/
contract ModuleB {
    string public name;

    function setName(string memory _name) public {
        name = _name;

        /*
        Actually update:
        Main.name

        NOT:
        ModuleB.name
        */
    }
}


/*
===========================================
🧩 MODULE C → OWNER LOGIC
===========================================
*/
contract ModuleC {
    address public owner;

    function changeOwner(address _new) public {
        owner = _new;

        /*
        Actually update:
        Main.owner

        NOT:
        ModuleC.owner
        */
    }
}