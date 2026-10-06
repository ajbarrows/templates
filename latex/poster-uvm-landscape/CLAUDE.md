# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a LaTeX academic poster template using the `tikzposter` document class, configured for landscape A0 format with UVM (University of Vermont) branding colors.

## Build Commands

Compile the poster to PDF:
```bash
pdflatex poster.tex
```

If using bibliography:
```bash
pdflatex poster.tex && bibtex poster && pdflatex poster.tex && pdflatex poster.tex
```

## Architecture

**Main document:** `poster.tex` - the root file that assembles all components

**Modular content files** (included via `\include`):
- `poster.title.tex` - title block with author info
- `poster.introduction.tex` - introduction block
- `poster.methods.tex` - methods section with three-column layout
- `poster.results.tex` - results section with figures and text columns

**Theme configuration** in `includes/`:
- `uvmcolors.tex` - UVM brand color definitions (uvm-green, bright-green, sky-blue, etc.)
- `theme.tex` - tikzposter theme settings using the Simple theme with UVM colors

**Figures:** Place in `figures/` or `figures/graphics/` directories (configured via `\graphicspath`)

## Key Patterns

- Sections are defined using `\block{Title}{content}`
- Multi-column layouts use `\begin{columns}` with `\column{width}` commands
- Figures use `tikzfigure` environment: `\begin{tikzfigure}[Caption]`
- Notes/callouts use `\note[positioning options]{content}`
- Bibliography uses natbib with `abbrvnat` style and `\nobibliography{bibliography}`
