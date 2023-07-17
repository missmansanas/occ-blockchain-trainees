const hre = require("hardhat");

async function main() {
  const tokenSaleContract = await hre.ethers.deployContract(
    "TokenSale",
    ['0x2A3abeFCeFDB7421Bb9FB6920Fb299dF0d7C9034']
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