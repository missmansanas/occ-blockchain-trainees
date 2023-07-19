const hre = require("hardhat");

async function main() {
  const MyContract = await hre.ethers.deployContract("MyToken", [
    "0x7B41c0C881A0c1cd428983a8FE20C099053FB4f7"
  ]);

  await MyContract.waitForDeployment();
  console.log(`Located at ${MyContract.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//0xE5f2861262a0C1dF024ffbE6C427A49316E072e1