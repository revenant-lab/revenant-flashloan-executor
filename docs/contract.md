# Revenant Flashloan Executor

> ⚡ Advanced, AI-compatible smart contract for executing high-throughput flashloan-based MEV strategies, including arbitrage, multi-hop DEX routing, and protocol liquidations.

---

## 🧠 Overview

The **Revenant Flashloan Executor** is a high-performance on-chain engine that simulates and executes profitable flashloan strategies across decentralized exchanges (DEXs) and lending protocols. Designed for **MEV**, **arbitrage**, and **liquidation hunting**, it enables rapid evaluation and atomic execution of multi-step strategies, including GPT-generated custom logic.

It supports **Uniswap V2/V3**, **Curve**, **Radiant**, and **Aave V3**, with modular router injection, batch simulation tools, revert trace events, and gas-aware reporting for both real and simulated executions.

---

## 🚀 Features

| Capability                         | Description |
|------------------------------------|-------------|
| 🏦 Flashloan Support               | Fully integrated with Aave V3 and Radiant protocols |
| 🔁 Arbitrage Engine                | Multi-hop DEX arbitrage with `simulateRecklessArb` and `executeLocalArb` |
| 🧪 Liquidation Engine              | Simulate and execute user liquidations via Aave/Radiant |
| 🤖 GPT-AI Routing Compatible       | Clean encoded parameter structure for off-chain GPT route generation |
| 📦 Batch Strategy Testing          | Simulate many routes/liquidations in one call (`tryMultiple*`) |
| 🔀 Modular DEX Integration         | Supports V2, V3, and Curve swaps via `setDexRouter(...)` |
| 📊 Gas + Profit Tracking           | Every route logs gas used, net profit, and failure reasons |
| 🧱 Internal Call Dispatcher        | `doCustomExecution()` allows low-level multistep strategy execution |
| 🔐 Owner-Only Access               | All critical functions gated via `onlyOwner` |

---

## 🏗️ Architecture

- Flashloan entrypoint: `executeOperation(...)`
- Custom logic dispatcher: `doCustomLogic(...)`
- Swap engine: `performSwap(...)`, `simulateSwap(...)`
- Arb simulation/execution: `simulateRecklessArb(...)`, `executeLocalArb(...)`
- Liquidation logic: `simulateLiquidation(...)`, `executeLiquidation(...)`
- Batch testing: `tryMultipleArbs(...)`, `tryMultipleLiquidations(...)`
- Strategy injection: `setDexRouter(...)`
- View access: `getUserHealthFactorDynamic(...)`

---

## 🧬 Data Structures

```solidity
struct SimulationResult {
  bool success;
  int256 netProfit;
  uint256 gasUsed;
  address[] tokensInvolved;
  bytes32[] steps;
}

struct LiquidationResult {
  bool success;
  uint256 gasUsed;
  string reason;
}

enum DexType {
  V2,
  V3,
  CURVE
}
````

---

## 📤 Example Use Cases

### ✅ Arbitrage Simulation

```solidity
simulateRecklessArb(
  ["Camelot", "UniswapV2"],
  [WETH, ARB, WETH],
  5 ether
);
```

### ✅ Liquidation Execution

```solidity
executeLiquidation(
  userAddress,
  0xDebtAsset,
  0.5 ether
);
```

### ✅ Flashloan Strategy Bundle

```solidity
executeReckless(
  [WETH],        // flashloan token
  [5 ether],     // amount
  [0],           // AAVE mode
  ["Camelot", "UniswapV2"],
  [WETH, ARB, WETH]
);
```

---

## 🧠 AI Integration

This contract is designed to integrate seamlessly with off-chain AI agents (like GPT-4o). Suggested modules include:

* `gptRouter.js`: Generates profitable `dexes`, `tokens` arrays
* `simulateBundle.js`: Runs dry-runs on multiple bundles
* `traceReverts.js`: Analyzes reasons for failures via event logs
* `watchdog.js`: Monitors on-chain status of executions

Events like `FlashExecutionSummary`, `RecklessRouteLog`, `StepOutcome`, and `LiquidationSimResult` are intended for indexing by AI to learn and optimize execution.

---

## 🔒 Security

* `onlyOwner` modifiers protect all critical execution functions.
* Internal `require(msg.sender == address(this))` checks block external abuse.
* All flashloan funds must be returned atomically — enforced by pool contracts.
* Simulations are performed **off-chain or dry-run** to avoid loss.
* No upgradability (by design) — reducing proxy-based attack surface.

---

## 🔧 Deployment & Configuration

1. Deploy with constructor injecting:

   * Lending pool address (Aave or Radiant)
   * Data provider
   * Curve router

2. Register supported routers:

```solidity
setDexRouter("UniswapV2", 0xYourRouter, DexType.V2);
setDexRouter("Curve", 0xCurveRouter, DexType.CURVE);
```

3. Call `executeReckless(...)` with encoded strategy path, or use `doCustomExecution(...)` with a bundled strategy.

---

## 📊 Events

| Event                   | Description                                            |
| ----------------------- | ------------------------------------------------------ |
| `FlashExecutionSummary` | High-level result with gas used, profit, revert reason |
| `RecklessRouteLog`      | Logs DEX + token path, profit, gas, success/fail       |
| `StepOutcome`           | Per-step label + outcome for tracing complex bundles   |
| `LiquidationSimResult`  | Dry-run liquidation result                             |
| `LiquidationExecution`  | Real liquidation trace                                 |

---

## 📈 Project Value

* **Designed for MEV ecosystems**
* **AI-agent compatible**
* **Production-ready**
* **Highly modular**
* **Maximally extensible**
* **Built for scale and reuse**

---

## 📜 License

MIT

---

## 👨‍💻 Author

Built with ❤️ by [@revenant-lab](https://github.com/revenant-lab) — combining AI, DeFi, and advanced execution logic into battle-tested contracts for modern on-chain strategy engines.

