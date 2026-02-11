# PhD Project Templates

Scaffolding for bootstrapping new research projects. One command creates a fully configured project with the right directory structure, tooling, and git setup.

## Quick Start

```bash
./create my-project --lang python
./create my-project --lang r
./create my-project --lang python --dir /path/to/parent
```

Requires Python 3 and [PyYAML](https://pypi.org/project/PyYAML/). Edit `config.yaml` to set your default project directory, git remote, and language-specific options.

## Templates

### Python (`python-project/`)

Data science project using `uv`, `hatch`, `ruff`, and `pytest`.

```
<project>/
├── <module>/           # Source code package
│   ├── __init__.py
│   └── config.py       # Project paths and logging
├── tests/
├── data/{raw,interim,processed,external}/
├── models/
├── notebooks/
├── reports/figures/
├── Makefile            # format, lint, test, clean
└── pyproject.toml
```

### R (`r-project/`)

R data project with optional `renv` integration.

```
<project>/
├── R/
├── data/{raw,processed}/
├── models/
├── notebooks/
├── reports/figures/
├── <project>.Rproj
└── README.md
```

## Configuration

`config.yaml` controls defaults for both templates:

| Key | Description |
|-----|-------------|
| `default_project_dir` | Where projects are created |
| `default_remote` | Git remote base URL (e.g. `git@github.com:user`) |
| `python.python_version` | Python version for new projects |
| `r.use_renv` | Initialize renv on R project creation |
| `r.use_targets` | Reserved for targets pipeline support |

## Standalone Usage

The original template scripts still work independently:

```bash
cd python-project && ./init.sh my-project
cd r-project && ./create_project.sh my-project true
```
