// scripts/runRadiantFlashloan.js

/**
 * 🚀 Standalone Radiant Flashloan Runner
 *
 * This script initiates a flashloan on the Radiant Capital protocol
 * through the RevenantCoreExecutorVI contract.
 *
 * It fetches contract data using Hardhat artifacts, builds the interface,
 * connects to the chain via QuickNode RPC, and triggers `executeRadiantFlashLoan`.
 *
 * Usage:
 *   1. Set up `.env` with:
 *        QUICKNODE_RPC_API=
 *        PRIVATE_KEY=
 *        REVENANT_CORE_EXECUTORVI=
 *   2. Compile contracts: `npx hardhat compile`
 *   3. Run: `node scripts/runRadiantFlashloan.js`
 */

const { ethers, Interface } = require("ethers");
require("dotenv").config();
const fs = require("fs");
const path = require("path");

// 🔐 Load env vars from .env file
const {
  QUICKNODE_RPC_API,
  REVENANT_CORE_EXECUTORVI,
  PRIVATE_KEY
} = process.env;

async function main() {
  // ✅ Ensure all required .env values are provided
  if (!QUICKNODE_RPC_API || !REVENANT_CORE_EXECUTORVI || !PRIVATE_KEY) {
    throw new Error("❌ Missing .env values: QUICKNODE_RPC_API, REVENANT_CORE_EXECUTORVI, PRIVATE_KEY");
  }

  // 📦 Load ABI directly from Hardhat artifact
  const abiPath = path.join(__dirname, "../artifacts/contracts/RevenantCoreExecutorVI.sol/RevenantCoreExecutorVI.json");
  const artifact = JSON.parse(fs.readFileSync(abiPath, "utf8"));
  const abi = artifact.abi;

  // 🧠 Build contract interface (useful for printing/debugging)
  const iface = new Interface(abi);

  // 🔌 Connect to Ethereum-compatible chain using QuickNode RPC
  const provider = new ethers.JsonRpcProvider(QUICKNODE_RPC_API);

  // 🔏 Create wallet signer from private key
  const signer = new ethers.Wallet(PRIVATE_KEY, provider);

  // 🔗 Connect to deployed RevenantCoreExecutorVI contract
  const executor = new ethers.Contract(REVENANT_CORE_EXECUTORVI, iface, signer);

  // 💵 Token and amount to borrow (USDC on Arbitrum)
  const USDC = "0xaf88d065e77c8cc2239327c5edb3a432268e5831";
  const amount = ethers.parseUnits("10", 6); // 10 USDC (USDC has 6 decimals)

  console.log(`🚀 Starting Radiant flashloan for ${amount} USDC`);

  // ⚙️ Trigger flashloan via RevenantCoreExecutorVI
  const tx = await executor.executeRadiantFlashLoan(
    [USDC],        // token addresses
    [amount],      // loan amounts
    "0x"           // encoded execution data (empty for test)
  );

  console.log(`⏳ TX sent: ${tx.hash}`);

  // ✅ Wait for confirmation
  const receipt = await tx.wait();
  console.log(`✅ Flashloan confirmed in tx: ${receipt.transactionHash}`);
}

// 🧯 Catch and log errors clearly
main().catch((err) => {
  console.error("❌ Radiant Flashloan failed:", err);
  process.exit(1);
});

