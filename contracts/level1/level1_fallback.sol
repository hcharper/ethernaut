// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {      // modifier that resolves to true and lets functions that require it be called if the params are met
        require(msg.sender == owner, "caller is not the owner");    // so only the contract owner can call functions that require the "onlyOwner" modifier
        _;
    }

    function contribute() public payable {      // any sender can contribute and be added to the "contributions" mapping declared at top
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {     // could you spam contributions to become owner???
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    function withdraw() public onlyOwner {      // this function has the only owner modifier so only the contract owner can call it
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {        // defaults to this method if a payment is recieved and no function is specified
        require(msg.value > 0 && contributions[msg.sender] > 0);        // says if contributtions for the sender's account is not 0, than they become owner (line below)
        owner = msg.sender;     // this is out way of becoming owner and then being able to withdraw
    }
}