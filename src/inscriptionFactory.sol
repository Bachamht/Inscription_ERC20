// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./erc20.sol";
import {UniswapV2Router02} from "../src/uniswapV2_periphery/UniswapV2Router02.sol";
import {UniswapV2Factory} from "../src/uniswapV2_core/UniswapV2Factory.sol";
import {UniswapV2Pair} from "./uniswapV2_core/UniswapV2Pair.sol";
import './uniswapV2_periphery/libraries/UniswapV2Library.sol';

import {WETH9} from "../src/uniswapV2_periphery/WETH9.sol";


contract Inscription {
    using Clones for address;
    address public owner;
    address public templete;
    address [] public tokenAddr;
    address public uniswapV2Router;
    address public uniswapV2Factory;
    address public weth;

    uint256 public MintFee = 0.01 ether;

    error NotOwner(address user);
    error MintFeeNotEnough();
    error NotEnoughLiquidity();

    modifier onlyOwner {
        if(msg.sender != owner) revert NotOwner(msg.sender);
        _;
    } 

    constructor() {
        owner = msg.sender;
    }

    function setTemplete(address templeteAddress) public onlyOwner {
        templete = templeteAddress;
    }

    function deployInscription(string memory name, string memory symbol, uint totalSupply, uint perMint) public returns(address) {
        address cloneERC20 = templete.clone();
        Erc20(cloneERC20).init(name,  symbol, totalSupply, perMint);
        tokenAddr.push(cloneERC20);
        return cloneERC20;
    }

    function mintInscription(address tokenAddress, uint256 amount, uint256 amountTokenMin, uint256 amountETHMin) public payable {
        if (msg.value < MintFee) revert MintFeeNotEnough();
        uint256 ETHLiquidityNeeds = msg.value / 2;
        Erc20(tokenAddress).mint(msg.sender, amount);
        bytes memory callData = abi.encodeWithSignature("deposit()");
        (bool sent, bytes memory data) = msg.sender.call{value: ETHLiquidityNeeds}(callData);
        UniswapV2Router02(payable(uniswapV2Router)).addLiquidityETH(tokenAddress, ETHLiquidityNeeds, amountTokenMin, amountETHMin, address(this), block.timestamp + 60);
    }

    function WithdrawLiquidityGains(address tokenAddress, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin) public onlyOwner {
        address pair = UniswapV2Library.pairFor(uniswapV2Factory, tokenAddress, weth);
        if(UniswapV2Pair(pair).balanceOf(address(this)) < liquidity) revert NotEnoughLiquidity();
        UniswapV2Router02(payable(uniswapV2Router)).removeLiquidityETH(tokenAddress, liquidity, amountTokenMin, amountETHMin, address(this), block.timestamp + 60);
    }


}
