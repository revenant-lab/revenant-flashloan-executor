````
---
title: 📊 Liquidity Snapshot Modules — Aave & Radiant
---

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
````

That’s static, brittle, and guaranteed to miss optimal profits.

**Revenant** does it differently:

1. **Measure available liquidity each cycle**
2. **Pass that to the strategist AI**
3. **Dynamically select the loan size** — adapting in real time to market depth

---

## 🔥 How It Works

1️⃣ **Snapshot** — Scripts query Aave & Radiant lending pools
2️⃣ **Store** — Save latest liquidity in `/logs/liquiditySnapshot.json`
3️⃣ **Feed AI** — Master strategist uses this in `runtime/ruthlessStrategist.js` & `runtime/control.js`
4️⃣ **Decide** — AI may:

* Play **safe** with a moderate loan size
* **Escalate** with `executeReckless()` in high-confidence conditions
* **Go full war-mode** with `maybeGoRuthless()` after poor ROI cycles

---

## 🧠 The AI Advantage

Unlike static bots, Revenant:

* **Thinks before acting**: GPT reroutes, adapts, learns from bad trades
* **Monitors health**: Escalates only when patterns show high ROI potential or recovery opportunities
* **Has a memory**: Uses `mevHits.json` and `failedRoutes.json` to bias future routing

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

| Layer              | Purpose                                               |
| ------------------ | ----------------------------------------------------- |
| Liquidity Fetchers | `fetchAaveV3Liquidity.js`, `fetchRadiantLiquidity.js` |
| Strategist AI      | Decides loan size & aggressiveness                    |
| Executors          | Perform trades, liquidations, multi-hop arbitrage     |
| Logging            | Tracks wins, fails, patterns                          |
| Simulation         | Dry-run routes before committing                      |

---

## 📌 Vision

This is **not** a fork-and-pray bot.
It’s an **adaptive, modular, AI-driven trading engine** that:

* Reacts to *real liquidity conditions*
* Adjusts its own risk tolerance
* Evolves its routing strategies over time

```

This will render cleanly in GitHub’s README/docs without YAML parsing errors.  

Do you want me to go ahead and make this the **final README section** for the Liquidity Snapshot module in your Revenant repo? That way it’s pre-seed investor–ready.
```

