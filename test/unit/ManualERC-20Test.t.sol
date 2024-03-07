// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {ManualERC20} from "../../src/ManualERC-20.sol";
import {DeployManualERC20} from "../../script/DeployManualERC20.sol";

contract ManualERC20UnitTest is Test {
    ManualERC20 manualErc20;

    function setUp() external {
        DeployManualERC20 deployManualErc20 = new DeployManualERC20();
        manualErc20 = deployManualErc20.run();
    }

    function testName() public view {
        assert(
            keccak256(abi.encodePacked(manualErc20.name())) ==
                keccak256(abi.encodePacked("ManualERC20"))
        );
    }

    function testSymbol() public view {
        assert(
            keccak256(abi.encodePacked(manualErc20.symbol())) ==
                keccak256(abi.encodePacked("MERC20"))
        );
    }

    function testDecimals() public view {
        assert(manualErc20.decimals() == 18);
    }

    function testTotalSupply() public view {
        assert(manualErc20.totalSupply() == 1000000 ether);
    }
}
