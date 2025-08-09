// scripts/fetchAaveV3Liquidity.js
/**
 * Fetch liquidity data from Aave V3 on an L2 rollup (currently Arbitrum).
 * 
 * This script:
 *   1. Connects to the Aave V3 UiPoolDataProvider contract.
 *   2. Fetches reserve data (token liquidity, borrow caps, etc.).
 *   3. Outputs to console and saves a JSON snapshot to /logs.
 * 
 * ⚡ Current default: Arbitrum One (L2 rollup)
 * 🔄 To switch networks: update RPC_URL + contract addresses in .env or config.
 */

const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");
require("dotenv").config(); // Load environment variables from .env

/**
 * ------------------------------
 *  CONFIGURATION
 * ------------------------------
 * NOTE: These addresses are for Arbitrum Aave V3.
 * If you switch to another network, change them to the correct ones.
 */
const UI_POOL_ADDRESS =
  process.env.UI_POOL_ADDRESS || "0x5c5228aC8BC1528482514aF3e27E692495148717"; // Aave V3 UiPoolDataProvider (Arbitrum)
const POOL_PROVIDER_ADDRESS =
  process.env.POOL_PROVIDER_ADDRESS || "0xa97684ead0e402dc232d5a977953df7ecbab3cdb"; // Aave PoolAddressesProvider
const RPC =
  process.env.RPC_URL || "https://arb1.arbitrum.io/rpc"; // Default to Arbitrum RPC if .env is missing

/**
 * ------------------------------
 *  LOCAL FILE IMPORTS
 * ------------------------------
 * ABI: Minimal ABI for UiPoolDataProviderV3
 * Token Metadata: Symbol, decimals for known tokens
 */
const abi = require("../abi/UiPoolDataProviderV3.min.abi.json");
const tokenMetadata = require("../config/tokenMetadata.json");

/**
 * ------------------------------
 *  ETHERS PROVIDER & CONTRACT
 * ------------------------------
 */
const provider = new ethers.JsonRpcProvider(RPC);
const contract = new ethers.Contract(UI_POOL_ADDRESS, abi, provider);

/**
 * Map lowercase token addresses → token metadata for quick lookup.
 */
const SYMBOL_LOOKUP = Object.keys(tokenMetadata).reduce((acc, addr) => {
  acc[addr.toLowerCase()] = tokenMetadata[addr];
  return acc;
}, {});

/**
 * Fetch reserves from Aave V3 UiPoolDataProvider.
 * @returns {Promise<Array>} Array of reserve objects with liquidity info.
 */
async function fetchReserves() {
  const [reserves] = await contract.getReservesData(POOL_PROVIDER_ADDRESS);
  const output = [];

  for (const r of reserves) {
    const meta = SYMBOL_LOOKUP[r.underlyingAsset.toLowerCase()];
    if (!meta) continue; // Skip tokens not in metadata

    const liquidity = Number(
      ethers.formatUnits(r.availableLiquidity, meta.decimals)
    );

    output.push({
      symbol: meta.symbol || r.symbol,
      address: r.underlyingAsset,
      availableLiquidity: liquidity,
      flashLoanEnabled: r.flashLoanEnabled,
      borrowCap: r.borrowCap?.toString(),
      debtCeiling: r.debtCeiling?.toString(),
      decimals: meta.decimals,
    });
  }

  return output;
}

/**
 * CLI entry point.
 * Optional arguments: pass token symbols to filter results.
 * Example:
 *   node scripts/fetchAaveV3Liquidity.js WETH USDC
 */
async function main() {
  const symbols = process.argv.slice(2).map((s) => s.toUpperCase());
  const allReserves = await fetchReserves();

  const filtered = symbols.length
    ? allReserves.filter((r) => symbols.includes(r.symbol))
    : allReserves;

  for (const r of filtered) {
    const flashIcon = r.flashLoanEnabled ? "⚡" : " ";
    console.log(`\n${flashIcon} ${r.symbol} Info`);
    console.log(`  Liquidity     : ${r.availableLiquidity.toFixed(6)} ${r.symbol}`);
    console.log(`  Borrow Cap    : ${r.borrowCap || "N/A"}`);
    console.log(`  Debt Ceiling  : ${r.debtCeiling || "N/A"}`);
  }

  // Save a full liquidity snapshot for analysis
  const logsDir = path.join(__dirname, "../logs");
  if (!fs.existsSync(logsDir)) fs.mkdirSync(logsDir);

  fs.writeFileSync(
    path.join(logsDir, "liquidityAaveSnapshot.json"),
    JSON.stringify(allReserves, null, 2)
  );

  console.log(`\n✅ Snapshot saved to logs/liquidityAaveSnapshot.json`);
}

// Run if executed directly from CLI
if (require.main === module) {
  main().catch((err) => {
    console.error("❌ Error fetching liquidity data:", err);
    process.exit(1);
  });
}

// Export for use in other scripts
module.exports = {
  fetchReserves,
};

