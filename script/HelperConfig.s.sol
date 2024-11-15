//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public constant DECIMAL = 8;
    int public constant INITIAL = 2000e8;

    NetworkConfig public activeNetwork;


     struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if (block.chainid == 11155111) {
            activeNetwork = GetSapolaConfig();
        }else if (block.chainid == 1){
            activeNetwork = GetETHConfig();   
        }else {
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

    function GetETHConfig() pure public returns (NetworkConfig memory){
        //this checks if  we have created a contract 
        //if yes it wont create again
        NetworkConfig memory EthConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return EthConfig;
    }

    function GetAnvilConfig() public returns (NetworkConfig memory){
        if (activeNetwork.priceFeed != address(0)){
            return activeNetwork;
        }
        
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL, INITIAL);

        vm.stopBroadcast();


        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
        
    }
}