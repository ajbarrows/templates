# Templates

Starting points for research projects, posters, and presentations.

| Template | Path | Use it for |
|----------|------|------------|
| Data science projects | [`data-science/`](data-science/) | Python, R, or Python+R projects with an optional Quarto site, created with `./create` |
| Poster (portrait) | [`latex/poster-uvm-portrait/`](latex/poster-uvm-portrait/) | A0 portrait `tikzposter` with UVM colors |
| Poster (landscape) | [`latex/poster-uvm-landscape/`](latex/poster-uvm-landscape/) | A0 `tikzposter` with UVM colors, with one file per section |
| Presentation | [`latex/beamer-uvm/`](latex/beamer-uvm/) | Beamer (metropolis) slides with UVM colors |

## Data science projects

```bash
data-science/create my-project --lang python   # or r, python-r
```

For options and configuration, see [`data-science/README.md`](data-science/README.md).

## LaTeX templates

Copy the folder and build it:

```bash
cp -R latex/poster-uvm-landscape ~/path/to/my-poster
cd ~/path/to/my-poster
pdflatex poster.tex && bibtex poster && pdflatex poster.tex && pdflatex poster.tex
```

Build artifacts (`*.aux`, `*.log`, the compiled PDF) are git-ignored.
