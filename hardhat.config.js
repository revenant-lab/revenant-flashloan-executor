// hardhat.config.js
// ----------------------------------------
// Revenant Flashloan Executor – Hardhat Configuration
// ----------------------------------------

import { config as dotenvConfig } from 'dotenv';
import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-abi-exporter';

dotenvConfig();

const ARB_RPC_URL = process.env.ARBITRUM_RPC_URL || '';
const PRIVATE_KEY = process.env.PRIVATE_KEY || '';
const ARBISCAN_API_KEY = process.env.ARBISCAN_API_KEY || '';

/** @type {HardhatUserConfig} */
const config = {
  solidity: {
    version: '0.8.20',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },
  networks: {
    arbitrum: {
      url: ARB_RPC_URL,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
      chainId: 42161,
      allowUnlimitedContractSize: true,
    },
    localhost: {
      allowUnlimitedContractSize: true,
      gasPrice: 50_000_000_000n,
      chainId: 42161,
    },
    hardhat: {
      allowUnlimitedContractSize: true,
      chainId: 42161,
    },
  },
  abiExporter: {
    path: './abi',
    clear: true,
    flat: true,
    spacing: 2,
    pretty: true,
  },
  etherscan: {
    apiKey: {
      arbitrumOne: ARBISCAN_API_KEY,
    },
  },
};

export default config;

