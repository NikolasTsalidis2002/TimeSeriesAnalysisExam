# Project Overview: Dynamic Interactions and Volatility Between Stock Returns and Exchange Rates

## 1. Inspiration Paper

We base our project on the following research paper:

**Manasseh, C. O., et al. (2019)**  
*“Interactions between stock prices and exchange rates: An application of multivariate VAR‑GARCH model.”*  
https://www.tandfonline.com/doi/full/10.1080/23322039.2019.1681573

This paper explores how stock markets and foreign exchange markets influence each other through **mean spillovers** (using VAR) and **volatility spillovers** (using GARCH). Our project will develop a simplified and course-aligned version of this methodology.

---

## 2. Data We Will Use

We will use **two financial time series**:

### **1. Stock Market Index Returns**
Possible options:
- OMXC25 (Denmark)
- STOXX Europe 600 (Europe)
- S&P 500 (US)

### **2. Exchange Rate Returns**
Possible options:
- USD/DKK
- EUR/DKK
- EUR/USD
- USD/JPY

### **Why returns?**
- Returns are approximately **stationary**, which simplifies modelling.
- Returns exhibit **volatility clustering**, perfect for GARCH.
- Returns allow us to study **shock transmission** across markets.

We compute log‑returns as:

\[
r_t = 100 	imes \ln\left(rac{P_t}{P_{t-1}}ight)
\]

---

## 3. Models We Will Use

### ## 3.1 VAR (Vector Autoregression)

VAR models the **dynamic relationship** between the two series:

\[
egin{bmatrix}
r^{stock}_t \\
r^{fx}_t
\end{bmatrix}
=
A_1
egin{bmatrix}
r^{stock}_{t-1} \\
r^{fx}_{t-1}
\end{bmatrix}
+
\cdots +
A_p
egin{bmatrix}
r^{stock}_{t-p} \\
r^{fx}_{t-p}
\end{bmatrix}
+
arepsilon_t
\]

### **Why VAR?**
- Matches course content (Lecture 6–8).
- Captures **lead–lag effects** and **Granger causality**.
- Allows us to test: *Do FX movements predict stock returns? Or vice versa?*

### **Course connection**
- Stationarity required → ADF testing from Lecture 2.
- Lag selection by AIC/BIC → Lecture 6.
- Stability, IRFs, diagnostics → Lecture 7–8.

---

## 3.2 VECM (Vector Error Correction Model) if Cointegration Exists

If both series are I(1) and cointegrated (long‑run relationship), VECM is used:

\[
\Delta y_t = \Pi y_{t-1} + \Gamma_1 \Delta y_{t-1} + \cdots + \Gamma_{p-1} \Delta y_{t-p+1} + arepsilon_t
\]

The matrix \( \Pi \) contains the **error‑correction term**, ensuring long‑run equilibrium.

### **Why VECM?**
- If markets share a long‑run relationship (common trend), differencing alone loses essential information.
- VECM preserves both short‑term dynamics and long-run equilibrium.

---

## 3.3 GARCH (Generalized Autoregressive Conditional Heteroskedasticity)

GARCH models **time‑varying volatility**:

\[
\sigma_t^2 = lpha_0 + lpha_1 arepsilon_{t-1}^2 + eta_1 \sigma_{t-1}^2
\]

### **Why GARCH?**
- Returns exhibit **volatility clustering** (Lecture 9).
- GARCH models periods of:
  - calm (low volatility)
  - crisis (high volatility)
  - persistence of shocks (volatility “memory”)

### **Important conceptual point**
VAR models the **mean** (direction).  
GARCH models the **variance** (risk).  
They complement each other.

---

## 4. Possible Research Question

We propose:

### **RQ1: Do stock returns and exchange rate returns influence each other dynamically?**
- Tested via **VAR** or **VECM**.

### **RQ2: How does stock market volatility evolve over time?**
- Tested via **GARCH**.

Optional deeper version:

### **RQ3: Do shocks in exchange rates influence stock market volatility (risk spillovers)?**

---

## 5. What Results We Expect to Look At

### ## 5.1 From VAR/VECM:
- **Granger causality**
  - Does FX → stocks?
  - Do stocks → FX?

- **Impulse Response Functions (IRFs)**
  - How a shock today affects the other market over time.

- **Forecast Error Variance Decomposition (if desired)**
  - How much of stock volatility is explained by FX movements (and vice versa).

- **Cointegration tests**
  - Is there a long‑run equilibrium?

### ## 5.2 From GARCH:
- **Volatility persistence**
  - Large shocks causing prolonged volatility.

- **Periods of high vs low risk**
  - Crisis years vs stable periods.

- **Volatility clustering**
  - Are calm periods followed by calm periods?
  - Are turbulent periods followed by turbulent periods?

- **Comparison of models**
  - ARIMA vs ARMA-GARCH
  - Plain returns vs GARCH residuals

---

## 6. Expected Contribution

This project will:
- Demonstrate mastery of **stationarity**, **VAR/VECM**, and **GARCH** from the course.
- Connect real financial data to theory.
- Showcase both **mean dynamics** and **volatility dynamics**.
- Allow for clear interpretation suitable for an exam.

