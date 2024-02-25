require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-ethers");
require("@nomicfoundation/hardhat-verify");
require("@nomicfoundation/hardhat-chai-matchers");
require("solidity-coverage");
require("hardhat-dependency-compiler");
require("hardhat-deploy");
require("hardhat-gas-reporter");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000000
      },
      viaIR: true
    }
  },
  etherscan: {
    apiKey: "T5Z532NYIYCGVB465P72DFYT96MYPHEH9T"
  },
  networks: {
    hardhat: {
      chainId: 1337,
      allowUnlimitedContractSize: true,
    },
    sepolia: {
      url: process.env.INFURA_SEPOLIA_API_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 11155111,
    },
    mumbai: {
      url: process.env.INFURA_MUMBAI_API_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainIds: 80001, // mumbai testnet
    },
    polygonzkevm: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.PRIVATE_KEY]
    },
    x1: {
      url: "https://testrpc.x1.tech",
      accounts: [process.env.PRIVATE_KEY]
    },
    scroll: {
      url: "https://sepolia-rpc.scroll.io",
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  namedAccounts: {
    deployer: {
      default: 0
    }
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    outputFile: "gasReports.txt",
    noColors: true,
  }
};
