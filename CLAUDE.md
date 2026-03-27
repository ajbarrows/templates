# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo contains PhD project templates — scaffolding scripts for bootstrapping new research projects. There are three templates:

- **python-project/** — Python data science project template (uses `uv` and `hatch`)
- **r-project/** — R data project template (uses `renv`, optionally `targets`)
- **python-r-project/** — Python-primary project with R support (uses `uv` + `renv`, side-by-side)
- **quarto-site/** — Quarto website template (added automatically to all project types)

These are **templates**, not active projects. Changes here affect the starting point of future projects.

## Unified Create Script

The preferred way to create new projects:

```bash
./create my-project --lang python          # creates in default_project_dir from config.yaml
./create my-project --lang r               # R project
./create my-project --lang python-r        # Python-primary with R support
./create my-project --lang python --dir /tmp  # override target directory
./create my-project --lang python --no-quarto  # skip Quarto site
```

Requires PyYAML (`pip install pyyaml` or available via `uv`).

### `config.yaml` — shared configuration

Controls defaults for both templates: `default_project_dir`, `default_remote` (for git), author info, and language-specific options (Python version, renv/targets for R). Edit this file to customize your setup.

### What it does

1. Copies the language template to `<target_dir>/<name>/`
2. Runs language-specific initialization (module rename + `uv sync` for Python; `.Rproj` rename + optional `renv::init()` for R)
3. Copies `quarto-site/` → `<target_dir>/<name>/quarto/` and substitutes `project_name`, `author_name`, and `project_github_url` tokens throughout
4. Initializes a git repo and sets remote from config

The standalone scripts (`python-project/init.sh`, `r-project/init.sh`) still work independently.

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

The r-project/ directory contains the visible file structure that is copied directly (like the Python template):

- `project_name.Rproj` — placeholder renamed to `{project_name}.Rproj` on init
- `R/load_data.R` — data loading entry point
- `data/{raw,processed}/`, `reports/figures/`, `models/`, `notebooks/` — tracked via `.gitkeep`
- `.gitignore` — R-appropriate ignores (history, session data, renv, data/models)
- `README.md` — `project_name` placeholder substituted on init

### Initialization

`./init.sh <project-name> [use_renv]` renames `project_name.Rproj`, updates the README, and optionally runs `renv::init()`.

## Python+R Template

`python-r-project/` is a Python-primary project with R available as a peer environment.

- Python: `uv`, `hatch`, `pyproject.toml`, same package/config/test structure as the Python template
- R: `R/config.R` mirrors `config.py` path constants using the `here` package; `R/load_data.R` is the data entry point; `.Rprofile` activates `renv` automatically
- Makefile: same Python targets plus `make r-restore` for `renv::restore()`
- `.gitignore`: combined Python + R ignores; `renv/library/` excluded, `renv.lock` tracked
- `config.yaml` → `python_r.use_renv` controls whether `renv::init()` runs on creation

Workflow: Python processes data → saves to `data/processed/` → R reads for statistical analysis → figures saved to `reports/figures/` → Quarto picks them up via `quarto/figures/` symlink.

## Quarto Template

`quarto-site/` is copied into every new project as `quarto/`. It is a Quarto website with three sections:

- **progress/** — Listing of `.qmd` progress reports; add new files and they appear automatically
- **presentations/** — Grid listing of RevealJS talks; each talk lives in `presentations/<slug>/index.qmd` with `format: revealjs`
- **papers/** — Two-level listing of journal articles and preprints:
  - `papers/index.qmd` → one row per paper (reads `*/index.qmd`)
  - `papers/<slug>/index.qmd` → paper overview page; embeds a sub-listing of version files in the same directory
  - `papers/<slug>/<version>.qmd` → individual version files (any name, e.g. `v1-draft.qmd`, `v2-submitted.qmd`); title may change between versions; categories encode both version tag (`v1`, `v2`) and status (`draft`, `submitted`, …)
- **abstracts/** — Table listing of conference abstracts; each entry lives in `abstracts/<slug>/index.qmd`

### Placeholder tokens (substituted by `create`)

| Token | Source |
|---|---|
| `project_name` | CLI `name` argument |
| `author_name` | `config.yaml` → `author.name` |
| `project_github_url` | `config.yaml` → `default_remote/name` |

### Key files

- `_quarto.yml` — site config, navbar, format defaults; holds the project-wide `author:` default (top-level key, applied to all documents) and commented collaborator profile blocks for copy-paste
- `styles.css` — minimal custom CSS
- `progress/example-update.qmd` — example progress entry
- `presentations/example-talk/index.qmd` — example RevealJS deck
- `papers/example-paper/index.qmd` — paper overview (current status, embedded version listing)
- `papers/example-paper/v1-draft.qmd`, `v2-submitted.qmd` — example version files

### Author metadata

Two-level default system — no `author:` field needed in individual version files:

- **`_quarto.yml` top-level `author:`** — project-wide default; applies to every document that doesn't override it. Covers solo papers automatically.
- **`papers/<slug>/_metadata.yaml`** — paper-specific author list; overrides the global default for every version file in that directory. Create this file when a paper has co-authors.

Collaborator profile blocks are kept as comments in `_quarto.yml` for copy-paste into a paper's `_metadata.yaml`. When the author list changes between versions (rare), override `author:` in that specific version file's frontmatter.

To preview: `cd quarto && quarto preview`

### Collaborator DOCX workflow

`papers/collab` is a script for the send-DOCX-get-tracked-changes review cycle:

```bash
# 1. Render a version to DOCX and save as the baseline
papers/collab export my-paper v1-draft

# 2. Send papers/my-paper/collab/baseline.docx to collaborators.
#    When they return it with tracked changes, save as:
#    papers/my-paper/collab/returned.docx

# 3. Review changes (word-diff + annotated _review.md)
papers/collab review my-paper
```

The `review` command produces:
- A word-diff printed to the terminal (git word-diff or plain diff)
- `collab/_review.md` — full annotated version with `[text]{.insertion}` / `[text]{.deletion}` markup

Apply desired changes manually to the `.qmd` source; the `.qmd` is always the source of truth.
The `collab/` directory under each paper holds `baseline.docx` and `returned.docx` as artifacts.
Generated `_*.md` files are gitignored.

## Style

- Python: ruff with `line-length = 99`, `target-version = "py311"`, lint rules `E, F, I, W`
- Python package manager: `uv` (not pip)
