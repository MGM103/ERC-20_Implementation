// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {ManualERC20} from "../src/ManualERC-20.sol";

contract DeployManualERC20 is Script {
    uint256 public constant ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey;

    function run() external returns (ManualERC20) {
        if (block.chainid == 31337) {
            deployerKey = ANVIL_KEY;
        } else {
            deployerKey = vm.envUint("PRIVATE_KEY");
        }

        vm.startBroadcast(deployerKey);
        ManualERC20 manualErc20 = new ManualERC20("ManualERC20", "MERC20");
        vm.stopBroadcast();
        return manualErc20;
    }
}
