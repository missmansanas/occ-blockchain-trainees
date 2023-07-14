const hre = require("hardhat");

async function main() {
	const MyNFTColl = await hre.ethers.deployContract("MyNFTColl", [
		"ipfs://QmbMAdJQnJoSRnHqmQ2QPhRJg15fZCU2zKobiux5MCRGRm/1",
  ]);

	await MyNFTColl.waitForDeployment();
	console.log("MyNFTColl Contract address: " +MyNFTColl.target);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.log(error);
		process.exit(1);
	});