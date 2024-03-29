/*
    This code is the test code before adding the liquidity mining feature, 
    it can be used as a reference, but it is outdated
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Test, console} from "forge-std/Test.sol";
import {Inscription} from "../src/inscriptionFactory.sol";
import {Erc20} from "../src/erc20.sol";

contract InscriptionTest is Test {
    Inscription public ins;
    Erc20 public erc;
    address owner   = makeAddr("owner");
    address minter1 = makeAddr("minter1");
    address minter2 = makeAddr("minter2");
    address minter3 = makeAddr("minter3");

    function setUp() public {
        vm.startPrank(owner);{
            ins = new Inscription();
            erc = new Erc20();
        }
        vm.stopPrank();
    }

    function deploy() internal returns(address){
        return ins.deployInscription("test1", "ts1", 20, 5);
    }

    function setTemplete() internal {
        ins.setTemplete(address(erc));
    }

    function test_DeployInscription() public {
            
            vm.startPrank(owner);
            setTemplete();
            vm.stopPrank();

            address addressLog = ins.deployInscription("test1", "ts2", 20, 11);
            console.log(addressLog);

            addressLog = ins.deployInscription("test2", "ts3", 203, 51);
            console.log(addressLog);

            addressLog = ins.deployInscription("test3", "ts4", 201, 1);
            console.log(addressLog);

            addressLog = ins.deployInscription("test4", "ts5", 120, 31);
            console.log(addressLog);

    }

    function test_MintInscription() public {
        vm.startPrank(owner);
            setTemplete();
        vm.stopPrank();
    
        vm.startPrank(minter1);{
            address tokenAddr = deploy();
            //ins.mintInscription(tokenAddr);
            uint balance = Erc20(tokenAddr).balanceOf(minter1);
        }
        vm.stopPrank();

    }
}
