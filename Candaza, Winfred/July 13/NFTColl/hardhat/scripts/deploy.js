// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const MyNftColl = await hre.ethers.deployContract("MyNftColl", [
    "ipfs://bafkreiamjobkn2b45yw2jrb7t7gi4vuvszy6za4hq67mbl36z3bunhjm54",
  ]);
  await MyNftColl.waitForDeployment();
  console.log(`Contract Deployed to :${MyNftColl.target}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
