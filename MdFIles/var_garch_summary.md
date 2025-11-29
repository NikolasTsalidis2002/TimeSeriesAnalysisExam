
# 📘 Summary of VAR & GARCH Lectures and Discussions

---

## 🔹 Lecture 1: VAR Models & Structural Identification

### 🔧 1. VAR (Vector Autoregression)
A system of equations where each variable is regressed on its own lags and the lags of other variables:

\[
Y_t = A_1 Y_{t-1} + A_2 Y_{t-2} + \dots + A_p Y_{t-p} + u_t
\]

- \(Y_t\): vector of variables  
- \(A_i\): coefficient matrices  
- \(u_t\): reduced-form residuals (shocks), potentially correlated

---

### 🧠 2. The Identification Problem
VAR models do not identify structural shocks directly — they only give reduced-form shocks \(u_t\), which may be correlated.

We want to identify:

\[
u_t = S \varepsilon_t
\]

Where:
- \(\varepsilon_t\): structural shocks (uncorrelated)
- \(S\): matrix linking them to observed residuals

---

### 🧩 3. Structural VAR (SVAR)
We impose economic restrictions to identify \(S\), using one of:

- Short-run restrictions (e.g., recursive ordering using Cholesky)
- Long-run restrictions (e.g., some shocks have no long-term effect)
- Sign restrictions (e.g., impulse signs based on theory)

Goal: Recover meaningful economic shocks (e.g., monetary, demand, technology) from VAR residuals.

---

### 📈 4. Impulse Response Functions (IRFs)
IRFs trace the effect of a one-time shock to one variable on the future path of all variables in the system.

We can also compute:
- Cumulative IRFs (total effect over time)
- Forecast Error Variance Decomposition (FEVD): what % of forecast error is due to each shock

---

## 🔹 Lecture 2: ARCH/GARCH and Conditional Heteroskedasticity

### ⚠️ 1. The Problem: Non-constant Variance
Standard models assume:

\[
u_t \sim \mathcal{N}(0, \sigma^2)
\]

But in financial time series:
- Volatility changes over time
- We observe volatility clustering
→ Conditional heteroskedasticity

---

### 🧪 2. ARCH-LM Test
Regress squared residuals \(u_t^2\) on their own lags.

Test:  
\[
H_0: \alpha_1 = \alpha_2 = \dots = \alpha_q = 0
\]

If **jointly rejected** ⇒ ARCH effect present

---

### 🧱 3. ARCH(q) Model
\[
\sigma_t^2 = \alpha_0 + \alpha_1 u_{t-1}^2 + \dots + \alpha_q u_{t-q}^2
\]

---

### 🔄 4. GARCH(p, q) Model
\[
\sigma_t^2 = \alpha_0 + \sum \alpha_i u_{t-i}^2 + \sum \beta_j \sigma_{t-j}^2
\]

Most common: GARCH(1,1)

\[
\sigma_t^2 = \alpha_0 + \alpha_1 u_{t-1}^2 + \beta_1 \sigma_{t-1}^2
\]

---

### 🔄 5. Combining VAR/AR with GARCH
- First fit AR or VAR (mean model)
- Then test residuals for ARCH effect
- If detected, fit GARCH to residuals
- Combine as AR-GARCH or VAR-GARCH

→ You **do not re-estimate** the mean after fitting GARCH

---

### 🎯 6. What GARCH Gives You
- Time-varying volatility \(\sigma_t^2\)
- Better standard errors and forecast intervals
- Useful in risk management and financial forecasting

---

## 📌 Final Notes

| Topic              | Purpose                                 | Output                        |
|-------------------|-----------------------------------------|-------------------------------|
| VAR               | Model mean dynamics between time series | IRFs, shock propagation       |
| SVAR              | Identify economic shocks from VAR       | Structural interpretation     |
| IRF               | Response to one-time shocks             | Forecasted path               |
| ARCH/GARCH        | Model time-varying variance             | Volatility forecasts          |
| AR-GARCH/VAR-GARCH| Combine mean + volatility models        | Accurate return + risk model  |
