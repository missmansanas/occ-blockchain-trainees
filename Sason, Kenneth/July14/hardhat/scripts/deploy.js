const hre = require("hardhat");

async function main() {
  const KenNFTContract = await hre.ethers.deployContract("KenNFTV3", [
    "ipfs://Qme6zq49JyS4Tu7iKiQ7VBuLfuyFt6zKRHwAZyAqb6AEoY/",
  ]);
  await KenNFTContract.waitForDeployment();
  console.log(`Contract Deployed to :${KenNFTContract.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
