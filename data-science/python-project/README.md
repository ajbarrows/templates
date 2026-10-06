# project_name

## Setup

```bash
./init.sh <project-name>
```

## Usage

```bash
make help       # show available commands
make format     # format code with ruff
make lint       # check for lint errors
make test       # run tests with pytest
make clean      # remove build artifacts
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
├── reports/
│   └── figures/        <- Generated figures
├── <module_name>/      <- Source code package
│   ├── __init__.py
│   └── config.py       <- Project paths and logging
└── tests/              <- Test suite
```
