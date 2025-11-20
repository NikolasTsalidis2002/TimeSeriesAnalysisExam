# Quick Start Guide

## 3-Step Process to Generate Your Analysis

### Step 1: Install Packages (5 minutes)

Open R or RStudio and run:

```r
setwd("/Users/nikolastsalidis/Desktop/University/Masters/3rd Semester/TimeSeriesForEconomicsBusinessFinance/Exam")
source("install_packages.R")
```

Wait for all packages to install. You'll see confirmation messages.

---

### Step 2: Test the Analysis (2 minutes) [OPTIONAL]

Verify everything works:

```r
source("test_analysis.R")
```

If this completes successfully, you're ready for Step 3.

---

### Step 3: Generate the Report (10 minutes)

#### Option A: Using RStudio (Recommended)

1. Open `TimeSeriesAnalysis.Rmd` in RStudio
2. Click the **Knit** button at the top
3. Select "Knit to HTML" (faster) or "Knit to PDF" (needs LaTeX)
4. Wait ~5-10 minutes while it runs all analyses
5. Review the output document

#### Option B: Using R Console

```r
# For HTML
rmarkdown::render("TimeSeriesAnalysis.Rmd", output_format = "html_document")

# For PDF (requires LaTeX)
rmarkdown::render("TimeSeriesAnalysis.Rmd", output_format = "pdf_document")
```

---

## That's It!

Your complete time series analysis report will be generated automatically.

## What You'll Get

- ✅ 10 sections of analysis
- ✅ 11 statistical tables
- ✅ 7+ professional figures
- ✅ Complete interpretations
- ✅ Answers to all research questions
- ✅ Ready for submission

---

## Need Help?

- **Packages won't install**: See README.md troubleshooting section
- **PDF won't knit**: Try HTML instead, or install TinyTeX: `tinytex::install_tinytex()`
- **Understanding the methods**: Read notebookGuideline.md for detailed explanations
- **Code questions**: Check comments in TimeSeriesAnalysis.Rmd

---

## Pro Tips

💡 **First time?** Use HTML output - it's faster and doesn't need LaTeX

💡 **Want to see results quickly?** Run test_analysis.R first

💡 **Knitting taking too long?** Reduce bootstrap runs from 1000 to 100 in the IRF section

💡 **Need to customize?** All interpretations are in plain text - easy to edit

---

**Ready? Run Step 1, then Step 3. You'll have your report in ~15 minutes!**
