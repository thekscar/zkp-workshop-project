pragma solidity ^0.5.0; 

contract verifierI {
    function verifyTx(uint[2] memory a, uint[2][2] memory b, uint[2] memory c, uint[11] memory input) public returns (bool r);
}