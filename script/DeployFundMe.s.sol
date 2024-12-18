//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{

    function run() external returns (FundMe){
        //anything before the start broadcast will simulate a real transaction
        HelperConfig config = new HelperConfig();
        address ethusdPriceFeed = config.activeNetwork(); 
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethusdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }

}