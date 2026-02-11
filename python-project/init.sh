#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: ./init.sh <project-name>"
    echo "Example: ./init.sh my-cool-project"
    exit 1
fi

PROJECT_NAME="$1"
MODULE_NAME=$(echo "$PROJECT_NAME" | tr '-' '_' | tr '[:upper:]' '[:lower:]')

# Rename the package directory
mv project_name "$MODULE_NAME"

# Update project_name references everywhere
sed -i '' "s/name = \"project_name\"/name = \"$PROJECT_NAME\"/" pyproject.toml
sed -i '' "s|\"project_name\"|\"$MODULE_NAME\"|" pyproject.toml
find tests -name '*.py' -exec sed -i '' "s/project_name/$MODULE_NAME/g" {} +

# Set up the environment
uv sync

echo ""
echo "Project '$PROJECT_NAME' initialized!"
echo "  Module: $MODULE_NAME/"
echo "  Activate: source .venv/bin/activate"
