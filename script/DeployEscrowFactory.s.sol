// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {EscrowFactory} from "../src/EscrowFactory.sol";
import {DoneRegistry} from "../src/DoneRegistry.sol";
import {Escrow} from "../src/Escrow.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployEscrowFactoryScript is Script {
    EscrowFactory public escrowFactory;
    DoneRegistry public registry;

    function run() public {
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);

        console2.log("Deployer: ", deployer);
        console2.log("Deployer Nonce: ", vm.getNonce(deployer));

        vm.startBroadcast(deployer);

        registry = new DoneRegistry();
        escrowFactory = new EscrowFactory("Grab", deployer, address(registry));

        console2.log("Escrow Factory: ", address(escrowFactory));
        console2.log("Registry: ", address(registry));

        vm.stopBroadcast();
    }
}
