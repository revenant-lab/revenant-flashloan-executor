// scripts/fetchRadiantLiquidity.ethers.mjs
// ----------------------------------------
// Fetches Radiant V2 liquidity + debt data from Arbitrum
// Saves a snapshot to /logs/liquidityRadiantSnapshot.json
// ----------------------------------------

import { config } from 'dotenv';
config();

import fs from 'fs';
import path from 'path';
import { ethers } from 'ethers';
import { fileURLToPath } from 'url';

// ----------------------------------------
// 1. Path setup (so we can use __dirname in ES modules)
// ----------------------------------------
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ----------------------------------------
// 2. Radiant contract constants (Arbitrum)
// Swap these out for other networks if needed
// ----------------------------------------
const UI_POOL_DATA_PROVIDER = '0x56D4b07292343b149E0c60c7C41B7B1eEefdD733';
const POOL_ADDRESS_PROVIDER = '0x454a8daf74b24037ee2fa073ce1be9277ed6160a';

// ----------------------------------------
// 3. RPC provider
// Defaults to public Arbitrum RPC if .env not set
// ----------------------------------------
const RPC_URL = process.env.RPC_URL || 'https://arb1.arbitrum.io/rpc';
const provider = new ethers.JsonRpcProvider(RPC_URL);

// ----------------------------------------
// 4. Symbol → decimals mapping
// (Tokens without a mapping default to 18 decimals)
// ----------------------------------------
const decimalsMap = {
  WBTC: 8,
  WETH: 18,
  USDC: 6,
  'USD₮0': 6, // USDT
  wstETH: 18,
  weETH: 18,
  ARB: 18,
  rETH: 18,
  LINK: 18,
};

// ----------------------------------------
// 5. ABI fragment for Radiant's getReservesData()
// Minimal — only what's needed for this script
// ----------------------------------------
const abi = [{
  name: 'getReservesData',
  type: 'function',
  stateMutability: 'view',
  inputs: [{ name: 'provider', type: 'address' }],
  outputs: [
    {
      components: [
        { name: 'underlyingAsset', type: 'address' },
        { name: 'name', type: 'string' },
        { name: 'symbol', type: 'string' },
        { name: 'decimals', type: 'uint8' },
        { name: 'baseLTVasCollateral', type: 'uint256' },
        { name: 'reserveLiquidationThreshold', type: 'uint256' },
        { name: 'reserveLiquidationBonus', type: 'uint256' },
        { name: 'reserveFactor', type: 'uint256' },
        { name: 'usageAsCollateralEnabled', type: 'bool' },
        { name: 'borrowingEnabled', type: 'bool' },
        { name: 'stableBorrowRateEnabled', type: 'bool' },
        { name: 'isActive', type: 'bool' },
        { name: 'isFrozen', type: 'bool' },
        { name: 'liquidityIndex', type: 'uint256' },
        { name: 'variableBorrowIndex', type: 'uint256' },
        { name: 'liquidityRate', type: 'uint256' },
        { name: 'variableBorrowRate', type: 'uint256' },
        { name: 'stableBorrowRate', type: 'uint256' },
        { name: 'lastUpdateTimestamp', type: 'uint40' },
        { name: 'aTokenAddress', type: 'address' },
        { name: 'stableDebtTokenAddress', type: 'address' },
        { name: 'variableDebtTokenAddress', type: 'address' },
        { name: 'interestRateStrategyAddress', type: 'address' },
        { name: 'availableLiquidity', type: 'uint256' },
        { name: 'totalPrincipalStableDebt', type: 'uint256' },
        { name: 'averageStableRate', type: 'uint256' },
        { name: 'stableDebtLastUpdateTimestamp', type: 'uint40' },
        { name: 'totalScaledVariableDebt', type: 'uint256' },
        { name: 'priceInMarketReferenceCurrency', type: 'uint256' },
        { name: 'priceOracle', type: 'address' },
        { name: 'variableRateSlope1', type: 'uint256' },
        { name: 'variableRateSlope2', type: 'uint256' },
        { name: 'stableRateSlope1', type: 'uint256' },
        { name: 'stableRateSlope2', type: 'uint256' }
      ],
      name: '',
      type: 'tuple[]'
    },
    {
      components: [
        { name: 'marketReferenceCurrencyUnit', type: 'uint256' },
        { name: 'marketReferenceCurrencyPriceInUsd', type: 'uint256' },
        { name: 'networkBaseTokenPriceInUsd', type: 'uint256' },
        { name: 'networkBaseTokenPriceDecimals', type: 'uint8' }
      ],
      name: '',
      type: 'tuple'
    }
  ]
}];

// ----------------------------------------
// 6. Main function — fetch + save reserves
// ----------------------------------------
export async function fetchRadiantReserves() {
  const contract = new ethers.Contract(UI_POOL_DATA_PROVIDER, abi, provider);

  // Call contract to get reserves
  const [reserves] = await contract.getReservesData(POOL_ADDRESS_PROVIDER);

  // Format into clean JSON structure
  const allReserves = reserves.map(r => {
    const symbol = r.symbol;
    const decimals = decimalsMap[symbol] ?? 18;
    return {
      symbol,
      availableLiquidity: parseFloat(ethers.formatUnits(r.availableLiquidity, decimals)),
      totalVariableDebt: parseFloat(ethers.formatUnits(r.totalScaledVariableDebt, decimals)),
      totalStableDebt: parseFloat(ethers.formatUnits(r.totalPrincipalStableDebt, decimals)),
    };
  });

  // Save snapshot to /logs
  const savePath = path.join(__dirname, "../logs/liquidityRadiantSnapshot.json");
  fs.writeFileSync(savePath, JSON.stringify(allReserves, null, 2));

  return allReserves;
}

// ----------------------------------------
// 7. CLI mode — run directly
// ----------------------------------------
if (import.meta.url === `file://${process.argv[1]}`) {
  fetchRadiantReserves()
    .then(res => {
      console.log(`✅ Radiant snapshot saved (${res.length} reserves)\n`);
      for (const r of res) {
        console.log(`🔹 ${r.symbol}`);
        console.log(`   - Liquidity: ${r.availableLiquidity}`);
        console.log(`   - Variable Debt: ${r.totalVariableDebt}`);
        console.log(`   - Stable Debt: ${r.totalStableDebt}\n`);
      }
    })
    .catch(err => {
      console.error("❌ Error:", err.message);
    });
}

