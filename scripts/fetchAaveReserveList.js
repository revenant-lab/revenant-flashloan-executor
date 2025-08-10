/**
 * fetchAaveReservesList.js
 * ----------------------------------------
 * Fetches the list of reserve asset addresses from Aave on Arbitrum
 * using the UiPoolDataProvider contract.
 *
 * Purpose in repo:
 * - Used by scanners to know which tokens Aave supports for lending/borrowing.
 * - Acts as an input source for cross-protocol arb detection.
 * - Can be extended to pull available liquidity for each reserve.
 *
 * Output:
 * - logs/liquidityAaveReserves.json  → raw JSON array (machine-friendly)
 * - data/liquidityAaveReserves.jsonc → JSON with comments (human-friendly)
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

// Aave V3 contract addresses on Arbitrum
const UI_POOL_DATA_PROVIDER = '0x5c5228aC8BC1528482514aF3e27E692495148717'; // Aave's UiPoolDataProviderV3
const POOL_ADDRESS_PROVIDER = '0xa97684ead0e402dc232d5a977953df7ecbab3cdb'; // Aave's PoolAddressesProvider

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
 * Fetches Aave's reserve list.
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

    console.log(`✅ Found ${reserves.length} Aave reserves:`);
    reserves.forEach((token, i) => {
      console.log(`${i + 1}. ${token}`);
    });

    // Save raw snapshot
    const logsPath = path.join(__dirname, '../logs/liquidityAaveReserves.json');
    fs.writeFileSync(logsPath, JSON.stringify(reserves, null, 2));
    console.log(`💾 Saved raw snapshot → ${logsPath}`);

    // Save human-friendly JSONC
    const jsoncComment = [
      '// Aave reserve token addresses snapshot',
      '// Retrieved: ' + new Date().toISOString(),
      '// Network: Arbitrum',
      '// Usage: Input to liquidity scanners / MEV strategies',
      JSON.stringify(reserves, null, 2),
    ].join('\n');

    const dataPath = path.join(__dirname, '../data/liquidityAaveReserves.jsonc');
    fs.writeFileSync(dataPath, jsoncComment);
    console.log(`💾 Saved human-friendly JSONC → ${dataPath}`);

    return reserves;
  } catch (error) {
    console.error('❌ Error fetching Aave reserves:', error);
    return [];
  }
}

// Run if called directly from CLI
if (process.argv[1] === new URL(import.meta.url).pathname) {
  fetchReserves();
}

export default fetchReserves;

