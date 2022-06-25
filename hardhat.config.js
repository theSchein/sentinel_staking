require("@nomiclabs/hardhat-waffle");

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

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.14",
  hardhat: {
    forking: {
      //export POLYGON_RPC_URL=https://polygon-matic.infura....
      url: process.env.POLYGON_RPC_URL,
      // export POLYGON_PRIVATE_KEY=0xAAAAA..... (has to have matic in it)
      account: [process.env.POLYGON_PRIVATE_KEY]
    }
  }
};
