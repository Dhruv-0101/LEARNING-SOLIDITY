// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
====================================================
STATE VARIABLE SHADOWING – FULL COMMENTED EXAMPLE
====================================================

SHADOWING ka matlab:
----------------------------------
Child contract me SAME NAAM ka variable banana
jo parent contract ke variable ko "hide" kar de.

⚠️ Solidity 0.6+ me:
- State variable shadowing DISALLOWED hai
- Compiler error aata hai
*/


// ========================================
// 🅰️ PARENT CONTRACT
// ========================================
contract A {

    /*
    State variable declared in parent
    */
    string public name = "Contract A";

    function getName() public view returns (string memory) {
        return name;
    }
}



// ========================================
// ❌ WRONG WAY (SHADOWING) – NOT ALLOWED
// ========================================
/*
contract B is A {

    ❌ NOT ALLOWED:
    Ye parent ka `name` variable shadow kar raha hai

    Compiler error:
    "Identifier already declared"
    
    string public name = "Contract B";
}
*/



// ========================================
// ✅ CORRECT WAY – MODIFY INHERITED VARIABLE
// ========================================
contract C is A {

    /*
    ✔️ Parent ka variable reuse karo
    ✔️ Naya variable declare mat karo
    */

    constructor() {
        name = "Contract C";  // parent variable overwrite
    }

    /*
    getName() inherited from A

    C.getName() → "Contract C"
    */
}
