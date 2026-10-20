# Project Templates

One command creates a fully configured project with the right directory structure, tooling, and git setup.

## Quick Start

```bash
./create my-project --lang python      # Python project
./create my-project --lang r           # R project
./create my-project --lang python-r    # Python-primary with R support
./create my-project --lang python --dir /path/to/parent  # override output directory
./create my-project --lang python --no-quarto            # skip Quarto site
```

**Prerequisites (system wide):**

- Python 3 for the `create` script. It needs [PyYAML](https://pypi.org/project/PyYAML/); if PyYAML isn't installed, `create` runs itself through `uv` to get it
- [Quarto CLI](https://quarto.org/docs/get-started/)
- `uv` for Python projects; R + `renv` for R/Python+R projects

## Configuration

`config.yaml` controls defaults for all templates:

| Key | Description |
|-----|-------------|
| `default_project_dir` | Where projects are created |
| `default_remote` | Git remote base URL (e.g. `git@github.com:user`) |
| `author.name` | Author name (used in Quarto documents) |
| `author.email` | Author email |
| `python.python_version` | Python version for new projects |
| `r.use_renv` | Initialise renv on R project creation |
| `python_r.use_renv` | Initialise renv on Python+R project creation |
| `quarto.use_quarto` | Add Quarto website to new projects (default: true) |


## Templates

### Python (`python-project/`)

Data science project using `uv`, `hatch`, `ruff`, and `pytest`.

```
<project>/
├── <module>/               # Source package
│   ├── __init__.py
│   └── config.py           # Project paths and logging
├── tests/
├── data/{raw,interim,processed,external}/
├── models/
├── notebooks/
├── reports/figures/
├── quarto/                 # Quarto website (see below)
├── Makefile                # format, lint, test, clean
└── pyproject.toml
```

### R (`r-project/`)

R data project with optional `renv` integration.

```
<project>/
├── R/
│   └── load_data.R
├── data/{raw,processed}/
├── models/
├── notebooks/
├── reports/figures/
├── quarto/                 # Quarto website (see below)
├── <project>.Rproj
└── README.md
```

### Python + R (`python-r-project/`)

Python-primary project with R available as a peer environment. Python handles data
processing and modelling; R handles statistical analysis. Data is shared via files
in `data/processed/`. Both languages can be used in the same Quarto document.

```
<project>/
├── <module>/               # Python source package
│   ├── __init__.py
│   └── config.py           # Project paths and logging
├── R/
│   ├── config.R            # R-side paths (mirrors config.py, uses 'here')
│   └── load_data.R
├── tests/
├── data/{raw,interim,processed,external}/
├── models/
├── notebooks/
├── reports/figures/
├── quarto/                 # Quarto website (see below)
├── .Rprofile               # Activates renv automatically
├── Makefile                # format, lint, test, r-restore, clean
└── pyproject.toml
```

### Quarto website (`quarto-site/`)

A Quarto website added automatically to every project under `quarto/`. Figures
saved to `reports/figures/` are accessible from all sections of the site via a
`quarto/figures/` symlink created at project initialisation.

```
quarto/
├── index.qmd               # Home page
├── figures -> ../reports/figures   # Symlink to project figures
├── progress/               # Progress reports (auto-listed)
├── presentations/          # RevealJS talks (auto-listed)
├── papers/                 # Journal articles and preprints (auto-listed)
├── abstracts/              # Conference abstracts (auto-listed)
├── styles.css
└── _quarto.yml             # Site config, navbar, default format
```

To preview: `cd quarto && quarto preview`

#### Scaffolding new content

```bash
cd quarto
./new paper <slug>          # new paper directory
./new presentation <slug>   # new RevealJS talk
./new abstract <slug>       # new conference abstract
```

- **`paper`**
  -
- **`presentation`**
  -
- **`abstract`**
  -

#### Paper export formats

Papers render to multiple output formats automatically, adding an "Other Formats" download panel to the HTML output:

- **HTML** —
- **DOCX** —
- **PDF (Typst)** —

**Todo:** author affiliations aren't going great

To customise DOCX output, add a `reference.docx` to `quarto/papers/` (see `quarto/papers/example-paper/_metadata.yaml`). To disable exports for a specific version, override `format:` in that version file's frontmatter.



## Standalone Usage

The template init scripts still work independently:

```bash
cd python-project   && ./init.sh my-project
cd r-project        && ./init.sh my-project true
cd python-r-project && ./init.sh my-project true
```
