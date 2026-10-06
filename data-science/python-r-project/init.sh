#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: ./init.sh <project-name> [use_renv]"
    echo "Example: ./init.sh my-project true"
    exit 1
fi

PROJECT_NAME="$1"
USE_RENV="${2:-true}"
MODULE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')

# Rename the Python package
mv project_name "$MODULE_NAME"

# Update project_name references
sed -i '' "s/name = \"project_name\"/name = \"$PROJECT_NAME\"/" pyproject.toml
sed -i '' "s|\"project_name\"|\"$MODULE_NAME\"|" pyproject.toml
find tests -name '*.py' -exec sed -i '' "s/project_name/$MODULE_NAME/g" {} +
sed -i '' "s/project_name/$PROJECT_NAME/g" README.md

# Set up Python environment
uv sync

# Initialize renv for R packages
if [ "$USE_RENV" = "true" ]; then
    echo "Initializing renv..."
    Rscript -e "renv::init()"
fi

echo ""
echo "Project '$PROJECT_NAME' initialized!"
echo "  Python module: $MODULE_NAME/"
echo "  Activate Python: source .venv/bin/activate"
echo "  R packages: make r-restore"
