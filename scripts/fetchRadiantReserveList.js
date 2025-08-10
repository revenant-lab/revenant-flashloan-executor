/**
 * fetchRadiantReservesList.js
 * ----------------------------------------
 * Fetches the list of reserve asset addresses from Radiant on Arbitrum
 * using the UiPoolDataProvider contract.
 *
 * Purpose in repo:
 * - Used by scanners to know which tokens Radiant supports for lending/borrowing.
 * - Acts as an input source for cross-protocol arb detection.
 * - Can be extended to pull available liquidity for each reserve.
 *
 * Output:
 * - logs/liquidityRadiantReserves.json  → raw JSON array (machine-friendly)
 * - data/liquidityRadiantReserves.jsonc → JSON with comments (human-friendly)
 *
 * Dependencies:
 *   npm install viem fs
 */

import { createPublicClient, http } from 'viem';
import { arbitrum } from 'viem/chains';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// Resolve __dirname for ES modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// RPC connection (public Arbitrum RPC)
const publicClient = createPublicClient({
  chain: arbitrum,
  transport: http('https://arb1.arbitrum.io/rpc'),
});

// Radiant contract addresses (UiPoolDataProvider + PoolAddressProvider)
const UI_POOL_DATA_PROVIDER = '0x56D4b07292343b149E0c60c7C41B7B1eEefdD733'; // same interface as Aave
const POOL_ADDRESS_PROVIDER = '0x454a8daf74b24037ee2fa073ce1be9277ed6160a'; // Radiant's core registry

// Minimal ABI for getReservesList(address provider) -> address[]
const abi = [
  {
    name: 'getReservesList',
    type: 'function',
    stateMutability: 'view',
    inputs: [{ name: 'provider', type: 'address' }],
    outputs: [{ name: '', type: 'address[]' }],
  },
];

/**
 * Fetches Radiant's reserve list.
 * @returns {Promise<string[]>} Array of token addresses.
 */
async function fetchReserves() {
  try {
    const reserves = await publicClient.readContract({
      address: UI_POOL_DATA_PROVIDER,
      abi,
      functionName: 'getReservesList',
      args: [POOL_ADDRESS_PROVIDER],
    });

    console.log(`✅ Found ${reserves.length} Radiant reserves:`);
    reserves.forEach((token, i) => {
      console.log(`${i + 1}. ${token}`);
    });

    // Save raw snapshot
    const logsPath = path.join(__dirname, '../logs/liquidityRadiantReserves.json');
    fs.writeFileSync(logsPath, JSON.stringify(reserves, null, 2));
    console.log(`💾 Saved raw snapshot → ${logsPath}`);

    // Save human-friendly JSONC
    const jsoncComment = [
      '// Radiant reserve token addresses snapshot',
      '// Retrieved: ' + new Date().toISOString(),
      '// Network: Arbitrum',
      '// Usage: Input to liquidity scanners / MEV strategies',
      JSON.stringify(reserves, null, 2),
    ].join('\n');

    const dataPath = path.join(__dirname, '../data/liquidityRadiantReserves.jsonc');
    fs.writeFileSync(dataPath, jsoncComment);
    console.log(`💾 Saved human-friendly JSONC → ${dataPath}`);

    return reserves;
  } catch (error) {
    console.error('❌ Error fetching Radiant reserves:', error);
    return [];
  }
}

// Run if called directly from CLI
if (process.argv[1] === new URL(import.meta.url).pathname) {
  fetchReserves();
}

export default fetchReserves;

