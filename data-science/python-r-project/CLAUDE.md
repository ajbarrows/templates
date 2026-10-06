# CLAUDE.md — project_name

## Data Security Rules

- **Never read files in `data/`** — use path constants from `project_name/config.py` or `R/config.R`
- **Never include data file contents in responses** — describe schemas and column names only
- **Never suggest committing data files** — they are gitignored by design
- **Treat `notebooks/` as potentially sensitive** — outputs may contain raw data
- **Check `data/SOURCES.md`** for classification and handling requirements before working with data

If uncertain whether something is sensitive, assume it is.

## Project Structure

```
project_name/
├── project_name/        <- Python package
│   └── config.py        <- Python path constants (PROJ_ROOT, DATA_DIR, etc.)
├── R/
│   ├── config.R         <- R path constants (mirrors config.py via here::here())
│   └── load_data.R      <- R data loading entry point
├── data/
│   ├── raw/             <- Original, immutable inputs — never modify
│   ├── interim/         <- Intermediate transformations
│   ├── processed/       <- Final analysis-ready data
│   └── external/        <- Third-party reference data
├── notebooks/           <- Jupyter notebooks (outputs stripped on commit)
├── models/              <- Trained models (gitignored)
└── reports/figures/     <- Generated figures
```

## Commands

```bash
make format     # ruff format + ruff check --fix
make lint       # ruff check
make test       # pytest
make r-restore  # renv::restore()
make clean      # remove caches
```

## Configuration

Python paths: `project_name/config.py`. R paths: `R/config.R` (identical structure, both project-relative). Keep them in sync. Credentials go in `.env` (see `.env.example`).
