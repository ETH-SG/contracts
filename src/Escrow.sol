// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";
import {IDoneRegistry} from "../src/interface/IDoneRegistry.sol";

contract Escrow {
    enum Status {
        PENDING,
        CONFIRM,
        FINISH,
        RELEASE,
        DISPUTE
    }

    address immutable buyer;
    address immutable admin;
    address immutable token;
    address public seller;

    IDoneRegistry public registry;

    Status public state;

    mapping(address => bool) public adminMap;

    event Withdrawn(address indexed company, uint256 companyAmount, address indexed seller, uint256 sellerAmount);

    modifier CheckAdminOrRunner() {
        // if its admin or runner calling this then we can allow them to call
        require(adminMap[msg.sender] == true, "YOU ARE NOT ADMIN");
        _;
    }

    modifier SellerChecker() {
        require(seller == msg.sender);
        _;
    }

    constructor(address user, address _token, address _admin, address _registry) {
        buyer = user;
        token = _token;
        registry = IDoneRegistry(_registry);
        admin = _admin;
        adminMap[_admin] = true;
        adminMap[_registry] = true;
        state = Status.PENDING;
    }

    function addAdmin(address admin) external {
        adminMap[admin] = true;
    }

    function withdraw() external CheckAdminOrRunner {
        console.log(token);
        // Get the current balance of the contract
        uint256 balance = IERC20(token).balanceOf(address(this));
        console.log(balance);
        // withdraw all the money here 10% goes to grab and 90% goes to driver
        uint256 companyShareTemp = (balance * 10);
        uint256 companyShare = companyShareTemp / 100;
        console.log(companyShare);
        uint256 driverShare = balance - companyShare; // Remainder for the driver

        // Transfer the company's share
        require(IERC20(token).transfer(admin, companyShare), "Company transfer failed");

        // Transfer the driver's share
        require(IERC20(token).transfer(seller, driverShare), "Driver transfer failed");

        // Emit an event for the withdrawal
        emit Withdrawn(msg.sender, companyShare, seller, driverShare);
    }

    function addSeller(address _seller) external {
        seller = _seller;
    }

    function done() external SellerChecker {
        registry.addToRegistry(address(this));
        state = Status.FINISH;
    }

    function confirm() external SellerChecker {
        state = Status.CONFIRM;
    }

    function changeStatus(Status _state) external {
        state = _state;
    }

    function getState() public view returns (Status state) {
        return state;
    }
}
