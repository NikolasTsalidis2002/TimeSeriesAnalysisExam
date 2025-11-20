# Time Series Analysis Project

## Project Overview

This project analyzes the dynamic interactions between S&P 500 stock returns and EUR/USD exchange rate returns using Vector Autoregression (VAR) and GARCH models.

## Files in This Directory

1. **TimeSeriesAnalysis.Rmd** - Main R Markdown notebook containing the complete analysis
2. **notebookGuideline.md** - Comprehensive guideline explaining the methodology and implementation
3. **install_packages.R** - Script to install all required R packages
4. **test_analysis.R** - Test script to verify the analysis code works correctly
5. **Data/** - Folder containing:
   - sp500.csv (S&P 500 monthly data)
   - EUR_USD.csv (EUR/USD daily exchange rate data)
   - analysis.Rmd (reference notebook for style)
6. **PROJECT_GUIDELINE.md** - Original project requirements and methodology
7. **ExamInstructions.pdf** - Exam requirements document

## How to Run the Analysis

### Step 1: Install Required Packages

Before running the analysis, you need to install all required R packages. Open R or RStudio and run:

```r
source("install_packages.R")
```

This will automatically install:
- urca (unit root and cointegration tests)
- vars (VAR/VECM models)
- rugarch, fGarch (GARCH models)
- FinTS (ARCH tests)
- forecast (ARMA model selection)
- dplyr, tidyr (data manipulation)
- zoo (time series objects)
- ggplot2, ggfortify, gridExtra (visualization)
- corrplot (correlation plots)
- moments (statistical moments)
- knitr, rmarkdown (document generation)

### Step 2: Test the Analysis (Optional but Recommended)

To verify that all packages are correctly installed and the analysis code works, run the test script:

```r
source("test_analysis.R")
```

This script will:
- Load and process the data
- Run ADF tests
- Estimate a VAR model
- Perform Granger causality tests
- Test for ARCH effects
- Estimate a GARCH model
- Display key results

If this script completes successfully, you're ready to knit the full notebook.

### Step 3: Knit the R Markdown Notebook

#### Option A: Using RStudio (Recommended)

1. Open `TimeSeriesAnalysis.Rmd` in RStudio
2. Click the **Knit** button at the top of the editor
3. Choose either:
   - **Knit to HTML** (faster, interactive)
   - **Knit to PDF** (requires LaTeX installation)

#### Option B: Using R Command Line

```r
# For HTML output
rmarkdown::render("TimeSeriesAnalysis.Rmd", output_format = "html_document")

# For PDF output (requires LaTeX)
rmarkdown::render("TimeSeriesAnalysis.Rmd", output_format = "pdf_document")
```

### Step 4: Review the Output

The knitted document will contain:

1. **Introduction** - Research questions and economic motivation
2. **Data Section** - Data description, summary statistics, and visualizations
3. **Stationarity Analysis** - ADF unit root tests
4. **Cointegration Analysis** - Johansen tests
5. **VAR Model** - Estimation and interpretation
6. **Granger Causality** - Testing dynamic interactions
7. **Impulse Response Functions** - Dynamic shock propagation
8. **GARCH Volatility Modeling** - Time-varying volatility analysis
9. **Conclusions** - Answers to research questions and implications
10. **References** - Academic and course materials

## Expected Output

### Tables
- Summary statistics
- ADF test results
- Johansen cointegration tests
- VAR lag selection criteria
- Granger causality results
- GARCH parameter estimates
- Volatility forecasts

### Figures
- S&P 500 levels and returns (time series plots)
- EUR/USD levels and returns (time series plots)
- Correlation matrix heatmap
- Impulse response functions (4-panel grid)
- Conditional volatility over time
- (Optional) Standardized residuals diagnostics

## Troubleshooting

### Issue: Packages Won't Install

**Solution**: Some packages require system dependencies. On macOS:

```bash
# If you get compilation errors, you may need Xcode Command Line Tools
xcode-select --install

# If specific packages fail, try installing them individually
R -e "install.packages('urca', repos='https://cloud.r-project.org/')"
```

### Issue: PDF Knitting Fails

**Solution**: PDF output requires LaTeX. Install TinyTeX:

```r
install.packages("tinytex")
tinytex::install_tinytex()
```

Alternatively, use HTML output instead:
- HTML renders faster
- Doesn't require LaTeX
- Includes interactive features

### Issue: "Pandoc Not Found" Error

**Solution**:
- If using RStudio, make sure it's up to date (RStudio includes Pandoc)
- If using R command line, install Pandoc separately:
  - macOS: `brew install pandoc`
  - Or download from: https://pandoc.org/installing.html

### Issue: Data Files Not Found

**Solution**: Make sure you're running the code from the correct working directory:

```r
# Check current directory
getwd()

# Set to the Exam folder if needed
setwd("/Users/nikolastsalidis/Desktop/University/Masters/3rd Semester/TimeSeriesForEconomicsBusinessFinance/Exam")
```

### Issue: Long Execution Time

**Expected**: The full analysis takes approximately 5-10 minutes due to:
- Bootstrap procedures for IRFs (1000 replications)
- GARCH optimization
- Multiple model estimations

**To speed up for testing**:
- Reduce bootstrap runs in IRF section (change `runs = 1000` to `runs = 100`)
- Test with HTML output first (faster than PDF)

## Analysis Highlights

### Research Questions Addressed

1. **Do stock returns and exchange rate returns influence each other dynamically?**
   - Answered through Granger causality tests and impulse response functions

2. **How does stock market volatility evolve over time?**
   - Analyzed using GARCH(1,1) model showing volatility clustering and persistence

3. **Do shocks in exchange rates influence stock market volatility?**
   - Examined through cross-market impulse responses and risk spillover analysis

### Key Findings (Example - Will Vary Based on Actual Data)

- **Stationarity**: Both return series are I(0), justifying VAR in levels
- **Cointegration**: Results determine whether VAR or VECM is appropriate
- **Granger Causality**: Tests reveal predictive relationships between markets
- **Volatility**: GARCH confirms time-varying volatility with strong persistence
- **Crises Impact**: Major volatility spikes during 2008 and 2020 crises

## Project Requirements Met

✅ **Two Models Applied**:
1. VAR/VECM for mean dynamics
2. GARCH for volatility modeling

✅ **Complete Analysis**:
- Unit root testing
- Cointegration testing
- Model estimation and diagnostics
- Hypothesis testing
- Forecasting

✅ **Professional Presentation**:
- Clear structure and flow
- Comprehensive interpretations
- High-quality visualizations
- Proper statistical reporting

✅ **Page Limit**: Designed to fit within 10-page PDF requirement

## Customization

### Adjusting the Analysis Period

To change the date range, edit the data filtering section:

```r
# Change this line in the Data section
sp500_filtered <- sp500 %>%
  filter(Date >= as.Date("1999-01-01"))  # Change start date here
```

### Modifying VAR Lag Length

To test different lag specifications:

```r
# In VAR estimation section, manually set lag
var_model <- VAR(returns_ts, p = 3, type = "const")  # Use p=3 instead of AIC
```

### Alternative GARCH Specifications

The notebook uses GARCH(1,1). To try EGARCH or GJR-GARCH:

```r
# Change variance model specification
garch_spec <- ugarchspec(
  variance.model = list(
    model = "eGARCH",  # or "gjrGARCH"
    garchOrder = c(1, 1)
  ),
  # ... rest stays the same
)
```

## Additional Resources

- **notebookGuideline.md**: Detailed explanations of every analysis phase
- **PROJECT_GUIDELINE.md**: Original methodology and code templates
- **Course Lectures**:
  - Lecture 2: VAR Models
  - Lecture 6: Cointegration
  - Lecture 9: GARCH Models

## Contact & Support

For questions about:
- **R Package Issues**: Check package documentation or CRAN
- **Statistical Methods**: Refer to course materials and Enders (2015) textbook
- **Code Errors**: Review error messages and check the troubleshooting section above

## Acknowledgments

- Data sources: S&P 500 (Standard & Poor's), EUR/USD (ECB)
- Methodology inspired by Manasseh et al. (2019)
- Analysis framework based on course lectures and Enders (2015)

---

**Ready to Run**: All files are configured and ready for execution. Follow the steps above to generate your complete time series analysis report!
