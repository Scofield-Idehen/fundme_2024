//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMEtest is Test {
    FundMe fundMe;
    
    function setUp() external {
       //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();
    }
    function testMInimun_is5() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
       
    }
    function testOwnerisSender() public{
        //this is a test that proves we are deploying a new contract 
        //so we need to check which contract is the owner
        //assertEq(fundMe.i_owner(), msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public{
        
        uint version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
