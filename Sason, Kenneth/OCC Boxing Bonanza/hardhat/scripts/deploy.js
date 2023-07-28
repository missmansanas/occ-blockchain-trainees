const hre = require("hardhat");

async function main() {
  const Boxing = await hre.ethers.deployContract("BoxingBonanza");
  await Boxing.waitForDeployment();
  console.log(`Located at ${Boxing.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
//0x0620F46F39f74d708b0B4adDE057de96A2F2fe1c
