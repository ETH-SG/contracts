// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {DoneRegistry} from "../src/DoneRegistry.sol";
import {Escrow} from "../src/Escrow.sol";
import {IERC20} from "openzeppelin/token/ERC20/IERC20.sol";

contract DeployEscrowFactoryScript is Script {
    EscrowFactory public escrowFactory;
    DoneRegistry public registry;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address user = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        registry = new DoneRegistry();
        escrowFactory = new EscrowFactory("Grab", user, address(registry));

        vm.stopBroadcast();
    }
}
