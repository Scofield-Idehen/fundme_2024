//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMEtest is Test {
    FundMe fundMe;
    address SCOFIELD = makeAddr("Scofield");
    uint64 constant VALUE = 0.1 ether;
    uint256 constant  STARTING_VALUE = 1 ether;
    uint constant public GAS_PRICE = 1;
    
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
        assertEq(fundMe.getowner(), msg.sender);
    }

    function testVersion() public{
        
        uint version = fundMe.getVersion();
        assertEq(version, 6);
    }

    function testFUndFail() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesfund() public {
        vm.deal(SCOFIELD, STARTING_VALUE);
        vm.prank(SCOFIELD);
        fundMe.fund{value: VALUE}();
        uint256 amountfunded = fundMe.getaddressToAmoutFunded(SCOFIELD); 
        assertEq (amountfunded, VALUE);
    }

    function testAddressFunderToArrays() public{
        vm.prank(SCOFIELD);
        vm.deal(SCOFIELD, STARTING_VALUE);
        fundMe.fund{value: VALUE}();
        address funder = fundMe.getfund(0);
        assertEq (funder, SCOFIELD);
    }

    //we set the modifier to make sure we do not repeat cartain lines
    //we set the prank, deal, set value
    modifier funders(){
          vm.prank(SCOFIELD);
        vm.deal(SCOFIELD, STARTING_VALUE);
        fundMe.fund{value: VALUE}();
        _;
    }

    function testOnlyowner() public funders{
      
        vm.prank(SCOFIELD);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function getTestowner () public funders{
        //arrange
        uint startingownerBalance = fundMe.getowner().balance;
        uint startingfundMeBalance = address(fundMe).balance;
        
        //act
        //checks how much gas is available
        //i really dont understand it fully but i will soon enough 
        uint gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getowner());
        fundMe.withdraw();

        //assert
         uint endingownerBalance = fundMe.getowner().balance;
         uint endingfundmebalance = address(fundMe).balance;
         assertEq(endingfundmebalance, 0);
         assertEq(startingfundMeBalance + startingownerBalance, endingownerBalance);

    }

    function testwithdrawfrommultiplefunders() public funders{
        //arrange
        uint160 numberoffunders = 10;
        uint160 startingfunderindex = 1; 
        for(uint160 i = startingfunderindex; i < numberoffunders; i++){
            hoax(address(i), STARTING_VALUE);
            fundMe.fund{value: STARTING_VALUE}();
        }

        uint startingownerBalance = fundMe.getowner().balance;
        uint startingfundMeBalance = address(fundMe).balance;

         //act
        vm.startPrank(fundMe.getowner());
        fundMe.withdraw();
        vm.stopPrank();

        //assert

        assert(address(fundMe).balance == 0);
        assert(startingfundMeBalance + startingownerBalance  == 
        fundMe.getowner().balance
        );




    }

}
