import "hardhat/console.sol";

contract MemoryTest {
    function test() external pure returns (bytes32 wordFreeMemory) { // infinite gas
        assembly {
            // Load the 32-byte word from memory address 0x40 (free memory pointer location)
            wordFreeMemory := mload(0x40)
        }
        console.logBytes32(wordFreeMemory);
    }
}