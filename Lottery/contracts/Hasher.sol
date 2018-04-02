pragma solidity ^0.4.16;

// this contract can be used by owner on his side to calculate the hash of winning number
contract Hasher {
    function hashMe(uint256 winNum) public returns (bytes32 winhash) {
        winhash = keccak256(winNum);
        return winhash;
    }
}