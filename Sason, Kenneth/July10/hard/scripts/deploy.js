const hre = require("hardhat");

async function main() {
  const exchangeContract = await hre.ethers.deployContract("Exchange", [
    "0x052803fC63a7371fFAd8Ad93C7829Ad382416257",
  ]);
  await exchangeContract.waitForDeployment();
  console.log(`Contract deployed to : ${exchangeContract.target}`);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
