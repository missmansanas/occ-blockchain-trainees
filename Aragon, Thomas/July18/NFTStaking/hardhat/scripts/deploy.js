const hre = require("hardhat");

async function main() {
	const NFTContract = await hre.ethers.deployContract("MyNFT");

	await NFTContract.waitForDeployment();
	console.log(`Contract deployed to: ${NFTContract.target}`);

  const tokenContract = await hre.ethers.deployContract("MyToken", [NFTContract.target]);
  await tokenContract.waitForDeployment();
  console.log(`Contract deployed to: ${tokenContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })