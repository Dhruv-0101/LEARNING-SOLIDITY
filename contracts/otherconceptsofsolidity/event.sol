// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/*
====================================================
EVENTS IN SOLIDITY – FULL COMMENTED EXAMPLE
====================================================

EVENTS KA KAAM:
- Blockchain pe LOG record karna
- Frontend / indexers (Etherscan, The Graph) ko notify karna
- Cheap data storage (storage ke mukable)

IMPORTANT:
- Events contract ke andar se read nahi hote
- Events sirf off-chain world ke liye hote hain
*/


contract IndexedEventExample {

    /*
    EVENT DECLARATION
    ------------------------------------------------

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed value
    );

    EVENT = LOG

    LOG me 2 parts hote hain:
    --------------------------------
    1️⃣ Topics   (indexed values)
    2️⃣ Data     (non-indexed values)

    Yahan:
    - from   → topic
    - to     → topic
    - value  → topic

    Max 3 indexed parameters allowed
    (event signature khud ek topic hota hai)
    */


    // ------------------------------------------------
    // TRANSFER FUNCTION
    // ------------------------------------------------
    function transfer(address _to, uint256 _amount) public {

        /*
        msg.sender = caller
        _to         = receiver
        _amount     = value

        emit ka matlab:
        - LOG write karo
        - Blockchain state change nahi hota
        */

        emit Transfer(msg.sender, _to, _amount);
    }
}
