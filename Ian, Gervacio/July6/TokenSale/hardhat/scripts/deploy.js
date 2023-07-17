const hre = require("hardhat");

async function main() {
  const tokenSaleContract = await hre.ethers.deployContract(
    "TokenSale",
    ['0x006D9679c211Fab293c5D741281366a7761607e7']
    );

  await tokenSaleContract.waitForDeployment();

  console.log(`Contract deployed to: ${tokenSaleContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })