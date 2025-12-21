// SPDX-License-Identifier: MIT
// ↑ License identifier (open-source, free to use)

pragma solidity ^0.8.26;
// ↑ Solidity compiler version (0.8.26 ya usse upar, but 0.9 se niche)

contract Constants {

    // 🔒 IMMUTABLE VARIABLE
    // --------------------------------------------------
    // immutable ka matlab:
    // 1️⃣ Value sirf ek baar set ho sakti hai
    // 2️⃣ Either yahin declare karte time
    //    OR constructor ke andar
    // 3️⃣ Deploy hone ke baad CHANGE NAHI ho sakti
    // 4️⃣ constant se thodi zyada flexible hoti hai
    // 5️⃣ Storage me nahi jaati → gas cheap hota hai

    address public immutable myAddr =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
        // ↑ yahin pe value set kar di
        // ↑ ab constructor me isse change nahi kar sakte


    uint256 public immutable myUint;
    // ↑ yahan value abhi set nahi hui
    // ↑ ye constructor ke andar set hogi


    // 🔐 CONSTANT VARIABLES
    // --------------------------------------------------
    // constant ka matlab:
    // 1️⃣ Compile-time pe hi value fix ho jaati hai
    // 2️⃣ Constructor me set nahi kar sakte
    // 3️⃣ Hamesha SAME value rahegi
    // 4️⃣ Sabse zyada gas efficient
    // 5️⃣ Coding convention: CONSTANTS UPPERCASE me

    address public constant MY_ADDRESS =
        0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;
        // ↑ hardcoded address
        // ↑ isse kabhi change nahi kar sakte

    uint256 public constant MY_UINT = 123;
        // ↑ hardcoded number
        // ↑ deploy ke baad bhi same rahega


    // 🏗️ CONSTRUCTOR
    // --------------------------------------------------
    // constructor sirf EK BAAR run hota hai
    // jab contract deploy hota hai

    constructor(uint256 _myUint) {

        // ❌ YE ALLOWED NAHI HAI
        // myAddr = msg.sender;
        // ↑ kyunki myAddr pehle hi declare time pe set ho chuka hai

        // ✅ YE ALLOWED HAI
        myUint = _myUint;
        // ↑ immutable variable ko constructor me set kiya
        // ↑ deploy ke baad ye bhi change nahi hoga
    }
}
// | Type        | Kab Set Hota Hai | Constructor? | Change Later? | Gas          |
// | ----------- | ---------------- | ------------ | ------------- | ------------ |
// | `constant`  | Compile time     | ❌ No         | ❌ No          | 🔥 Cheapest  |
// | `immutable` | Deploy time      | ✅ Yes        | ❌ No          | 🔥 Cheap     |
// | `storage`   | Runtime          | ✅ Yes        | ✅ Yes         | 💸 Expensive |
