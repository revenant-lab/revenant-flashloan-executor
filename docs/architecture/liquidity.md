# 📊 Liquidity Snapshot Modules — Aave & Radiant

## Overview

These modules continuously fetch **live liquidity availability** from:

* **Aave V3** (on Arbitrum)
* **Radiant Capital** (on Arbitrum)

They output structured JSON snapshots into your bot’s data directory, updating every loop.
This data is not just for display — it **directly powers** our AI-driven master controller (`runtime/ruthlessStrategist.js` & `runtime/control.js`).

---

## 🚀 Purpose in the Revenant Stack

Most MEV bots hardcode their flashloan amount like this:

```js
loanAmount: process.env.AMOUNT || "1000"
```

That’s static, brittle, and guaranteed to miss optimal profits.

**Revenant** does it differently:

1. **Measure available liquidity each cycle**
2. **Pass that to the strategist AI**
3. **Dynamically select the loan size** — adapting in real time to market depth

---

## 🔥 How It Works

**Flowchart — Liquidity to Execution**

<pre> ```mermaid flowchart LR A[Fetch Aave Liquidity] --> D[Save to liquiditySnapshot.json] B[Fetch Radiant Liquidity] --> D D --> E[Feed into ruthlessStrategist.js] E --> F{AI Decision} F -->|Safe Mode| G[Execute Conservative Flashloan] F -->|Aggressive Mode| H[executeReckless()] G --> I[Trade Execution on DEXs] H --> I I --> J[Profit / Log Results] ``` </pre>

---

## 🧠 The AI Advantage

Unlike static bots, Revenant:

* **Thinks before acting**: GPT reroutes, adapts, learns from bad trades
* **Monitors health**: Escalates only when patterns show high ROI potential
* **Has a memory**: Uses `mevHits.json`, `failedRoutes.json` to bias future routing

---

## Example: Aggressive Mode Trigger

`runtime/ruthlessStrategist.js` watches liquidity data:

```js
if (availableLiquidity > lastCycleLiquidity * 1.5 && roiTrendPositive) {
    maybeGoRuthless();
}
```

When triggered:

```solidity
executeReckless(
    [WETH],
    [maxAvailableLoan],
    [0],
    dexSequence,
    tokenPath
);
```

---

## 📐 Architecture Context

**System Overview**

```mermaid
graph TD
    subgraph Data Layer
        L1[fetchAaveV3Liquidity.js]
        L2[fetchRadiantLiquidity.js]
        L1 --> LS[liquiditySnapshot.json]
        L2 --> LS
    end

    subgraph AI Strategy Layer
        S1[ruthlessStrategist.js]
        S2[biasedRouter.js]
        S3[GPT-4o Adaptive Personas]
        LS --> S1
        S2 --> S1
        S3 --> S1
    end

    subgraph Execution Layer
        E1[FlashExecutor.sol]
        E2[AdvancedExecutor.sol]
        E3[LiquidationExecutor.sol]
        S1 --> E1
        S1 --> E2
        S1 --> E3
    end

    subgraph Monitoring & Feedback
        M1[mevHits.json]
        M2[failedRoutes.json]
        M3[traceReverts.js]
        E1 --> M1
        E1 --> M2
        E1 --> M3
        M1 --> S1
        M2 --> S1
    end
```

---

## 📌 Vision

This is **not** a fork-and-pray bot.
It’s an **adaptive, modular, AI-driven trading engine** that:

* Reacts to *real liquidity conditions*
* Adjusts its own risk tolerance
* Evolves its routing strategies over time

---
