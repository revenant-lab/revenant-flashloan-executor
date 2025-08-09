require("dotenv").config();
const { ethers } = require("ethers");

// --- ✅ Load Environment Variables ---
const EXECUTOR_ADDRESS = process.env.REVENANT_CORE_EXECUTORVI;
const RPC_URL = process.env.QUICKNODE_RPC_API || process.env.RPC_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RADIANT_POOL = process.env.RADIANT_POOL;

// --- ✅ Contracts + Configuration ---
const ROUTER_ABI = [
  "function setDexRouter(string name, address router, uint8 dtype) external",
];
const RADIANT_ABI = [
  "function setRadiantPool(address _radiant) external",
];

// ✅ Replace or extend this list as needed
const DEX_CONFIG = [
  {
    name: "UniswapV2",
    address: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506", // SushiSwap (UniswapV2 fork) on Arbitrum
    type: 0, // V2
  },
  {
    name: "UniswapV3",
    address: "0xE592427A0AEce92De3Edee1F18E0157C05861564", // Uniswap V3 router
    type: 1, // V3
  },
  {
    name: "Curve",
    address: "0x2191718CD32d02B8E60BAdFFeA33E4B5DD9A0A0D", // Curve router example
    type: 2, // Curve
  },
];

async function main() {
  // --- 🛡️ Sanity Checks ---
  if (!RPC_URL || !PRIVATE_KEY || !EXECUTOR_ADDRESS) {
    throw new Error("❌ Missing required environment variables: RPC_URL, PRIVATE_KEY, EXECUTOR_ADDRESS");
  }

  const provider = new ethers.JsonRpcProvider(RPC_URL);
  const wallet = new ethers.Wallet(PRIVATE_KEY, provider);

  // --- 🔁 Register DEX Routers ---
  const executorWithRouterABI = new ethers.Contract(EXECUTOR_ADDRESS, ROUTER_ABI, wallet);

  for (const dex of DEX_CONFIG) {
    console.log(`🔧 Registering DEX: ${dex.name} (${dex.address}) with type ${dex.type}`);
    try {
      const tx = await executorWithRouterABI.setDexRouter(dex.name, dex.address, dex.type);
      console.log(`📤 Tx sent: ${tx.hash}`);
      await tx.wait();
      console.log(`✅ Successfully set ${dex.name}`);
    } catch (err) {
      console.error(`❌ Failed to set ${dex.name}: ${err.message}`);
    }
  }

  // --- 🔁 Register Radiant Pool ---
  if (RADIANT_POOL) {
    try {
      const executorWithRadiantABI = new ethers.Contract(EXECUTOR_ADDRESS, RADIANT_ABI, wallet);
      console.log(`🔧 Setting Radiant pool to ${RADIANT_POOL}...`);
      const tx = await executorWithRadiantABI.setRadiantPool(RADIANT_POOL);
      console.log(`📤 Tx sent: ${tx.hash}`);
      await tx.wait();
      console.log(`✅ Radiant pool set successfully.`);
    } catch (err) {
      console.error(`❌ Failed to set Radiant pool: ${err.message}`);
    }
  } else {
    console.log("⚠️  Skipping Radiant pool: RADIANT_POOL not defined in .env");
  }
}

main().catch((err) => {
  console.error("❌ Script execution failed:", err.message);
});

