// scripts/deployRevenantExecutor.js

/**
 * 🏗️ Deploy RevenantCoreExecutorVI
 *
 * This deployment script:
 *   - Deploys the RevenantCoreExecutorVI contract
 *   - Initializes it with Aave V3 provider and profit token address
 *
 * 📄 .env variables required:
 *   - AAVE_POOL_PROVIDER_ADDRESS: Address of Aave V3 PoolAddressesProvider
 *   - PROFIT_TOKEN: Token in which MEV/arb profit will be taken (e.g., USDC)
 *
 * 📌 Usage:
 *   npx hardhat run scripts/deployRevenantExecutor.js --network arbitrum
 */

require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  // 🔐 Load deployment parameters from .env
  const providerAddr = process.env.AAVE_POOL_PROVIDER_ADDRESS;
  const profitToken = process.env.PROFIT_TOKEN;

  if (!providerAddr || !profitToken) {
    throw new Error("❌ Missing AAVE_POOL_PROVIDER_ADDRESS or PROFIT_TOKEN in .env");
  }

  console.log("🚀 Deploying RevenantCoreExecutorVI...");

  // 🏗️ Load and deploy contract
  const RevenantCoreExecutorVI = await ethers.getContractFactory("RevenantCoreExecutorVI");
  const executor = await RevenantCoreExecutorVI.deploy();
  await executor.waitForDeployment();

  console.log("✅ Deployed at:", executor.target);

  // ⚙️ Call initialize() to configure contract post-deployment
  const initTx = await executor.initialize(providerAddr, profitToken);
  await initTx.wait();

  console.log("✅ Initialized with Aave provider and profit token:");
  console.log("   - AAVE_POOL_PROVIDER_ADDRESS:", providerAddr);
  console.log("   - PROFIT_TOKEN:", profitToken);
}

// 🧯 Error handling
main().catch((error) => {
  console.error("❌ Deployment failed:", error);
  process.exitCode = 1;
});

