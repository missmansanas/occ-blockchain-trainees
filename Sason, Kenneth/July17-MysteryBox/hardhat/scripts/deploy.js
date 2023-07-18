const hre = require("hardhat");

async function main() {
  const Lootbox = await hre.ethers.deployContract("Lootbox");
  await Lootbox.waitForDeployment();
  console.log(`Located at ${Lootbox.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
