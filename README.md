# Revenant Flashloan Executor

**revenant-flashloan-executor** is an advanced AI-assisted, flashloan-based MEV bot engineered to extract on-chain profits through ultra-low-latency DeFi operations.  
It combines **Solidity**, **Hardhat**, **Node.js**, and **GPT-4o Turbo** logic to exploit atomic arbitrage, DEX inefficiencies, and liquidity vulnerabilities across EVM-compatible chains.

---

## 🧠 Core Features

- **Atomic Flashloan Arbitrage** — Executes profitable trades within a single transaction using flashloans.
- **AI-Driven Pathfinding (`gptRouter.js`)** — Dynamically selects token routes and DEX pairs using GPT logic.
- **Bundle Simulation (`simulateBundle.js`)** — Pre-checks bundle profitability and viability via Hardhat or Tenderly.
- **Flashbots Integration (`bundleSender.js`)** — Sends MEV bundles privately via Flashbots Protect.
- **TX Monitoring (`watchdog.js`)** — Tracks success/failure of each bundle in real time.
- **Revert Trace Analysis (`traceReverts.js`)** — Diagnoses failed transactions using Hardhat debug traces.
- **Fully Modular Architecture** — Each logic component is decoupled and production-ready.

---

## 🏗️ Modules

| Module              | Description                                                                 |
|---------------------|-----------------------------------------------------------------------------|
| `simulateBundle.js` | Simulates bundles with Hardhat or Tenderly to ensure execution success.     |
| `bundleSender.js`   | Submits raw bundles to Flashbots Relay using private key auth.              |
| `gptRouter.js`      | Uses AI to dynamically generate profitable token paths & route logic.       |
| `watchdog.js`       | Monitors live transaction status, logs tx hashes, reverts, and receipts.    |
| `traceReverts.js`   | Decodes and analyzes failing transactions via Hardhat’s `debug_trace`.      |

---

## ⚙️ Stack

- **Solidity** — Flashloan and MEV contracts
- **Hardhat** — Development, deployment, simulation
- **Node.js (ESM)** — Runtime orchestration
- **ethers.js v6** — On-chain interaction
- **Flashbots** — Private bundle execution (mainnet only)
- **GPT-4o Turbo** — Pathfinding, AI optimizations
- **Tenderly / Anvil** — Optional tracing/simulation layer

---

## 🔄 Execution Workflow

### Runtime Flow (Visual Graph)

```text
Mainnet / Arbitrum (Runtime Flow)

      ┌──────────────────────┐
      │  mempoolWatcher.js   │◄─────┐
      └──────────────────────┘      │ Mainnet only
                 ▼                  │
      ┌──────────────────────┐      │
      │    gptRouter.js      │◄─────┘
      └──────────────────────┘
                 ▼
      ┌──────────────────────┐
      │ simulateXXX.js       │     ← simulateBundle.js (mainnet) / simulateTx.js (arbitrum)
      └──────────────────────┘
                 ▼
      ┌──────────────────────┐
      │ Sender Module        │     ← bundleSender.js / rawTxSender.js
      └──────────────────────┘
                 ▼
      ┌──────────────────────┐
      │   watchdog.js        │
      └──────────────────────┘
````

Each module is **independently runnable** but can be wired together into a reactive execution pipeline.

---

## 🧬 Execution Modes

### 🔵 Ethereum Mainnet (Mempool + Flashbots)

* Classic MEV flow (backrun, frontrun, arb)
* Full mempool access with `mempoolWatcher.js`
* Bundle simulation via Hardhat or Tenderly
* Private inclusion via Flashbots (`bundleSender.js`)

### 🟣 Arbitrum (No Mempool Access)

* Sequencer hides mempool, no Flashbots
* MEV opportunities: traps, mispricing, liquidity drift
* Use `stateScanner.js` (WIP) to detect state anomalies
* Ultra-low latency raw TX push (`rawTxSender.js`)
* Simulations are stateless: use `simulateTx.js`

---

## 🚀 Usage

### Prerequisites

* Node.js v18+
* Hardhat
* RPC URL (e.g. Alchemy, Infura, QuickNode)
* [Flashbots auth key](https://docs.flashbots.net/flashbots-auction/searchers/advanced/rpc-auth)

### Install

```bash
git clone https://github.com/revenant-lab/revenant-flashloan-executor.git
cd revenant-flashloan-executor
npm install
```

### Configure

Create a `.env` file:

```env
PRIVATE_KEY=0x...
FLASHBOTS_AUTH_KEY=0x...
RPC_URL=https://...
```

### Run Modules

```bash
# AI route generation
node src/gptRouter.js

# Mainnet (Flashbots bundle)
node src/simulateBundle.js
node src/bundleSender.js

# Arbitrum (raw tx mode)
node src/simulateTx.js
node src/rawTxSender.js

# Shared
node src/watchdog.js
node src/traceReverts.js
```

---

## 📁 Directory Structure

```text
.
├── contracts/               # Solidity contracts
├── interfaces/              # Flashloan + Aave interfaces
├── src/
│   ├── mainnet/             # Flashbots-based modules
│   ├── arbitrum/            # Arbitrum raw tx modules
│   ├── gptRouter.js         # AI routing
│   ├── traceReverts.js      # Hardhat debugging
│   └── watchdog.js          # Tx monitor
├── scripts/                 # Deployment / test scripts
│   └── deployTestAaveV3Flashloan.js
├── test/
│   └── TestAaveFlashloan.test.js     # Unit test for aave V3 flashloan
├── .env                              # User-provided secrets
├── hardhat.config.js
├── README.md                         # Full repo description
└── package.json
```

---

## 🧪 Example Contracts

* `FlashloanExecutor.sol` — Main entrypoint for atomic arbitrage via flashloan.
* `TestAaveV3Flashloan.sol` — Minimal flashloan receiver (for testing).
* `IERC20.sol` — ERC20 interface
* `IPool.sol`, `IPoolAddressesProvider.sol`, etc. — Aave interfaces
* Spoofed LP / trap contracts (WIP for Arbitrum)


### Deploy Example Flashloan Contract

The repo includes a minimal working example of an Aave V3 flashloan using Solidity:

| File                          | Description                                          |
|-------------------------------|------------------------------------------------------|
| `contracts/TestAaveV3Flashloan.sol` | Minimal contract that borrows and repays via Aave V3 |
| `scripts/deployTestAaveV3.js`      | Deployment script (fork or live)                   |
| `test/TestAaveFlashloan.test.js`   | Mocha/Chai test to verify flashloan lifecycle      |

To test locally using Anvil:

```bash
anvil --fork-url $RPC_URL
npx hardhat test --network localhost

Or deploy directly to Arbitrum:

npx hardhat run scripts/deployTestAaveV3.js --network arbitrum
Note: Only use real networks if you understand the risks and gas costs involved.

---

## 🛠️ In Progress

* ✅ Modular Flashloan Contracts
* ✅ Flashbots / RawTx Dual Mode
* ✅ Revert Tracing via Hardhat
* 🛠️ Arbitrum State Scanner
* 🛠️ Liquidity Trap Logic
* 🛠️ AI Self-Optimizing Execution Loop
* 🛠️ GPT-agent integration (auto-rewrite routing logic on failures)

---

## 🧠 Powered By

* Revenant Lab — [revenant-lab.eth](https://github.com/revenant-lab)
* GPT-4o Turbo + Custom Prompt Engineering
* Hardhat, Tenderly, Flashbots, Anvil

---

## 📜 License

MIT © Revenant Lab
This project is experimental, for educational and research use only. Use at your own risk.

