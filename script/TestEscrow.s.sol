// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {Escrow} from "../src/Escrow.sol";
import {DoneRegistry} from "../src/DoneRegistry.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EscrowTest is Script {
    EscrowFactory public escrowFactory;
    Escrow public escrow;
    DoneRegistry public registry;

    IERC20 public myToken;

    function setUp() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        myToken = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);

        registry = DoneRegistry(0x683cFA991B4a8E33f1563911F32A96e2161cD1C8);

        escrowFactory = EscrowFactory(
            0xF1B4D344B483592C6EE17fF8C437db69c62b3e77
        );

        IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48).approve(
            address(escrowFactory),
            10000
        );

        // escrowFactory.createEscrow(1_000_000, 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 1);

        vm.stopBroadcast();
    }

    function run() public {
        // uint256 driverPrivateKey = vm.envUint("PRIVATE_KEY_2");
        // address driver = vm.addr(driverPrivateKey);
        // vm.startBroadcast(driverPrivateKey);
        // escrowFactory.acceptSeller(driver);
        // escrow.done();
        // vm.stopBroadcast();
    }
}
