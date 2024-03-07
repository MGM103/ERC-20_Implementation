// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {ManualERC20} from "../src/ManualERC-20.sol";

contract DeployManualERC20 is Script {
    function run() external returns (ManualERC20) {
        vm.startBroadcast();
        ManualERC20 manualErc20 = new ManualERC20("ManualERC20", "MERC20");
        vm.stopBroadcast();
        return manualErc20;
    }
}
