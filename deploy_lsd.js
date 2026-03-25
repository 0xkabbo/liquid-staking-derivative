const hre = require("hardhat");

async function main() {
  const StakingPool = await hre.ethers.getContractFactory("StakingPool");
  const pool = await StakingPool.deploy();

  await pool.waitForDeployment();
  const poolAddr = await pool.getAddress();
  const lsdAddr = await pool.token();

  console.log("LSD Protocol Deployed:");
  console.log(`- Staking Pool: ${poolAddr}`);
  console.log(`- lsdToken (lsETH): ${lsdAddr}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
