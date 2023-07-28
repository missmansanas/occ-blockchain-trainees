const hre = require("hardhat");

async function main() {
	const fortuneCookieContract = await hre.ethers.deployContract("FortuneCookie");
	await fortuneCookieContract.waitForDeployment();
	console.log(`Contract deployed to: ${fortuneCookieContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })