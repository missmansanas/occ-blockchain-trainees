const hre = require("hardhat");

async function main() {
  const exchangeContract = await hre.ethers.deployContract(
	"Exchange",
	['0x776C00afb4Df52fDe095A5c635dEBAA8dA3b413a']
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

  //Contract deployed to: 0xc225c101fF763e44560AD0aD78644A4C14fae0c6