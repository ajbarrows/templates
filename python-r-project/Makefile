.PHONY: format lint test clean r-restore help

## format     : run ruff formatter and fix lint issues
format:
	uv run ruff format .
	uv run ruff check --fix .

## lint        : check for lint errors
lint:
	uv run ruff check .

## test        : run Python tests
test:
	uv run pytest

## r-restore   : restore R packages from renv.lock
r-restore:
	Rscript -e "renv::restore()"

## clean       : remove build artifacts
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf dist build

## help        : show this help message
help:
	@sed -n 's/^## //p' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
