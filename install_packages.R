# Install required packages for TimeSeriesAnalysis.Rmd

cat("Installing required R packages...\n\n")

# List of required packages
packages <- c(
  "urca",       # Unit root and cointegration tests
  "vars",       # VAR/VECM models
  "rugarch",    # GARCH models
  "fGarch",     # Alternative GARCH
  "FinTS",      # ARCH-LM tests (alternative to aTSA)
  "forecast",   # ARMA model selection
  "dplyr",      # Data manipulation
  "tidyr",      # Data tidying
  "zoo",        # Time series objects
  "pracma",     # Detrending
  "ggplot2",    # Plotting
  "ggfortify",  # Time series plotting
  "gridExtra",  # Multiple plots
  "corrplot",   # Correlation plots
  "moments",    # Skewness and kurtosis
  "knitr",      # Tables
  "rmarkdown"   # R Markdown
)

# Function to install packages if not already installed
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", pkg, "...\n")
    install.packages(pkg, repos = "https://cloud.r-project.org/", dependencies = TRUE)
    if (require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat(pkg, "installed successfully!\n")
    } else {
      cat("Failed to install", pkg, "\n")
    }
  } else {
    cat(pkg, "already installed\n")
  }
}

# Install all packages
for (pkg in packages) {
  install_if_missing(pkg)
}

cat("\n========================================\n")
cat("Package installation completed!\n")
cat("========================================\n")
