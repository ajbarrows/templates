# R-side project configuration
# Mirrors project_name/config.py — keep paths in sync.
#
# Uses the 'here' package to locate the project root via .git or .here.
# Install with: install.packages("here")

if (!requireNamespace("here", quietly = TRUE)) {
  stop("Install 'here': install.packages('here')", call. = FALSE)
}

PROJ_ROOT          <- here::here()
DATA_DIR           <- here::here("data")
RAW_DATA_DIR       <- here::here("data", "raw")
INTERIM_DATA_DIR   <- here::here("data", "interim")
PROCESSED_DATA_DIR <- here::here("data", "processed")
EXTERNAL_DATA_DIR  <- here::here("data", "external")
MODELS_DIR         <- here::here("models")
REPORTS_DIR        <- here::here("reports")
FIGURES_DIR        <- here::here("reports", "figures")
