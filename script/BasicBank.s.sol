// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "forge-std/Script.sol";

import {BasicBank} from "../src/BasicBank.sol";
import {StakingToken, RewardToken} from "../src/Token.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployBasicBank is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // 合約部署
        StakingToken st = new StakingToken();
        RewardToken rt = new RewardToken();
        BasicBank stBank = new BasicBank(IERC20(address(st)) , IERC20(address(rt)));

        // console.log("StakingToken address:");
        // console.log(address(st));
        // console.log("RewardToken address:");
        // console.log(address(rt));
        // console.log("BasicBank address:");
        // console.log(address(stBank));

        vm.stopBroadcast();
    }
}
