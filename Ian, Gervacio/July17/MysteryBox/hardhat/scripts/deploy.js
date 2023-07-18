const hre = require("hardhat");

async function main() {
	const Lootbox = await hre.ethers.deployContract("Lootbox");

	await Lootbox.waitForDeployment();
	console.log("Lootbox Contract address: " +Lootbox.target);
}

main()
	.then(() => process.exit(0))
	.catch((error) => {
		console.log(error);
		process.exit(1);
	});