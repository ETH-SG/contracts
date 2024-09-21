//Create a simple counter contract that has a function to increment a counter and a function to get the current value of the counter

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract CounterReversifi {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
