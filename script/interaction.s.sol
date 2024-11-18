//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundfundMe is Script{

    uint constant SEND_VALUE = 0.01 ether; 

    function fundMeNumber2( address mostrecentDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostrecentDeployed)).fund{value: SEND_VALUE};
        vm.stopBroadcast();
        console.log("Funded FundMe with $s, SEND_VALUE)
    }
    function run() external {
        address mostrecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", block.chainid
        );
        fundMeNumber2(mostrecentDeployed);

    }
}