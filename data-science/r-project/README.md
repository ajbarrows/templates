# project_name

## Setup

```bash
./init.sh <project-name>
```

## Usage

Open `project_name.Rproj` in RStudio, then:

```r
renv::restore()        # install all required packages
source("R/config.R")   # load path constants (PROJ_ROOT, DATA_DIR, etc.)
source("R/load_data.R")
```

## Project Structure

```
├── R/
│   ├── config.R        <- All path constants (PROJ_ROOT, DATA_DIR, etc.)
│   └── load_data.R     <- Data loading entry point
├── data/
│   ├── raw/            <- Original, immutable data
│   ├── interim/        <- Intermediate transformations
│   ├── processed/      <- Final datasets for analysis
│   └── external/       <- Third-party reference data
├── models/             <- Trained models and outputs (gitignored)
├── notebooks/          <- R Markdown / Quarto notebooks
└── reports/
    └── figures/        <- Generated figures
```
