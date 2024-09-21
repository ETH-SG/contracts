//Simple function to deploy Counter

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {CounterReversifi} from "../src/Counter.sol";
import {console2} from "forge-std/console2.sol";
import {Script} from "forge-std/Script.sol";
contract DeployCounter is Script {
    function run() external {
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);

        vm.startBroadcast(deployer);
        CounterReversifi counter = new CounterReversifi();
        console2.log("Counter deployed at: ", address(counter));
        vm.stopBroadcast();
    }
}
