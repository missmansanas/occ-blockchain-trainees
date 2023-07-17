require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({path: ".env"});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    mumbai: {
      url: "https://evocative-thrumming-dust.matic-testnet.discover.quiknode.pro/52a78499c69f4cf2fef562de0dd55bb4ee2cea44/",
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.API_KEY,
  }
};

//0xBb5684BFd38AE9B0BC7108449d75D8b284c878Dc