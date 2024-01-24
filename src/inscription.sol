// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./erc20.sol";

contract Inscription {
    using Clones for address;
    address owner;
    address templete;
    address [] tokenAddr;
    error NotOwner(address user);

    modifier onlyOwner{
        if(msg.sender != owner) revert NotOwner(msg.sender);
        _;
    } 

    constructor() {
        owner = msg.sender;
    }

    function setTem(address templeteAddress) public onlyOwner{
        templete = templeteAddress;
    }

    function deployInscription(string memory name, string memory symbol, uint totalSupply, uint perMint) public returns(address){
        address cloneERC20 = templete.clone();
        Erc20(cloneERC20).init(name,  symbol, totalSupply, perMint);
        tokenAddr.push(cloneERC20);
        return cloneERC20;
    }

    function mintInscription(address tokenAddr) public {
        Erc20(tokenAddr).mint(msg.sender);
    }


}
