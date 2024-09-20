// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {Escrow} from "../src/Escrow.sol";
import {DoneRegistry} from "../src/DoneRegistry.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract EscrowTest is Test {
    EscrowFactory public escrowFactory;
    Escrow public escrow;
    DoneRegistry public registry;

    address ADMIN = address(5);
    address USER = address(2);
    address DRIVER = address(3);
    address USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;

    uint256 internal constant USDC_DEPOSIT_AMOUNT = 25_000_000_000; // 25 000 USDC

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"));
        vm.startPrank(ADMIN);

        console.log(IERC20(USDC).balanceOf(ADMIN));

        registry = new DoneRegistry();

        escrowFactory = new EscrowFactory("Grab", ADMIN, address(registry));
        vm.stopPrank();
        deal(USDC, USER, USDC_DEPOSIT_AMOUNT);
    }

    function test_whole_flow() public {
        vm.startPrank(USER);

        //approve
        IERC20(USDC).approve(address(escrowFactory), 50_000_000);

        // create escrow
        Escrow escrow = escrowFactory.createEscrow(50_000_000, USDC, 1);

        assertEq(IERC20(USDC).balanceOf(address(escrow)), 50_000_000);

        // driver will accept it
        vm.stopPrank();

        vm.startPrank(DRIVER);

        escrowFactory.acceptSeller(address(escrow));

        escrow.done();

        vm.stopPrank();

        vm.startPrank(ADMIN);

        registry.flush();

        assertEq(IERC20(USDC).balanceOf(ADMIN), 5_000_000);
    }
}
