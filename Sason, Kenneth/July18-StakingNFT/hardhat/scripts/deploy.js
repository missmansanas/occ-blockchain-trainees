// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const kenContract = await hre.ethers.deployContract("KenToken", [
    "0xCA97124a364013E1ed3B1E6e9D6C5A929a9fB3c4",
  ]);
  await kenContract.waitForDeployment();
  console.log(`Located at ${kenContract.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
