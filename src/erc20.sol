// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Erc20 is ERC20 {
    
    address private owner;
    uint private _perMint;

    event MintSuccess(address user, uint amount);
    error NotOwner(address user);
 

    modifier onlyOwner{
        if(msg.sender != owner) revert NotOwner(msg.sender);
        _;
    } 
    constructor() ERC20("bitcoin", "BTC"){
         owner = msg.sender;
    }

    function init(string memory name, string memory symble, uint totalSupply, uint perMint) public {
        _name = name;
        _symbol = symble;
        _totalSupply = totalSupply;
        _perMint = perMint;
    }

    function mint(address receiver) public {
        _mint(receiver, _perMint);
        emit MintSuccess(receiver, _perMint);
   }

  
}