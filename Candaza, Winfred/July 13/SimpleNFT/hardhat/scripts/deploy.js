const hre = require("hardhat");

async function main() {
  const SimpleNFTContract = await hre.ethers.deployContract('SimpleNFT');

  await SimpleNFTContract.waitForDeployment();
  console.log("Simple NFT Contract Address", SimpleNFTContract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) =>
    {console.error(error);
    process.exit(1);
  });