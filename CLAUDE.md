# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo contains PhD project templates — scaffolding scripts for bootstrapping new research projects. There are two templates:

- **python-project/** — Python data science project template (uses `uv` and `hatch`)
- **r-project/** — R data project template (uses `renv`, optionally `targets`)

These are **templates**, not active projects. Changes here affect the starting point of future projects.

## Unified Create Script

The preferred way to create new projects:

```bash
./create my-project --lang python          # creates in default_project_dir from config.yaml
./create my-project --lang r               # R project
./create my-project --lang python --dir /tmp  # override target directory
```

Requires PyYAML (`pip install pyyaml` or available via `uv`).

### `config.yaml` — shared configuration

Controls defaults for both templates: `default_project_dir`, `default_remote` (for git), author info, and language-specific options (Python version, renv/targets for R). Edit this file to customize your setup.

### What it does

1. Copies the language template to `<target_dir>/<name>/`
2. Runs language-specific initialization (module rename + `uv sync` for Python; directory scaffold + optional `renv::init()` for R)
3. Initializes a git repo and sets remote from config

The standalone scripts (`python-project/init.sh`, `r-project/create_project.sh`) still work independently.

## Python Template

### Key Commands (all via `uv run` through Makefile)

```bash
make format    # ruff format + ruff check --fix
make lint      # ruff check
make test      # pytest
make clean     # remove __pycache__, .ruff_cache, .pytest_cache, etc.
```

### Initialization

`./init.sh <project-name>` renames the `project_name/` package, updates references in `pyproject.toml` and `tests/`, then runs `uv sync`.

### Architecture

- `project_name/config.py` — Central config: project paths (PROJ_ROOT, DATA_DIR, etc.) and loguru logger re-export. All path constants derive from `PROJ_ROOT`.
- `pyproject.toml` — Hatchling build, ruff config (line-length 99, py311+, E/F/I/W rules), pytest config.
- Data directory convention: `data/{raw,interim,processed,external}` — raw is immutable.

## R Template

Two creation methods with identical directory structure:

- `create_project.sh <name> [use_renv]` — Bash script, creates `.Rproj`, optionally inits `renv`
- `create_data_project()` — R function using `usethis::create_project()`, supports `renv`, `targets`, and license setup

Both produce: `data/{raw,processed}`, `R/`, `reports/figures/`, `models/`, `notebooks/`.

## Style

- Python: ruff with `line-length = 99`, `target-version = "py311"`, lint rules `E, F, I, W`
- Python package manager: `uv` (not pip)
