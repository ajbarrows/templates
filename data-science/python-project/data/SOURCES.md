# Data Sources — project_name

## Classification

| Dataset | Source | Classification | License / DUA | Contains PII? | Notes |
|---------|--------|----------------|---------------|---------------|-------|
| | | | | | |

### Classification levels

| Level | Description |
|-------|-------------|
| Public | Freely available, no restrictions |
| Internal Unrestricted | Org data, not sensitive, shareable within org |
| Internal Restricted | Requires DUA, IRB, or access approval; do not share |
| Confidential | Identified PII / PHI / commercial IP — maximum care |

## Directory Layout

```
data/
├── raw/        <- Original, immutable source files. Never modify.
├── interim/    <- Transformed but not final; may derive from restricted data.
├── processed/  <- Final analysis-ready datasets.
└── external/   <- Third-party reference data (atlases, normative datasets, etc.)
```

## Access and Download

Describe how to obtain each dataset, including links, credential requirements,
and any required data use agreements. This file is committed to git — do not
paste data here.

## LLM Tool Use

Claude Code (via `.claudeignore`) does not read files in `data/`. If an LLM
asks to read a data file, describe the schema manually instead. For
LLM-assisted analysis, use synthetic or anonymized data only.
