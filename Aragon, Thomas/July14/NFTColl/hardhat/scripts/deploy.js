const hre = require("hardhat");

async function main() {
	const nftCollContract = await hre.ethers.deployContract("MyNFTColl", ["ipfs://QmQUTJkE3irEGCpBdPkEAFzdb23fmjBG1Vv84SQMN3khaD/1"]);

	await nftCollContract.waitForDeployment();
	console.log(`Contract deployed to: ${nftCollContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })