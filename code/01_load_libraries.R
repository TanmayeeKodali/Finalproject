# 01_load_libraries.R
# Load and install required packages for SARS-CoV-2 variant analysis

# List of required packages
packages <- c(
  "tidyverse",
  "gtsummary", 
  "kableExtra",
  "labelled",
  "scales",
  "plotly",
  "here",
  "readxl"
)

# Install packages if not already installed
install_if_missing <- function(pkg) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Apply to all packages
invisible(sapply(packages, install_if_missing))

cat("All required packages loaded successfully!\n")
cat("Loaded packages:", paste(packages, collapse = ", "), "\n")