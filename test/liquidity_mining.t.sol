  
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Erc20}  from "../src/erc20.sol";
import {UniswapV2Router02} from "../src/uniswapV2_periphery/UniswapV2Router02.sol";
import {UniswapV2Factory} from "../src/uniswapV2_core/UniswapV2Factory.sol";
import {WETH9} from "../src/uniswapV2_periphery/WETH9.sol";
import {Inscription} from "../src/inscriptionFactory.sol";
import {UniswapV2Pair} from "../src/uniswapV2_core/UniswapV2Pair.sol";
import '../src/uniswapV2_periphery/libraries/UniswapV2Library.sol';


contract Fuzz_bank_test is Test {
    Erc20  token;
    UniswapV2Factory factory;
    UniswapV2Router02 router;
    WETH9 weth;
    Inscription inscriptionFactory;
    address admin = makeAddr("myadmin");
    address minter1 = makeAddr("minter1");
    address minter2 = makeAddr("minter2");
    address testInscriptionAddr1;
    address testInscriptionAddr2;
    address testInscriptionAddr3;
   
    
    function setUp() public {
        vm.startPrank(admin);
            token = new Erc20();
            inscriptionFactory = new Inscription();
            factory = new UniswapV2Factory(admin);
            weth = new WETH9();
            router = new UniswapV2Router02(address(factory), address(weth));
            test_DeployInscription();
            deal(admin, 100000 ether);
            deal(minter1, 100000 ether);
            deal(minter2, 100000 ether);
        vm.stopPrank();
    }

    function test_DeployInscription() public {
            
        address addressLog = inscriptionFactory.deployInscription("test1", "ts2", 20000, 1000);
        testInscriptionAddr1 = addressLog;
        console.log(addressLog);

        addressLog = inscriptionFactory.deployInscription("test2", "ts3", 203, 51);
        testInscriptionAddr2 = addressLog;
        console.log(addressLog);

        addressLog = inscriptionFactory.deployInscription("test3", "ts4", 201, 1);
        testInscriptionAddr3 = addressLog;
        console.log(addressLog);
    }


     function test_MintInscription_And_AddLiquidity() public {
       
        vm.startPrank(minter1);
            bytes memory callData = abi.encodeWithSignature("mintInscription(address, uint256, uint256, uint256)", testInscriptionAddr1, 800, 780, 3 ether);
            (bool sent, bytes memory data) = address(factory).call{value: 1 ether}(callData);
            uint balance = Erc20(testInscriptionAddr1).balanceOf(minter1);
            address pair = UniswapV2Library.pairFor(address(factory), testInscriptionAddr1, address(weth));
            uint lpAmount = UniswapV2Pair(pair).balanceOf(address(this));
            console.log(balance, "player balance");
            console.log(lpAmount, "admin lp amount");
        vm.stopPrank();

    }

    function test_WithdrawLiquidityGains() public {

        vm.startPrank(admin);
            address pair = UniswapV2Library.pairFor(address(factory), testInscriptionAddr1, address(weth));
            uint256 lpAmount = UniswapV2Pair(pair).balanceOf(address(this));
            inscriptionFactory.WithdrawLiquidityGains(testInscriptionAddr1, lpAmount, 780, 3 ether); 
            lpAmount = UniswapV2Pair(pair).balanceOf(address(this));
            uint256 testInscriptionAmount = Erc20(testInscriptionAddr1).balanceOf(address(this));
            uint256 wethAmount = weth.balanceOf(address(this));
            console.log(lpAmount, "admin lp amount after withdraw");
            console.log(testInscriptionAmount, "testInscription amount after withdraw");
            console.log(wethAmount, "weth amount after withdraw");

        vm.stopPrank();


    }
}