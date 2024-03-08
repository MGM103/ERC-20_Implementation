// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {ManualERC20} from "../../src/ManualERC-20.sol";
import {DeployManualERC20} from "../../script/DeployManualERC20.sol";

contract ManualERC20UnitTest is Test {
    ManualERC20 manualErc20;
    DeployManualERC20 deployManualErc20;

    address spender = makeAddr("spender");
    address thirdParty = makeAddr("thirdParty");

    uint256 public constant INITIAL_BAL = 1000 ether;

    function setUp() external {
        deployManualErc20 = new DeployManualERC20();
        manualErc20 = deployManualErc20.run();

        vm.prank(msg.sender);
        manualErc20.transfer(spender, INITIAL_BAL);
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

    function testInitialBalance() public view {
        assert(manualErc20.balanceOf(spender) == INITIAL_BAL);
    }

    function testAllowancesReflectedCorrectly() public {
        uint256 allowedAmount = 1000 ether;

        vm.prank(spender);
        manualErc20.approve(thirdParty, allowedAmount);

        assert(manualErc20.allowance(spender, thirdParty) == allowedAmount);
    }

    modifier spenderApprovesThirdParty(uint256 allowedAmount) {
        vm.prank(spender);
        manualErc20.approve(thirdParty, allowedAmount);
        _;
    }

    function testTransfer() public {
        uint256 transferAmount = 100 ether;

        vm.prank(spender);
        manualErc20.transfer(thirdParty, transferAmount);

        assert(manualErc20.balanceOf(thirdParty) == transferAmount);
        assert(manualErc20.balanceOf(spender) == INITIAL_BAL - transferAmount);
    }

    function testTransferFrom() public spenderApprovesThirdParty(1000 ether) {
        uint256 allowedAmount = 1000 ether;
        uint256 transferAmount = 100 ether;

        vm.prank(thirdParty);
        manualErc20.transferFrom(spender, thirdParty, transferAmount);

        assert(manualErc20.balanceOf(thirdParty) == transferAmount);
        assert(manualErc20.balanceOf(spender) == INITIAL_BAL - transferAmount);
        assert(
            manualErc20.allowance(spender, thirdParty) ==
                allowedAmount - transferAmount
        );
    }
}
