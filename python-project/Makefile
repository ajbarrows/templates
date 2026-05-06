.PHONY: format lint test clean help

## format : run ruff formatter and fix lint issues
format:
	uv run ruff format .
	uv run ruff check --fix .

## lint : check for lint errors
lint:
	uv run ruff check .

## test : run tests
test:
	uv run pytest

## clean : remove build artifacts
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf dist build

## Set up Python interpreter environment
.PHONY: create_environment
create_environment:
	uv sync --all-groups
	uv run python -m ipykernel install --user --name {project_name} --display-name "{project_name}"
	@echo ">>> uv environment created. Run commands with:\nuv run python ..."

## Register the uv venv as a Jupyter kernel for Quarto
.PHONY: register_kernel
register_kernel:
	uv run python -m ipykernel install --user --name {project_name} --display-name "{project_name}"

## Render the Quarto website using the uv venv
.PHONY: render
render:
	QUARTO_PYTHON=$(shell pwd)/.venv/bin/python quarto render quarto/

## Preview the Quarto website using the uv venv
.PHONY: preview
preview:
	QUARTO_PYTHON=$(shell pwd)/.venv/bin/python quarto preview quarto/



## help : show this help message
help:
	@sed -n 's/^## //p' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
