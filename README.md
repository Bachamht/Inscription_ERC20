## ERC20 铭文

主要实现两个功能：

1.部署铭文：deployInscription(string memory name, string memory symbol, uint totalSupply, uint perMint) 

测试代码：

````solidity
function test_DeployInscription() public {
            
            vm.startPrank(owner);
            setTem();
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
````

测试结果：

![image](https://github.com/Bachamht/inscription_erc20/blob/main/images/28c31a034abb48b9a7f28b0f60588333.png)



2.打铭文：mintInscription(address tokenAddr)

测试代码：
````solidity
 function test_MintInscription() public {
        vm.startPrank(owner);
            setTem();
        vm.stopPrank();
    
        vm.startPrank(minter1);{
            address tokenAddr = deploy();
            ins.mintInscription(tokenAddr);
            uint balance = Erc20(tokenAddr).balanceOf(minter1);
            console.log(balance);
        }
        vm.stopPrank();

 }
````



 测试结果：
![image](https://github.com/Bachamht/inscription_erc20/blob/main/images/39284f2c4d6c57a48bd1fea0701506b0.png)



