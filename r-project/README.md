# project_name

## Setup

```bash
./init.sh <project-name>
```

## Usage

Open `project_name.Rproj` in RStudio, then:

```r
renv::restore()        # install all required packages
source("R/load_data.R")
```

## Project Structure

```
├── data/
│   ├── raw/            <- Original, immutable data
│   └── processed/      <- Final datasets for analysis
├── models/             <- Trained models and outputs
├── notebooks/          <- R Markdown / Quarto notebooks
├── reports/
│   └── figures/        <- Generated figures
└── R/                  <- R source scripts
    └── load_data.R     <- Data loading entry point
```
