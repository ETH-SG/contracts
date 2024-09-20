// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IEscrow} from "../src/interface/IEscrow.sol";

contract DoneRegistry {
    address[] public escrows;

    constructor() {}

    function addToRegistry(address escrow) public {
        escrows.push(escrow);
    }

    function flush() public {
        for (uint256 i = 0; i < escrows.length; i++) {
            IEscrow(escrows[i]).withdraw();
        }
    }
}
