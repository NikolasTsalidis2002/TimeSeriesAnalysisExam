# Time-Series Model Selection Decision Tree (Project Guideline)

## 🧭 Big Picture
You are analyzing a two-variable financial system (e.g., Stock Prices and Exchange Rates).  
Your workflow consists of:

1. **Determine stationarity and integration order**  
2. **Test for long-run relationships (cointegration)**  
3. **Determine endogeneity/exogeneity**  
4. **Choose the correct mean model**  
5. **Model volatility using GARCH**  

---

# 🌳 Decision Tree for Model Selection

## STEP 0 — Setup
- Select your variables (e.g., stock price SP_t, exchange rate ER_t).
- Decide whether to work in **levels** or **returns/log-differences**.

---

## STEP 1 — Stationarity & Integration Order  
Run ADF tests on each series.

### Question 1: Are the series stationary (I(0))?

---

## ✅ Branch 1: All variables are I(0)

### Question 2: Are variables endogenous or exogenous?

- **If both variables influence each other (endogenous)**  
  👉 Use **VAR in levels**

- **If X influences Y but not vice versa (X is exogenous)**  
  👉 Use **ADL (or ARDL)**  
  Y_t on lags of Y and X.

Then:
- Test VAR/ADL residuals for ARCH  
- If ARCH → **VAR-GARCH or ADL-GARCH**

---

## ❌ Branch 2: At least one variable is I(1)

Confirm both variables are I(1) (non‑stationary in levels, stationary in first difference).

---

## STEP 2 — Cointegration Test
Run Engle–Granger or Johansen test.

### Question 3: Are the variables cointegrated?

---

### ✅ Branch 2A: YES — There is cointegration

Series share a **long-run equilibrium relationship**.

### Question 4: Endogenous or exogenous?

- **If both variables endogenous**  
  👉 Use **VECM (Vector Error Correction Model)**

- **If one variable is exogenous**  
  👉 Use **ECM** (single-equation error-correction model)

After estimating:
- Test residuals for ARCH  
- If ARCH → **VECM-GARCH / ECM-GARCH**

---

### ❌ Branch 2B: NO — No cointegration

No long-run equilibrium; only short-run dynamics.

- **If variables endogenous**  
  👉 Use **VAR in first differences** (ΔY, ΔX)

- **If X is exogenous**  
  👉 Use **ADL/ARDL in differences**

Then:
- Test residuals for ARCH  
- If ARCH → **VAR-GARCH / ADL-GARCH in differences**

---

# STEP 3 — Volatility Modeling (GARCH)
After selecting your mean model:

1. Test residuals for ARCH effects (Engle LM test).
2. If ARCH present, estimate:
   - **Univariate GARCH** for single equations  
   - **VAR-GARCH** for multivariate systems  
   - **VECM-GARCH** for cointegrated systems

GARCH models the **time‑varying volatility** and **covariance** structure.

---

# 📌 Minimal Recipe for Your Stock–FX Project

1. Run ADF tests on stock prices and exchange rates  
2. If both I(1) → run cointegration test  
3. If cointegrated → VECM  
4. If not cointegrated → VAR in differences  
5. Run Granger causality to confirm endogeneity  
6. Test residuals for ARCH  
7. If ARCH → VAR‑GARCH or VECM‑GARCH  

---

This decision tree serves as your project roadmap. 
