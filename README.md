## 📌 项目简介

- 非常兴奋上传这个项目文件，这是我向Web3开发者迈出的第一步！
- 这是用Foundry框架编写的简单捐赠合约实例;
- 包括了合约的部署，以及大量的测试部分;
- 这是一个基于 Foundry 框架的 Web3 捐赠合约项目。
- 合约支持最低捐赠金额校验、捐赠者记录、仅 owner 可提现等功能。
- 包含完善的单元测试与集成测试，分支覆盖率 100%。
- 已集成代码格式化（Prettier）、Solidity Lint（Solhint）等开发工具。

## 🛠️ 技术栈

- Solidity 0.8.x
- Foundry（forge）
- Chainlink（预言机模拟）
- Node.js（开发工具链）

## 📂 目录结构

```
├── src/                # 主合约目录
│   ├── FoundMe.sol     # 主捐赠合约
│   └── PriceChange.sol # 价格工具库
├── test/               # 测试用例
│   ├── FoundMe.t.sol   # 单元测试
│   ├── FoundMe.integration.t.sol # 集成测试
│   └── mokds/MockAggregator.sol  # 预言机 mock
├── script/             # 部署与配置脚本
│   ├── deployFoundMe.s.sol
│   └── config.s.sol
├── .prettierrc         # 代码格式化配置
├── .solhint.json       # Solidity Lint 配置
├── package.json        # Node.js 项目配置
├── README.md           # 项目说明
```

## 🚀 快速开始

### 1. 克隆项目并安装依赖
```bash
git clone https://github.com/zzzzl-0/Foundry_learn.git
cd Foundry_learn
forge install
```

### 2. 编译合约
```bash
forge build
```

### 3. 运行测试（含覆盖率）
```bash
forge test --coverage
```

### 4. 部署合约
- 修改 Makefile 文件中的 `rpc` 和 `private_key` 参数：
  - `rpc`：目标链的 RPC 地址
  - `private_key`：部署钱包私钥（请勿使用主钱包）
- 执行部署脚本或使用 Foundry 命令行

## 🧪 测试说明
- 单元测试覆盖合约所有函数和分支
- 集成测试覆盖预言机变动、捐赠、提现、异常分支等
- 可通过 `forge test --coverage` 查看详细覆盖率报告




