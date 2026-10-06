# CLAUDE.md — project_name

## Data Security Rules

- **Never read files in `data/`** — use path constants from `R/config.R` in code instead
- **Never include data file contents in responses** — describe schemas and column names only
- **Never suggest committing data files** — they are gitignored by design
- **Check `data/SOURCES.md`** for classification and handling requirements before working with data

If uncertain whether something is sensitive, assume it is.

## Project Structure

```
project_name/
├── R/
│   ├── config.R         <- All path constants (PROJ_ROOT, DATA_DIR, etc.)
│   └── load_data.R      <- Data loading entry point
├── data/
│   ├── raw/             <- Original, immutable inputs — never modify
│   ├── interim/         <- Intermediate transformations
│   ├── processed/       <- Final analysis-ready data
│   └── external/        <- Third-party reference data
├── models/              <- Trained models (gitignored)
├── notebooks/           <- R Markdown / Quarto notebooks
└── reports/figures/     <- Generated figures
```

## Usage

```r
renv::restore()        # install packages
source("R/config.R")   # load path constants
source("R/load_data.R")
```

## Configuration

All paths are defined in `R/config.R` using `here::here()`. Use these constants — never hardcode paths. Credentials go in `.Renviron` (see `.Renviron.example`).
