const hre = require("hardhat");

async function main() {
  const exchangeContract = await hre.ethers.deployContract(
    "Exchange",
    ['0x5148c14FB819240D092fCd0Aa6A6c526B9609067']
  );

  await exchangeContract.waitForDeployment();

  console.log('Contract deployed to: ' + exchangeContract.target);
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  })

// Contract deployed to: 0x97C50037D8834Ca0F0F277eA5229361F2DA2f0EB