// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
====================================================
ERROR HANDLING IN SOLIDITY – FULL COMMENTED VERSION
====================================================

Solidity me 4 main error-handling tools hote hain:

1️⃣ require()        → user input / condition check
2️⃣ revert()         → manually error throw karna
3️⃣ custom errors    → gas efficient errors
4️⃣ assert()         → internal invariant check (never fail hona chahiye)

Rule of thumb:
- User ki galti → require / revert / custom error
- Developer bug → assert
*/

contract ErrorHandlingExample {

    // ------------------------------------------------
    // STATE VARIABLES
    // ------------------------------------------------

    address public owner;     // Contract deploy karne wala
    uint256 public balance;   // Simple balance tracking


    // ------------------------------------------------
    // CUSTOM ERRORS (Gas Efficient)
    // ------------------------------------------------

    /*
    Custom error = function jaisa hota hai
    Lekin:
    - String store nahi hota
    - Sirf error selector + data store hota
    - Gas bahut kam lagta hai
    */

    // Jab withdraw amount zyada ho
    error InsufficientBalance(uint256 available, uint256 required);

    // Jab koi non-owner owner function call kare
    error NotOwner(address caller);

    // Jab deposit amount 0 ya negative ho
    error DepositAmountMustBeGraterThenZero(string message);
    // ⚠️ Note:
    // Yahan string use ho rahi hai → gas thoda zyada
    // Normally string avoid karte hain custom errors me


    // ------------------------------------------------
    // CONSTRUCTOR
    // ------------------------------------------------

    constructor() {
        // Contract deploy karne wale ko owner bana diya
        owner = msg.sender;
    }


    // ------------------------------------------------
    // DEPOSIT FUNCTION (using revert + custom error)
    // ------------------------------------------------
    function deposit(uint256 _amount) public {

        /*
        Check user input
        Agar amount 0 ya less hai → revert
        */

        if (_amount <= 0) {
            revert DepositAmountMustBeGraterThenZero(
                "Deposit amount must be greater than zero"
            );
        }

        // Safe case → balance badhao
        balance += _amount;
    }


    /*
    GAS COMMENTS (Tumhare notes):
    -----------------------------
    require(string)       → ~22003 gas
    revert(string)        → ~22003 gas
    custom error          → ~21736 gas (cheapest)
    */


    // ------------------------------------------------
    // WITHDRAW USING CUSTOM ERROR
    // ------------------------------------------------
    function withdrawWithCustomError(uint256 _amount) public {

        /*
        Agar user zyada paisa nikalne ki koshish kare
        → revert with custom error
        */

        if (_amount > balance) {
            revert InsufficientBalance(balance, _amount);
        }

        // Valid case → balance kam karo
        balance -= _amount;
    }


    // ------------------------------------------------
    // ASSERT EXAMPLE (INTERNAL BUG CHECK)
    // ------------------------------------------------
    function emergencyReset() public {

        /*
        assert() ka use:
        - Condition kabhi false honi hi nahi chahiye
        - Agar false hui → developer bug
        - Saari gas consume ho jaati hai
        */

        assert(balance >= 0);
        // ⚠️ NOTE:
        // uint256 kabhi negative ho hi nahi sakta
        // Ye assert sirf example ke liye hai

        // Force reset
        balance = 0;
    }


    // ------------------------------------------------
    // ACCESS CONTROL USING CUSTOM ERROR
    // ------------------------------------------------
    function onlyOwnerFunction() public view {

        /*
        Agar caller owner nahi hai
        → revert with custom error
        */

        if (msg.sender != owner) {
            revert NotOwner(msg.sender);
        }

        // Agar owner hai → function silently pass ho jaata hai
    }
}
