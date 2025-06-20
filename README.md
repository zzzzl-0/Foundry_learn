
## 📌 项目简介

- 非常兴奋上传这个项目文件，这是我向Web3开发者迈出的第一步！
- 这是用Foundry框架编写的简单捐赠合约实例;
- 包括了合约的部署，以及大量的测试部分;

## 🛠️ 技术栈

- Solidity
- Foundry

## 📦 安装

```bash
# Start
git clone https://github.com/zzzzl-0/Foundry_learn.git
cd Foundry_learn
forge build

# Test
- forge test 
- 一键进行测试，包含了对脚本合于，以及主合约中大部分功能的测试

# Deploy
修改Makefile文件中的 rpc&private_key 参数
- rpc ：你打算部署的chain
- private_key ：钱包私钥，可以是 Metemask 钱包私钥地址，注意不要用带有真实的虚拟币的地址进行部署



