// SPDX-License-Identifier: MIT
// ↑ Open-source license

pragma solidity ^0.8.26;
// ↑ Solidity version (UDVTs Solidity 0.8.8+ me aaye the)

// ✅ USER-DEFINED VALUE TYPES (UDVT)
// --------------------------------------------------
// Syntax:
// type <NewTypeName> is <UnderlyingType>;
//
// Matlab:
// Age aur Weight internally uint64 hi hain
// BUT compiler unko alag-alag types treat karega
// → strong type safety milti hai

type Age is uint64;
type Weight is uint64;

contract WithUDVT {
    // ✅ STATE VARIABLES using UDVTs
    // --------------------------------------------------
    // age ka type sirf "Age" hai
    // weight ka type sirf "Weight" hai
    // uint64 directly assign nahi kar sakte

    Age public age;
    Weight public weight;

    // ✅ SETTER FUNCTION
    // --------------------------------------------------
    // Yahan compiler FORCE karta hai:
    // _age → Age type hona chahiye
    // _weight → Weight type hona chahiye
    //
    // Isse galti se values swap hone se bach jaate ho

    function setDetails(Age _age, Weight _weight) public {
        age = _age;
        weight = _weight;
    }

    // ✅ GETTER FOR AGE
    // --------------------------------------------------
    // age internally Age type hai
    // Lekin outside world (UI, tests) ko uint64 chahiye
    //
    // Isliye:
    // Age.unwrap(age) → uint64 me convert karta hai

    function getAge() public view returns (uint64) {
        return Age.unwrap(age);
    }

    // ✅ GETTER FOR WEIGHT
    // --------------------------------------------------
    // Same logic as getAge()

    function getWeight() public view returns (uint64) {
        return Weight.unwrap(weight);
    }
}

/*
🔥 Without UDVT (Problem)
function set(uint64 age, uint64 weight) public {
    // ❌ Galti se values swap ho sakti hain
    age = weight;
}


👎 Compiler kuch nahi bolega
👎 Bug silently chala jaayega

✅ With UDVT (Solution)
function set(Age age, Weight weight) public {
    age = weight; // ❌ COMPILER ERROR
}


💥 Error milega:

Type Weight is not implicitly convertible to type Age
*/
