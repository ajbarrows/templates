# Plan: Data Security Guardrails for Project Templates

## Context

Tony supplies central data repositories at his organization and can't directly mandate how others handle data. LLMs (Claude Code, ChatGPT, Copilot) create a new exposure vector: users who open a project in an AI-assisted editor may unknowingly let the tool read raw data files, or paste data into a chat. His primary lever for influence is these project templates — every project bootstrapped here inherits whatever guardrails are built in.

**Current state:** Strong passive protections already exist (`data/**` gitignored, `.env` gitignored, path constants via `config.py`/`config.R`). A well-structured `.claudeignore` exists at the repo root but is untracked and not propagated into spawned projects. No active enforcement layer exists.

**Goal:** Add three layers to every spawned project — *prevent* accidental exposure, *orient* LLMs with explicit rules, and *document* data sensitivity at the source.

---

## Layer 1: LLM Orientation (CLAUDE.md + .claudeignore in templates)

### `.claudeignore` per template
Copy the root `.claudeignore` into each template directory with one addition:
```
# Jupyter notebooks (code may reference sensitive data)
notebooks/*.ipynb
```
Files to create (identical content):
- `python-project/.claudeignore`
- `r-project/.claudeignore`
- `python-r-project/.claudeignore`
- `quarto-site/.claudeignore`

The `create` script copies dotfiles automatically via `shutil.copytree` — no script change needed for propagation. Also commit the root `.claudeignore` (`git add .claudeignore`).

### `CLAUDE.md` per template
Each spawned project needs a `CLAUDE.md` that Claude reads before doing anything. It should contain:
1. **Data security rules first** — never read `data/`, describe schemas not values, never suggest committing data files, treat notebooks as sensitive
2. Project structure overview
3. Commands (make targets)
4. A pointer to `data/SOURCES.md` for data classification

Files to create:
- `python-project/CLAUDE.md` — uses `project_name` token (substituted to module_name)
- `r-project/CLAUDE.md` — uses `project_name` token
- `python-r-project/CLAUDE.md` — uses `project_name` token

**`create` script change** — after the existing substitution block in each `create_*` function, add substitution for `CLAUDE.md` and `data/SOURCES.md`:

```python
# In create_python_project and create_python_r_project (uses module_name):
for path in [target_dir / "CLAUDE.md", target_dir / "data" / "SOURCES.md"]:
    if path.exists():
        path.write_text(path.read_text().replace("project_name", module_name))

# In create_r_project (uses project_name directly):
for path in [target_dir / "CLAUDE.md", target_dir / "data" / "SOURCES.md"]:
    if path.exists():
        path.write_text(path.read_text().replace("project_name", project_name))
```

---

## Layer 2: Active Code Guardrails (pre-commit hooks)

### `.pre-commit-config.yaml` per Python template
Use the `pre-commit` framework. Add to Python and python-r templates:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: check-added-large-files
        args: ["--maxkb=500"]
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.5.0
    hooks:
      - id: detect-secrets
        args: ["--baseline", ".secrets.baseline"]
  - repo: https://github.com/kynan/nbstripout
    rev: 0.7.1
    hooks:
      - id: nbstripout
```

For R template: same file but without nbstripout.

### `pyproject.toml` change (Python templates)
Add to `[dependency-groups] dev`:
```toml
dev = [
    "pytest",
    "ruff",
    "pre-commit",
    "detect-secrets",
    "nbstripout",
]
```
Apply to both `python-project/pyproject.toml` and `python-r-project/pyproject.toml`.

### `create` script: `setup_precommit` helper
Add a helper called after each `create_*` function:

```python
def setup_precommit(target_dir):
    result = subprocess.run(["pre-commit", "install"], cwd=target_dir)
    if result.returncode != 0:
        return False
    # Seed an empty baseline so detect-secrets hook doesn't error on first run
    baseline = target_dir / ".secrets.baseline"
    if not baseline.exists():
        with baseline.open("w") as f:
            subprocess.run(["detect-secrets", "scan"], stdout=f, cwd=target_dir)
    return True
```

Add to `main()` post-creation print:
```
Next steps:
  1. Fill in data/SOURCES.md with data classification
  2. Copy .env.example → .env and add credentials
  3. If pre-commit failed: pip install pre-commit && pre-commit install
```

### Jupyter notebook strategy
Use **nbstripout** (Option B): strip outputs on commit, track notebook code. The notebook code itself is valuable to version; outputs are the security risk. Add to `.gitignore` a comment pointing to this choice:
```
# Jupyter outputs are stripped on commit by nbstripout (see .pre-commit-config.yaml)
# To gitignore notebooks entirely instead: uncomment the next line
# notebooks/*.ipynb
```

---

## Layer 3: Documentation Templates

### `data/SOURCES.md`
Committed file in each template. Serves as the provenance record and sensitivity reminder. Content sketch (with `project_name` token):

```markdown
# Data Sources — project_name

## Classification

| Dataset | Source | Classification | License/DUA | Contains PII? |
|---------|--------|----------------|-------------|---------------|
| | | | | |

### Levels: Public · Internal Unrestricted · Internal Restricted · Confidential

## Directory Layout
- raw/       — original, immutable
- interim/   — in-progress transforms
- processed/ — analysis-ready
- external/  — third-party reference data

## LLM Tool Use
Claude Code (via .claudeignore) does not read data/ files.
If an LLM asks to read a data file, describe the schema manually instead.
```

Files to create: `python-project/data/SOURCES.md`, `r-project/data/SOURCES.md`, `python-r-project/data/SOURCES.md`

### `.env.example`
Python and python-r templates. Categories: data repo credentials, object storage, external APIs (OpenNeuro, XNAT, REDCap), database URL, HPC, project env/log level. `.env` already gitignored.

R template gets a `.Renviron.example` (same categories, R convention). Add `.env` to `r-project/.gitignore` since mixed workflows sometimes use it.

---

## R Template Parity

**Add missing data dirs** — `r-project/data/interim/.gitkeep` and `r-project/data/external/.gitkeep`. Consistent with Python template and with config constants that reference them.

**Add `R/config.R`** — copy from `python-r-project/R/config.R` verbatim. The pure R template currently has no centralized path constants, which leads to hardcoded paths in `load_data.R`. Adding `config.R` here closes that gap.

**No `create` script change needed** — these files copy automatically.

**`r-project/README.md` update** — add `R/config.R` to the structure section, show four data subdirs.

---

## Organizational Layer (non-template)

These don't change the templates but inform how Tony manages the data supply side:

- **Tiered data products**: Never give collaborators Tier 0 (raw/identified). Supply Tier 1 (de-identified) for analysis and Tier 2 (synthetic) for development/LLM use. Collaborators should only have real data in `data/raw/` when they've explicitly obtained access.
- **Synthetic data for development**: A small synthetic dataset in `data/external/synthetic/` allows LLM-assisted coding without any real data exposure. Request from data custodian at project start.
- **The CLAUDE.md IS the policy**: Because Claude Code reads CLAUDE.md before every session, it functions as a standing instruction that doesn't require the user to read documentation. This is the most effective soft-enforcement mechanism available without admin authority.

---

## Files Changed / Created

| File | Action |
|------|--------|
| `.claudeignore` | commit (already written) |
| `python-project/.claudeignore` | create |
| `r-project/.claudeignore` | create |
| `python-r-project/.claudeignore` | create |
| `quarto-site/.claudeignore` | create |
| `python-project/CLAUDE.md` | create |
| `r-project/CLAUDE.md` | create |
| `python-r-project/CLAUDE.md` | create |
| `python-project/.pre-commit-config.yaml` | create |
| `r-project/.pre-commit-config.yaml` | create |
| `python-r-project/.pre-commit-config.yaml` | create |
| `python-project/pyproject.toml` | modify (add dev deps) |
| `python-r-project/pyproject.toml` | modify (add dev deps) |
| `python-project/data/SOURCES.md` | create |
| `r-project/data/SOURCES.md` | create |
| `python-r-project/data/SOURCES.md` | create |
| `python-project/.env.example` | create |
| `r-project/.Renviron.example` | create |
| `python-r-project/.env.example` | create |
| `r-project/data/interim/.gitkeep` | create |
| `r-project/data/external/.gitkeep` | create |
| `r-project/R/config.R` | create (copy from python-r-project) |
| `r-project/.gitignore` | modify (add `.env`) |
| `r-project/README.md` | modify (structure section) |
| `create` | modify (CLAUDE.md/SOURCES.md substitution + setup_precommit) |

---

## Verification

After implementation:
1. `./create test-project --lang python --dir /tmp` — confirm new project contains `.claudeignore`, `CLAUDE.md`, `.pre-commit-config.yaml`, `data/SOURCES.md`, `.env.example`
2. Open the spawned project in Claude Code — confirm CLAUDE.md appears with data rules and `project_name` tokens are substituted
3. In the spawned project, try `git add data/test.csv` — should be blocked by `.gitignore`
4. Run `pre-commit run --all-files` in the spawned project — all hooks should pass on clean state
5. Same test with `--lang r` and `--lang python-r`
