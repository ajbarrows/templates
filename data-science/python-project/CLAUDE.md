# CLAUDE.md — project_name

## Data Security Rules

- **Never read files in `data/`** — use path constants from `project_name/config.py` in code instead
- **Never include data file contents in responses** — describe schemas and column names only
- **Never suggest committing data files** — they are gitignored by design
- **Treat `notebooks/` as potentially sensitive** — outputs may contain raw data
- **Check `data/SOURCES.md`** for classification and handling requirements before working with data

If uncertain whether something is sensitive, assume it is.

## Project Structure

```
project_name/
├── project_name/        <- Python package
│   └── config.py        <- All path constants (PROJ_ROOT, DATA_DIR, etc.)
├── data/
│   ├── raw/             <- Original, immutable inputs — never modify
│   ├── interim/         <- Intermediate transformations
│   ├── processed/       <- Final analysis-ready data
│   └── external/        <- Third-party reference data
├── notebooks/           <- Jupyter notebooks (outputs stripped on commit)
├── models/              <- Trained models (gitignored)
├── reports/figures/     <- Generated figures
└── tests/
```

## Commands

```bash
make format   # ruff format + ruff check --fix
make lint     # ruff check
make test     # pytest
make clean    # remove caches
```

## Configuration

All paths are defined in `project_name/config.py` (`PROJ_ROOT`, `DATA_DIR`, `RAW_DATA_DIR`, etc.). Use these constants — never hardcode paths. Credentials go in `.env` (see `.env.example`). The logger is re-exported from `config.py` via loguru.
