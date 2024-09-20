// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {console} from "forge-std/Test.sol";
import {Escrow} from "./Escrow.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract EscrowFactory {
    Escrow[] public escrows;
    mapping(uint256 => address) public escrowsMap;

    string companyName;
    address public admin;

    event EscrowCreated(address indexed escrow);

    modifier CheckBeforeConfirm(address escrow) {
        require(Escrow(escrow).getState() == Escrow.Status.PENDING);
        _;
    }

    modifier CheckBeforeFinish(address escrow) {
        require(Escrow(escrow).getState() == Escrow.Status.CONFIRM);
        _;
    }

    modifier CheckBeforeRelease(address escrow) {
        require(Escrow(escrow).getState() == Escrow.Status.FINISH);
        _;
    }

    constructor(string memory name, address _admin) {
        companyName = name;
        admin = _admin;
    }

    function createEscrow(uint256 amount, address token, uint256 orderId) external returns (Escrow) {
        console.log(admin);
        Escrow escrow = new Escrow(msg.sender, token, admin);
        escrows.push(escrow);
        escrowsMap[orderId] = address(escrow);

        // lock the funds into the escrow
        IERC20(token).transferFrom(msg.sender, address(escrow), amount);

        return escrow;
    }

    function changeEscrowStateConfirm(address escrow, address seller) external CheckBeforeConfirm(escrow) {
        Escrow(escrow).addSeller(seller);
        Escrow(escrow).changeStatus(Escrow.Status.CONFIRM);
    }

    function changeEscrowStateFinish(address escrow) external CheckBeforeFinish(escrow) {
        Escrow(escrow).changeStatus(Escrow.Status.FINISH);
    }

    function changeEscrowStateRelease(address escrow) external CheckBeforeRelease(escrow) {
        Escrow(escrow).changeStatus(Escrow.Status.RELEASE);
    }

    function changeEscrowStateDispute(address escrow) external CheckBeforeRelease(escrow){
        Escrow(escrow).changeStatus(Escrow.Status.DISPUTE);
    }

    function acceptSeller(address escrow) external {
        Escrow(escrow).addSeller(msg.sender);
    }

    function getAllEscrow() public view returns (Escrow[] memory escrows){
        return escrows;
    }
}
