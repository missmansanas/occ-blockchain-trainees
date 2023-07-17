const { ethers } = require("hardhat");

async function main() {
  const tokenSaleContract = await hre.ethers.deployContract("TokenSale", [
    "0x09b52ce73a612f7e90a8885eb1043a3ae239bb61",
  ]);
  await tokenSaleContract.waitForDeployment();
  console.log(`Contract deployed to : ${tokenSaleContract.target}`);
}
main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error(err);
    process.exit(1);
  });
//0x49BEB7437e400EAFF102A65616e6ad4CDa8bFE32
