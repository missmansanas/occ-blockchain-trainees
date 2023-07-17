const hre = require("hardhat");

async function main() {
	const lootboxContract = await hre.ethers.deployContract("Lootbox");

	await lootboxContract.waitForDeployment();
	console.log(`Contract deployed to: ${lootboxContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })