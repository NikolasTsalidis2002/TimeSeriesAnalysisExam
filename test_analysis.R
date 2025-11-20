# Test script to verify the analysis code works
# This script tests the key components of the TimeSeriesAnalysis.Rmd

# Load required packages
cat("Loading packages...\n")
suppressPackageStartupMessages({
  library(urca)
  library(vars)
  library(rugarch)
  library(fGarch)
  library(FinTS)
  library(forecast)
  library(dplyr)
  library(tidyr)
  library(zoo)
  library(ggplot2)
  library(moments)
})

cat("Packages loaded successfully!\n\n")

# Set random seed
set.seed(42)

# Load data
cat("Loading data...\n")
sp500 <- read.csv("Data/sp500.csv", stringsAsFactors = FALSE)
sp500$Date <- as.Date(sp500$Date, format = "%m/%d/%Y")

eurusd <- read.csv("Data/EUR_USD.csv", stringsAsFactors = FALSE)
eurusd$Date <- as.Date(eurusd$Date, format = "%m/%d/%Y")

cat("S&P 500 data: ", nrow(sp500), " observations\n")
cat("EUR/USD data: ", nrow(eurusd), " observations\n")
cat("Date range S&P 500:", min(sp500$Date), "to", max(sp500$Date), "\n")
cat("Date range EUR/USD:", min(eurusd$Date), "to", max(eurusd$Date), "\n\n")

# Convert EUR/USD to monthly
cat("Converting EUR/USD to monthly frequency...\n")
eurusd_zoo <- zoo(eurusd$Value, order.by = eurusd$Date)
eurusd_monthly <- aggregate(eurusd_zoo, zoo::as.yearmon, tail, 1)
eurusd_monthly_df <- data.frame(
  Date = zoo::as.Date(zoo::as.yearmon(index(eurusd_monthly)), frac = 1),
  Value = as.numeric(coredata(eurusd_monthly))
)

# Filter and merge
sp500_filtered <- sp500 %>%
  filter(Date >= as.Date("1999-01-01"))

data_merged <- inner_join(
  sp500_filtered %>% rename(SP500 = Value),
  eurusd_monthly_df %>% rename(EURUSD = Value),
  by = "Date"
)

# Calculate log returns
data_merged <- data_merged %>%
  mutate(
    r_SP500 = 100 * log(SP500 / lag(SP500)),
    r_EURUSD = 100 * log(EURUSD / lag(EURUSD))
  ) %>%
  filter(!is.na(r_SP500))

cat("Merged data: ", nrow(data_merged), " monthly observations\n\n")

# Create time series object
returns_ts <- ts(
  data_merged[, c("r_SP500", "r_EURUSD")],
  start = c(1999, 2),
  frequency = 12
)

# Summary statistics
cat("Summary Statistics:\n")
cat("S&P 500 Returns - Mean:", round(mean(returns_ts[, 1]), 4), " SD:", round(sd(returns_ts[, 1]), 4), "\n")
cat("EUR/USD Returns - Mean:", round(mean(returns_ts[, 2]), 4), " SD:", round(sd(returns_ts[, 2]), 4), "\n")
cat("Correlation:", round(cor(returns_ts[, 1], returns_ts[, 2]), 4), "\n\n")

# ADF tests
cat("Running ADF tests...\n")
adf_sp500 <- ur.df(returns_ts[, "r_SP500"], type = 'trend', lags = 8, selectlags = "AIC")
adf_eurusd <- ur.df(returns_ts[, "r_EURUSD"], type = 'trend', lags = 8, selectlags = "AIC")

cat("S&P 500 ADF tau3:", round(adf_sp500@teststat[1], 3), " Conclusion:",
    ifelse(abs(adf_sp500@teststat[1]) > 3.41, "I(0) - Stationary", "I(1) - Non-stationary"), "\n")
cat("EUR/USD ADF tau3:", round(adf_eurusd@teststat[1], 3), " Conclusion:",
    ifelse(abs(adf_eurusd@teststat[1]) > 3.41, "I(0) - Stationary", "I(1) - Non-stationary"), "\n\n")

# VAR lag selection
cat("Selecting optimal VAR lag...\n")
var_select <- VARselect(returns_ts, lag.max = 8, type = "const")
p_optimal <- var_select$selection["AIC(n)"]
cat("Optimal lag (AIC):", p_optimal, "\n\n")

# Estimate VAR
cat("Estimating VAR model...\n")
var_model <- VAR(returns_ts, p = p_optimal, type = "const")
cat("VAR estimation successful!\n")
cat("R-squared S&P 500:", round(summary(var_model)$varresult$r_SP500$r.squared, 4), "\n")
cat("R-squared EUR/USD:", round(summary(var_model)$varresult$r_EURUSD$r.squared, 4), "\n\n")

# Granger causality
cat("Testing Granger causality...\n")
gc_eurusd_to_sp500 <- causality(var_model, cause = "r_EURUSD")
gc_sp500_to_eurusd <- causality(var_model, cause = "r_SP500")

cat("EUR/USD -> S&P 500: p-value =", round(gc_eurusd_to_sp500$Granger$p.value, 4), "\n")
cat("S&P 500 -> EUR/USD: p-value =", round(gc_sp500_to_eurusd$Granger$p.value, 4), "\n\n")

# ARCH test
cat("Testing for ARCH effects...\n")
var_residuals <- residuals(var_model)
arch_test_sp500 <- ArchTest(var_residuals[, "r_SP500"], lags = 12)
cat("ARCH test p-value (S&P 500):", round(arch_test_sp500$p.value, 4), "\n")
cat("Conclusion:", ifelse(arch_test_sp500$p.value < 0.05, "ARCH effects present - GARCH needed", "No ARCH effects"), "\n\n")

# ARMA selection
cat("Selecting ARMA model for mean equation...\n")
arma_model <- auto.arima(
  returns_ts[, "r_SP500"],
  max.p = 20,
  max.q = 20,
  seasonal = FALSE,
  stationary = TRUE,
  ic = "aic"
)
p_arma <- arma_model$arma[1]
q_arma <- arma_model$arma[2]
cat("Selected ARMA(", p_arma, ",", q_arma, ")\n\n", sep = "")

# GARCH estimation
cat("Estimating GARCH(1,1) model...\n")
garch_spec <- ugarchspec(
  variance.model = list(
    model = "sGARCH",
    garchOrder = c(1, 1)
  ),
  mean.model = list(
    armaOrder = c(p_arma, q_arma),
    include.mean = TRUE
  ),
  distribution.model = "norm"
)

garch_fit <- ugarchfit(spec = garch_spec, data = returns_ts[, "r_SP500"])

# Extract GARCH parameters
garch_coef <- coef(garch_fit)
alpha0 <- garch_coef["omega"]
alpha1 <- garch_coef["alpha1"]
beta1 <- garch_coef["beta1"]
persistence <- alpha1 + beta1
half_life <- log(0.5) / log(persistence)

cat("\nGARCH estimation successful!\n")
cat("omega (α₀):", round(alpha0, 6), "\n")
cat("alpha1 (α₁):", round(alpha1, 4), "\n")
cat("beta1 (β₁):", round(beta1, 4), "\n")
cat("Persistence (α₁ + β₁):", round(persistence, 4), "\n")
cat("Half-life:", round(half_life, 2), "months\n")
cat("Stationarity:", ifelse(persistence < 1, "YES (volatility is stationary)", "NO (non-stationary)"), "\n\n")

cat("================================\n")
cat("ALL TESTS COMPLETED SUCCESSFULLY!\n")
cat("================================\n")
cat("\nThe TimeSeriesAnalysis.Rmd notebook is ready to be knitted.\n")
cat("You can open it in RStudio and click 'Knit' to generate the PDF/HTML output.\n")
