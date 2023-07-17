const hre = require("hardhat");

async function main() {
  const SimpleNFTContract = await hre.ethers.deployContract("SimpleNFT");

  await SimpleNFTContract.waitForDeployment();
  console.log(`Located at ${SimpleNFTContract.target}`);
}
main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.log(e);
    process.exit(1);
  });
