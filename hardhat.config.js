require("@nomiclabs/hardhat-waffle");
require("@truffle/contract");
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

module.exports = {
  networks: {
    hardhat: {
      forking: {
        url:  process.env.POLYGON_RPC_URL,
        block: 30000000
      }
    },
    matic: {
      url:  process.env.POLYGON_RPC_URL,
      accounts: [process.env.POLYGON_PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.14",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
}
