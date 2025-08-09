# 🛠️ Revenant Executor Setup Guide

This guide walks you through the full initialization pipeline for deploying and configuring the `RevenantCoreExecutorVI` smart contract, used by the Revenant Flashloan Executor bot.

---

## 📦 Prerequisites

- Node.js + npm
- Hardhat
- `.env` file with required environment variables (see below)
- A private key with deployment permissions on Arbitrum (or your chosen network)

---

## 🔐 Required .env Variables

```env
# Deployment
AAVE_POOL_PROVIDER_ADDRESS=0xYourAaveV3Provider
PROFIT_TOKEN=0xTokenToTakeProfitIn

# Setup
REVENANT_CORE_EXECUTORVI=0xToBeFilledAfterDeployment
RADIANT_POOL=0xRadiantPoolAddress
QUICKNODE_RPC_API=https://arbitrum.node.url
PRIVATE_KEY=0xYourPrivateKey
````

---

## 🚧 Step 1: Compile Contracts

Ensure all contracts compile cleanly:

```bash
npx hardhat compile
```

---

## 🚀 Step 2: Deploy RevenantCoreExecutorVI

Run the deployment script:

```bash
npx hardhat run scripts/deployRevenantExecutor.js --network arbitrum
```

### What this does:

* Deploys the `RevenantCoreExecutorVI` contract
* Initializes it with:

  * `AAVE_POOL_PROVIDER_ADDRESS` (Aave V3 PoolAddressesProvider)
  * `PROFIT_TOKEN` address (e.g., USDC)
* Outputs the deployed contract address — copy this into your `.env` as `REVENANT_CORE_EXECUTORVI`.

> 📌 This script requires the `.env` variables to be set correctly, or it will throw.

---

## ⚙️ Step 3: Setup DEX Routers & Radiant Pool

Once deployed, run the setup script to register supported DEX routers and the Radiant lending pool:

```bash
node scripts/setupExecutor.js
```

### What this does:

* Calls `setDexRouter()` on the executor for each supported DEX:

  * UniswapV2
  * UniswapV3
  * Curve
* Optionally sets `setRadiantPool()` if `RADIANT_POOL` is defined in your `.env`.

> You can add/remove DEXes in the `DEX_CONFIG` array in `setupExecutor.js`.

---

## ✅ Done

Your `RevenantCoreExecutorVI` contract is now ready to receive and execute MEV instructions.

Next steps:

* 🧠 Integrate with `gptRouter.js` for AI routing
* 🧪 Simulate bundles with `simulateBundle.js`
* 🚀 Bundle and send with `bundleSender.js`

````

---

### 🧠 Breakdown of Prior Actions in `scripts/deployRevenantExecutor.js`

```js
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
````

This script is responsible for:

1. **Deploying the Executor Contract**:

   * It uses Hardhat’s deploy mechanism to launch the `RevenantCoreExecutorVI` contract on-chain.

2. **Constructor Initialization**:

   * Upon deployment, it **injects the Aave Pool provider** (e.g., `0x…PoolAddressesProvider`) and the **profit token** (e.g., USDC) into the contract’s constructor.
   * These are used for:

     * Querying borrowable tokens via Aave V3
     * Ensuring profits from MEV/flashloan strategies are taken in a stable token.

3. **Outputting the Deployed Address**:

   * The script logs the deployed address — this should then be copied into the `.env` file under `REVENANT_CORE_EXECUTORVI`.

This script **must run before** any initialization or setup, because `setupExecutor.js` assumes that the contract already exists and is ready to receive router/pool registrations.

