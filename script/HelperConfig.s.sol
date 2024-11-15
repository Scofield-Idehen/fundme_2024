//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetwork;

     struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if (block.chainid == 11155111) {
            activeNetwork = GetSapolaConfig();
        } else {
            activeNetwork = GetAnvilConfig();
        }
    }
    //if we are on a local anvil, we deploy mocks
    //otherwise if we hardcode, we grab the live address


    function GetSapolaConfig() pure public returns (NetworkConfig memory){
        NetworkConfig memory sapolaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sapolaConfig;
    }

    function GetAnvilConfig() pure public returns (NetworkConfig memory){
        
    }
}