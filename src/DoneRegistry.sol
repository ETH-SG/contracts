// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IEscrow} from "../src/interface/IEscrow.sol";

contract DoneRegistry {
    address[] public escrows;

    constructor() {}

    function addToRegistry(address escrow) public {
        escrows.push(escrow);
    }

    function flush() public returns (bool) {
        uint256 length = escrows.length;
        if (length == 0) return false; // Early return if array is empty
        for (uint256 i = 0; i < escrows.length; i++) {
            IEscrow(escrows[i]).withdraw();
        }
        delete escrows;
        return true;
    }

    function getEscrowCount() public view returns (uint256) {
        return escrows.length;
    }
}
