# Time Series Analysis Project Guideline
## Dynamic Interactions and Volatility Between Stock Returns and Exchange Rates

---

## Project Overview

### Research Questions
1. Do stock returns (S&P 500) and exchange rate returns (EUR/USD) influence each other dynamically?
2. How does stock market volatility evolve over time?
3. (Optional) Do shocks in exchange rates influence stock market volatility (risk spillovers)?

### Key Objectives
- Analyze mean spillovers using VAR/VECM models
- Examine Granger causality relationships
- Model conditional heteroskedasticity using ARCH/GARCH
- Analyze impulse response functions and volatility dynamics

### Data Sources
- **S&P 500**: Monthly data (1927-2025), file: `Data/sp500.csv`
- **EUR/USD**: Daily data (1999-2025), file: `Data/EUR_USD.csv`
- **Analysis period**: January 1999 - November 2025 (monthly frequency)

---

## Implementation Requirements

### Platform and Language
- **Language**: R (NOT Python)
- **Format**: Single comprehensive R notebook (.ipynb or .Rmd)
- **Style**: Must match lecture code patterns exactly
- **Theory**: Must reference lecture materials for methodology

### Required R Libraries
```r
library(urca)        # Unit root and cointegration tests
library(vars)        # VAR/VECM models
library(rugarch)     # GARCH models
library(fGarch)      # Alternative GARCH implementation
library(aTSA)        # ARCH-LM tests
library(forecast)    # ARMA model selection
library(pracma)      # Detrending functions
library(ggplot2)     # Plotting
library(ggfortify)   # Time series plotting
```

---

## Phase 1: Data Preparation and Stationarity Testing

### Step 1.1: Load and Process Data

```r
# Load data
sp500 = read.csv("Data/sp500.csv")
eurusd = read.csv("Data/EUR_USD.csv")

# Convert EUR/USD daily to monthly (end-of-month values)
eurusd$Date = as.Date(eurusd$Date)
eurusd_monthly = eurusd %>%
  mutate(YearMonth = format(Date, "%Y-%m")) %>%
  group_by(YearMonth) %>%
  slice(n()) %>%
  ungroup()

# Align both series from 1999 onwards
sp500$Date = as.Date(sp500$Date)
sp500_subset = sp500[sp500$Date >= "1999-01-01", ]

# Calculate log returns: r_t = 100 * ln(P_t / P_{t-1})
sp500_returns = 100 * diff(log(sp500_subset$Value))
eurusd_returns = 100 * diff(log(eurusd_monthly$Value))

# Create bivariate time series
dates = sp500_subset$Date[-1]  # Remove first date after differencing
data = data.frame(
  Date = dates,
  SP500_return = sp500_returns,
  EURUSD_return = eurusd_returns
)
```

### Step 1.2: Visualize Raw Data and Returns

**Plotting template from lectures:**
```r
library(ggplot2)
library(ggfortify)
options(repr.plot.width=8, repr.plot.height=8)

# Plot S&P 500 levels
fig = autoplot(ts(sp500_subset$Value, start=c(1999,1), frequency=12), colour = 'blue')
fig = fig + theme_light() +
  theme(aspect.ratio=1) +
  theme(plot.margin = ggplot2::margin(0.2, 0.2, 0.2, 0.2, "cm")) +
  theme(text=element_text(size=30)) +
  labs(x = "Year", y = "S&P 500 Index")
fig

# Plot returns
fig_ret = autoplot(ts(sp500_returns, start=c(1999,2), frequency=12), colour = 'red')
fig_ret = fig_ret + theme_light() +
  theme(aspect.ratio=1) +
  theme(plot.margin = ggplot2::margin(0.2, 0.2, 0.2, 0.2, "cm")) +
  theme(text=element_text(size=30)) +
  labs(x = "Year", y = "S&P 500 Returns (%)")
fig_ret
```

### Step 1.3: Augmented Dickey-Fuller (ADF) Tests

**Methodology from Lecture 2:**

Test each series for unit roots using the most general specification (τ₃ test with trend and drift).

```r
library(urca)

# ADF test on S&P 500 returns
adf_sp500 = ur.df(sp500_returns, type='trend', lags=8, selectlags="AIC")
summary(adf_sp500)

# ADF test on EUR/USD returns
adf_eurusd = ur.df(eurusd_returns, type='trend', lags=8, selectlags="AIC")
summary(adf_eurusd)
```

**Interpretation:**
- Check **τ₃ statistic** against critical values (1%, 5%, 10%)
  - If τ₃ < critical value → reject H₀ → no unit root (stationary)
- Check **φ₂ statistic** to test H₀: (α=0, β₁=0) [no drift, no trend]
- Check **φ₃ statistic** to test H₀: (β₁=0) [no trend]

**Decision tree:**
- If series is I(0) → proceed to VAR in levels
- If series is I(1) → check cointegration

**If trend-stationary (deterministic trend):**
```r
library(pracma)
sp500_detrend = detrend(sp500_returns, 'linear')
eurusd_detrend = detrend(eurusd_returns, 'linear')
```

---

## Phase 2: Cointegration Testing (if I(1))

### Step 2.1: Engle-Granger Two-Step Method

Only proceed if both series are I(1).

```r
# Run cointegrating regression
coint_reg = lm(sp500_returns ~ eurusd_returns)
summary(coint_reg)

# Test residuals for stationarity
residuals = coint_reg$residuals
adf_residuals = ur.df(residuals, type='drift', lags=8, selectlags="AIC")
summary(adf_residuals)
```

**Interpretation:**
- If residuals are I(0) → cointegration exists → use VECM
- If residuals are I(1) → no cointegration → use VAR in differences

### Step 2.2: Johansen Cointegration Test

```r
library(urca)

# Prepare data matrix
data_matrix = cbind(sp500_returns, eurusd_returns)

# Johansen test with trace statistic
johansen = ca.jo(data_matrix, type="trace", ecdet="const", K=2)
summary(johansen)

# Johansen test with maximum eigenvalue
johansen_eigen = ca.jo(data_matrix, type="eigen", ecdet="const", K=2)
summary(johansen_eigen)
```

**Interpretation:**
- Check trace statistic or max eigenvalue against critical values
- Determines cointegration rank (r=0, r=1, or r=2)
- r > 0 → use VECM; r = 0 → use VAR in differences

---

## Phase 3: VAR/VECM Estimation and Diagnostics

### Step 3.1: VAR Model Selection (if no cointegration)

**From Lecture 6:**

```r
library(vars)

# Prepare data
data_ts = ts(data[, c("SP500_return", "EURUSD_return")],
             start=c(1999,2), frequency=12)

# Lag selection
var_select = VARselect(data_ts, lag.max = 8, type = "const")
var_select$selection

# Check information criteria: AIC, HQ, SC, FPE
optimal_lag = var_select$selection["AIC(n)"]
```

### Step 3.2: VAR Estimation

```r
# Estimate VAR model
model_VAR = VAR(data_ts, p = optimal_lag, type = "const")
summary(model_VAR)

# Extract coefficients and diagnostics
summary(model_VAR, equation = "SP500_return")
summary(model_VAR, equation = "EURUSD_return")
```

**Key outputs to report:**
- Coefficient estimates and t-statistics
- R² and Adjusted R²
- Residual standard errors
- F-statistic

### Step 3.3: VECM Estimation (if cointegration exists)

```r
# Convert Johansen object to VECM
vecm_model = vec2var(johansen, r = 1)  # r = cointegration rank
summary(vecm_model)
```

### Step 3.4: Granger Causality Tests

**From Lecture 6:**

```r
# Test if EUR/USD Granger-causes S&P 500
causality_test1 = causality(model_VAR, cause = "EURUSD_return")
causality_test1

# Test if S&P 500 Granger-causes EUR/USD
causality_test2 = causality(model_VAR, cause = "SP500_return")
causality_test2
```

**Interpretation:**
- H₀: Variable X does not Granger-cause Y
- If p-value < 0.05 → reject H₀ → X Granger-causes Y
- Report instantaneous causality results as well

### Step 3.5: Impulse Response Functions (IRFs)

**From Lecture 6:**

```r
# Reduced-form IRFs
irf_reduced = irf(model_VAR,
                   impulse = c("SP500_return", "EURUSD_return"),
                   response = c("SP500_return", "EURUSD_return"),
                   n.ahead = 12,
                   ortho = FALSE,
                   boot = TRUE,
                   runs = 1000,
                   ci = 0.95)
plot(irf_reduced)

# Orthogonalized IRFs (Cholesky decomposition)
irf_ortho = irf(model_VAR,
                 impulse = c("SP500_return", "EURUSD_return"),
                 response = c("SP500_return", "EURUSD_return"),
                 n.ahead = 12,
                 ortho = TRUE,
                 boot = TRUE,
                 runs = 1000,
                 ci = 0.95)
plot(irf_ortho)
```

**Interpretation:**
- Trace out dynamic responses to one-time shocks
- Check persistence of shocks
- Compare reduced-form vs orthogonalized responses
- Note: Order matters for orthogonalized IRFs (Cholesky ordering)

---

## Phase 4: ARCH/GARCH Volatility Modeling

### Step 4.1: Test for ARCH Effects

**From Lecture 9:**

Test VAR/VECM residuals for conditional heteroskedasticity.

```r
library(aTSA)

# Extract residuals from VAR model
residuals_sp500 = residuals(model_VAR)[, "SP500_return"]
residuals_eurusd = residuals(model_VAR)[, "EURUSD_return"]

# ARCH-LM test on S&P 500 residuals
arch.test(residuals_sp500)

# ARCH-LM test on EUR/USD residuals
arch.test(residuals_eurusd)
```

**Interpretation:**
- H₀: No ARCH effects
- If p-value < 0.05 → reject H₀ → ARCH effects present → proceed to GARCH
- Test multiple lag orders (default in arch.test)

### Step 4.2: Specify Mean Model for S&P 500 Returns

**From Lecture 9:**

```r
library(forecast)

# Automatic ARMA selection
arma_model = auto.arima(sp500_returns, max.p = 20, max.q = 20,
                         seasonal = FALSE, stationary = TRUE)
arma_model

# Extract orders
p = arma_model$arma[1]
q = arma_model$arma[2]

# Estimate ARMA model
mean_model = arima(sp500_returns, order = c(p, 0, q))
summary(mean_model)

# Test residuals for ARCH
arch.test(mean_model)
```

### Step 4.3: GARCH(1,1) Model Estimation

**From Lecture 9:**

```r
library(rugarch)

# Specify GARCH(1,1) model
spec_garch = ugarchspec(
  variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(p, q), include.mean = TRUE),
  distribution.model = "norm"
)

# Fit GARCH model
garch_fit = ugarchfit(spec_garch, sp500_returns)

# Display results
garch_fit
garch_fit@fit$matcoef
```

**Key outputs to report:**
- α₀ (omega): Unconditional variance component
- α₁ (alpha1): ARCH effect (impact of past squared errors)
- β₁ (beta1): GARCH effect (persistence of volatility)
- Persistence: α₁ + β₁ (should be < 1 for stationarity)

**Interpretation:**
- α₁ > 0 and significant → volatility clustering
- β₁ close to 1 → high persistence
- If α₁ + β₁ ≈ 1 → nearly integrated GARCH (I-GARCH)

### Step 4.4: GARCH Diagnostics

```r
# Plot conditional volatility
plot(garch_fit, which = 1)  # Time series of residuals
plot(garch_fit, which = 3)  # Conditional sigma

# Standardized residuals
std_residuals = residuals(garch_fit, standardize = TRUE)

# Test standardized residuals for remaining ARCH
arch.test(std_residuals)

# Should NOT reject H₀ if model is adequate
```

### Step 4.5: GARCH Forecasting

```r
# Forecast volatility 5 periods ahead
garch_forecast = ugarchforecast(garch_fit, n.ahead = 5)
garch_forecast

# Plot forecast
plot(garch_forecast)
```

### Step 4.6: Alternative GARCH Specifications (if needed)

```r
# EGARCH (captures asymmetry/leverage effects)
spec_egarch = ugarchspec(
  variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(p, q), include.mean = TRUE),
  distribution.model = "norm"
)
egarch_fit = ugarchfit(spec_egarch, sp500_returns)

# GJR-GARCH (Glosten-Jagannathan-Runkle)
spec_gjr = ugarchspec(
  variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
  mean.model = list(armaOrder = c(p, q), include.mean = TRUE),
  distribution.model = "norm"
)
gjr_fit = ugarchfit(spec_gjr, sp500_returns)

# Compare AIC/BIC
infocriteria(garch_fit)
infocriteria(egarch_fit)
infocriteria(gjr_fit)
```

---

## Phase 5: Results Organization and Interpretation

### Section 1: Introduction
- State research questions
- Describe data sources and time period
- Outline methodology

### Section 2: Data Preparation
- Summary statistics (mean, sd, min, max, skewness, kurtosis)
- Time series plots of levels and returns
- Correlation matrix

### Section 3: Stationarity Analysis
- ADF test results table (τ₃, φ₂, φ₃, critical values)
- Conclusion: I(0) or I(1)?
- Detrending if necessary

### Section 4: Cointegration Analysis (if applicable)
- Engle-Granger results
- Johansen test results (trace and max eigenvalue)
- Conclusion: Cointegration rank

### Section 5: VAR/VECM Results
- Optimal lag selection table
- Coefficient estimates table
- Granger causality test results
- Interpretation: Which variable influences which?

### Section 6: Impulse Response Analysis
- IRF plots (4 panels: 2x2 grid)
- Interpretation: Dynamic responses to shocks
- Persistence and magnitude of effects

### Section 7: Volatility Analysis
- ARCH-LM test results
- ARMA mean model selection
- GARCH(1,1) parameter estimates
- Conditional volatility plot
- Interpretation: Clustering, persistence, asymmetry

### Section 8: Conclusions
- Answer research questions
- Summarize key findings:
  - Do returns influence each other? (Granger causality)
  - How does volatility evolve? (GARCH dynamics)
  - Risk spillovers? (IRFs + GARCH)

---

## Model Selection Decision Tree

```
START
  |
  ├─> Step 1: ADF Tests on both series
  |     |
  |     ├─> Both I(0)? → VAR in levels
  |     |
  |     └─> Both I(1)? → Step 2
  |
  ├─> Step 2: Cointegration Tests
  |     |
  |     ├─> Cointegrated (r>0)? → VECM
  |     |
  |     └─> Not cointegrated (r=0)? → VAR in differences
  |
  ├─> Step 3: VAR/VECM Estimation
  |     - Lag selection (AIC/BIC)
  |     - Coefficient estimation
  |     - Granger causality tests
  |     - Impulse response functions
  |
  ├─> Step 4: Test residuals for ARCH effects
  |     |
  |     ├─> ARCH present? → Step 5
  |     |
  |     └─> No ARCH? → End (homoskedastic model sufficient)
  |
  └─> Step 5: GARCH Modeling
        - Specify mean model (ARMA)
        - Estimate GARCH(1,1)
        - Check diagnostics
        - Forecast volatility
```

---

## Critical Values Reference

### ADF Test Critical Values (from Lecture 2)
**τ₃ test (with trend and drift):**
- 1%: -3.96
- 5%: -3.41
- 10%: -3.12

**φ₂ test (joint test: α=0, β₁=0):**
- 1%: 6.09
- 5%: 4.68
- 10%: 4.03

**φ₃ test (no trend: β₁=0):**
- 1%: 8.34
- 5%: 6.30
- 10%: 5.36

### Johansen Test Critical Values
Automatically provided by `ca.jo()` output - compare test statistics to 10%, 5%, 1% critical values.

---

## Expected Deliverables

1. **Single R notebook** containing:
   - All code chunks with comments
   - Output displays (tables, plots)
   - Markdown sections with interpretations

2. **Results to report:**
   - Stationarity: ADF test statistics and p-values
   - Cointegration: Johansen trace/eigenvalue statistics
   - VAR/VECM: Coefficient tables, R², F-tests
   - Granger causality: Test statistics and p-values
   - IRFs: Plots with confidence bands
   - ARCH tests: LM statistics and p-values
   - GARCH: Parameter estimates (α₀, α₁, β₁), persistence
   - Volatility plot with conditional σₜ

3. **Interpretation guidelines:**
   - Economic significance, not just statistical
   - Connect findings to research questions
   - Discuss limitations and assumptions

---

## Quality Checklist

- [ ] Code follows lecture style exactly
- [ ] All plots use lecture formatting (ggplot2 with theme_light)
- [ ] ADF tests use: `type='trend'`, `lags=8`, `selectlags="AIC"`
- [ ] VAR lag selection uses information criteria
- [ ] IRFs include both reduced-form and orthogonalized
- [ ] Bootstrap confidence intervals (runs=1000, ci=0.95)
- [ ] ARCH tests performed on residuals
- [ ] GARCH persistence checked (α₁ + β₁ < 1)
- [ ] All tables formatted clearly
- [ ] Interpretations reference theory from lectures
- [ ] Research questions answered in conclusion

---

## References

**Lectures:**
- Lecture 2: Non-stationary time series and unit root tests
- Lecture 6: VAR models estimation and inference
- Lecture 9: ARCH and GARCH models

**Methodology:**
- Hamilton (1994) - Time Series Analysis
- Lütkepohl (2005) - New Introduction to Multiple Time Series Analysis
- Engle (1982) - ARCH models
- Bollerslev (1986) - GARCH models

---

## Notes and Tips

1. **Always check lecture PDFs** for exact function syntax
2. **Match plotting style** to maintain consistency
3. **Interpret results economically**, not just statistically
4. **Document all decisions** (lag selection, model choice, etc.)
5. **Bootstrap confidence intervals** for robust inference
6. **Test diagnostics thoroughly** before moving to next step
7. **GARCH on returns**, not on levels
8. **Order matters** in Cholesky decomposition for orthogonalized IRFs

---

**This guideline should be used as the definitive reference for implementing the time series analysis project. All code must follow these templates, and all interpretations must reference the corresponding lecture materials.**
