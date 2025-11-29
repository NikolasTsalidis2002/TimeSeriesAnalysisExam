
# 📘 ADF Test Walkthrough — Mathematical Intuition & Commentary

This file documents a full walkthrough of how the Augmented Dickey-Fuller (ADF) test works, with an emphasis on **why** we do it, the **math behind it**, and the conclusions we reached through example outputs.

---

## 🧠 Why Do We Even Run the ADF Test?

OLS relies on key assumptions:
- Constant variance (homoskedasticity)
- Uncorrelated residuals (no autocorrelation)
- A stable relationship between variables

But when data is **non-stationary**, these assumptions are violated. The residuals may be autocorrelated or have time-varying variance.

We need to test whether a time series is **stationary**, which means:
- Constant mean and variance
- No unit root

---

## 🔍 The ADF Regression Equation

We estimate:

\[
\Delta y_t = \alpha_0 + \alpha_1 y_{t-1} + \alpha_2 t + \sum_{i=1}^{p} \gamma_i \Delta y_{t-i} + \varepsilon_t
\]

Where:
- \( \Delta y_t \) is the change in the series
- \( y_{t-1} \) is the lagged level
- \( \Delta y_{t-i} \) are lagged differences
- \( t \) is time (trend), \( \alpha_0 \) is intercept (drift)

---

## ❓ What's the Null Hypothesis?

- **H₀: \( \alpha_1 = 0 \)** → unit root exists → series is **non-stationary**
- **H₁: \( \alpha_1 < 0 \)** → series is **stationary**

If \( \alpha_1 = 0 \), the change in \( y \) does **not** depend on its level \( y_{t-1} \), which means **shocks persist** forever — classic behavior of a random walk.

If \( \alpha_1 < 0 \), then a shock dies out over time — which means the process **returns to a stable mean** → stationarity.

---

## 🧪 Why Don't We Use the OLS t-test?

The OLS test statistic for \( \alpha_1 \) has a **non-standard distribution** under the null hypothesis (unit root). Therefore, we can't use regular p-values.

We must compare the t-statistic against **ADF critical values (tau)**:
- tau1: no drift/trend
- tau2: with drift
- tau3: with drift + trend

📌 This is why **`Pr(>|t|)` is not valid** for testing \( \alpha_1 \).

---

## 🔄 The Testing Strategy (Why These Steps?)

We don't know if a deterministic component like drift or trend exists. Including them unnecessarily **wastes degrees of freedom**, but excluding them can **bias the test**.

So we test:

1. **With trend and drift** (full model):
   - If both are not jointly significant (`phi3`), drop the trend.
2. **With drift only**:
   - If drift not significant (`phi1`), drop it too.
3. **No constant**:
   - Bare minimum test of unit root.

Each model simplifies the assumptions to keep only what is statistically justified.

---

## ✅ What You Realized (And Got Right!)

### 📌 On OLS Assumptions:
> "We are trying to make the model stationary so the variance is constant, and there’s no correlation between residuals — so that we can use OLS in the first place."  
✅ Exactly. Without stationarity, OLS inference breaks.

---

### 📌 On tau vs. p-value:
> "The test statistic must be more negative than the critical value to reject the null."  
✅ Yes — **you want the ADF statistic to be < critical value** (in the left tail).

---

### 📌 On model selection:
> "We start with all terms, and if phi3 is not significant, we drop trend. Then test for drift using phi1. If even drift is not significant, we use none."  
✅ This is the right order of testing. Each phi test checks **joint significance** of extra terms.

---

### 📌 On interpretation:
> "If phi2 is significant but phi3 is not, then drift matters but trend does not."  
✅ Correct conclusion — means **intercept should stay**, but trend should be removed.

---

### 📌 On transformation:
> "After logging and differencing, if the resulting series is stationary, then the original series is I(1)."  
✅ Yes. You applied the definition correctly:
- I(0) = stationary
- I(1) = needs first difference to become stationary

---

## 📊 Practical Summary

| Component | Meaning |
|----------|---------|
| `tau`    | Test of unit root (stationarity) |
| `phi`    | Joint significance of drift/trend |
| `Pr(>|t|)` | OLS p-value — **not used** for deciding unit root |
| Reject H₀ (ADF) | Series is stationary (I(0)) |
| Fail to reject H₀ | Series is non-stationary (I(1)) |

---

## ✅ Bottom Line

- ADF is based on a clever regression that translates the question of “does this have a unit root?” into testing a coefficient.
- The logic works **because** if a series is stationary, its changes \( \Delta y_t \) depend on how far it is from the mean (\( y_{t-1} \)).
- If changes \( \Delta y_t \) are **independent** of \( y_{t-1} \), then past values don't matter → non-stationary.

