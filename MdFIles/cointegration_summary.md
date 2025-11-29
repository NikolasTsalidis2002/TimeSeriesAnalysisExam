
# 📘 Lecture Summary: Cointegration in Time Series

---

## 🔹 Why Cointegration Matters

Many economic and financial time series are **non-stationary** (I(1)). Using these directly in regression models can lead to **spurious results** — where the relationships look statistically strong but are actually meaningless.

**Cointegration** offers a way to identify a **true long-run relationship** between non-stationary variables.

---

## 🧠 What Is Cointegration?

If two (or more) non-stationary series (e.g. I(1)) have a **linear combination** that is **stationary (I(0))**, then they are said to be **cointegrated**.

\[
Z_t = Y_t - \beta X_t \sim I(0)
\]

This means the series may individually wander over time, but they **do not drift apart indefinitely** — they move together in the long run.

---

## ⚠️ The Spurious Regression Problem

Regressing one I(1) series on another can give **high R²** and **significant coefficients**, but the relationship is **not real** unless the residuals are stationary.

---

## ✅ Engle-Granger Two-Step Test

1. **Run a regression**:  
   \[
   Y_t = \alpha + \beta X_t + u_t
   \]

2. **Test residuals \( u_t \)** for stationarity (ADF test):
   - If \( u_t \sim I(0) \): Y and X are **cointegrated**
   - If not: no cointegration

➡️ Use **special critical values** in this test — not the standard ADF ones.

---

## 🔁 Why Must the Residuals Be Stationary?

If \( u_t \sim I(0) \), it means deviations from the long-term relationship are **temporary** and revert to equilibrium.

If \( u_t \sim I(1) \), then there's no stable long-run relationship.

---

## ❓ Why Must Both Series Be I(1)?

- If both are I(0): use VAR/ARDL directly — no cointegration needed.
- If one is I(1), one is I(0): they cannot cointegrate — one drifts, one doesn’t.
- If both are I(2): advanced techniques needed; cointegration theory for I(1) breaks down.

✅ Cointegration is only meaningful when both are **I(1)** — same "level" of non-stationarity.

---

## 🧮 Error Correction Model (ECM)

If variables are cointegrated, we model their relationship using an ECM:

\[
\Delta Y_t = \alpha + \gamma (Y_{t-1} - \beta X_{t-1}) + \delta \Delta X_t + \varepsilon_t
\]

- \( \Delta X_t \): short-run changes
- \( (Y_{t-1} - \beta X_{t-1}) \): error correction term
- \( \gamma \): speed of adjustment to long-run equilibrium

This model keeps short-run flexibility **while forcing long-run equilibrium**.

---

## 🔄 How ECM Connects with VAR

| Situation                             | Model to Use       |
|--------------------------------------|--------------------|
| All series I(0)                      | VAR or ARDL        |
| All series I(1), not cointegrated    | VAR in differences |
| All series I(1), cointegrated        | ECM or VECM        |

> You must not use VAR in levels when series are I(1) and cointegrated.

---

## 💡 Why Not Just Use VAR or ADL?

- **VAR in levels (with I(1))**: leads to spurious regression
- **VAR in differences (with cointegration)**: loses long-run info
- **ADL**: only valid for I(0) series, or needs adjustment to include ECM structure

✅ Use ECM (or VECM) to preserve both:
- **Short-run dynamics**
- **Long-run relationship**

---

## 🎯 Intuition: The Rubber Band Analogy

Two variables tied by a rubber band:
- They move apart (short-run shocks)
- But the rubber band pulls them back (long-run equilibrium)

The error correction term is the **rubber band force**.

---

## 🔬 For Multivariate Systems: The Johansen Test

When more than two I(1) variables:
- Use **Johansen test** (based on VECM structure)
- It identifies how many cointegration relationships exist

---

## ✅ Summary Table

| Concept        | Purpose                            |
|----------------|-------------------------------------|
| I(1) series     | Non-stationary, needs differencing |
| Cointegration  | Long-run relationship exists        |
| Residuals I(0) | Mean-reverting error ⇒ equilibrium  |
| ECM            | Combines short-run + long-run       |
| VAR in levels  | ❌ Invalid with I(1) series          |
| VAR in diff    | ❌ Loses long-run info if cointegrated |
| VECM           | ✅ VAR + cointegration structure     |

---

Let me know if you want:
- A visual explanation
- A coding notebook (Python/R)
- A follow-up on Johansen testing
