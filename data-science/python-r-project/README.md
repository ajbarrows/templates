# project_name

Python-primary project with R support for statistical analysis.

## Setup

```bash
./init.sh <project-name>
```

## Usage

```bash
make help        # show available commands
make format      # format Python code with ruff
make lint        # check for lint errors
make test        # run tests with pytest
make r-restore   # restore R packages from renv.lock
make clean       # remove build artifacts
```

## Project Structure

```
├── data/
│   ├── raw/            <- Original, immutable data
│   ├── interim/        <- Intermediate, transformed data
│   ├── processed/      <- Final datasets for modeling
│   └── external/       <- Data from third-party sources
├── models/             <- Trained models and predictions
├── notebooks/          <- Jupyter notebooks
├── quarto/             <- Quarto website (progress, presentations, papers)
├── reports/
│   └── figures/        <- Generated figures
├── R/
│   ├── config.R        <- R-side project paths (mirrors config.py)
│   └── load_data.R     <- Data loading entry point
├── <module_name>/      <- Python source package
│   ├── __init__.py
│   └── config.py       <- Project paths and logging
└── tests/              <- Python test suite
```

## Workflow

Python handles data processing and modelling; R handles statistical analysis.
Data is shared via files in `data/processed/`. Figures saved to `reports/figures/`
are accessible from the Quarto site via `quarto/figures/`.
