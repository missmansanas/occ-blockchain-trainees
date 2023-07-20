const hre = require("hardhat");

async function main() { 
  const metadataURL = "ipfs://QmYG4p56PusVwBAzCHGzfcDz4e7tdsqDnBBwAgRGuayZzM/2.json";

  const NFTCollContract = await hre.ethers.deployContract("NFTColl", [metadataURL]);

  await NFTCollContract.waitForDeployment();

  console.log("NFTColl Contract Address:", NFTCollContract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  