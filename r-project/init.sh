#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: ./init.sh <project-name> [use_renv]"
    echo "Example: ./init.sh my-project true"
    exit 1
fi

PROJECT_NAME="$1"
USE_RENV="${2:-true}"

# Rename the placeholder .Rproj file
mv project_name.Rproj "$PROJECT_NAME.Rproj"

# Update README placeholder
sed -i '' "s/project_name/$PROJECT_NAME/g" README.md

# Initialize renv if requested
if [ "$USE_RENV" = "true" ]; then
    echo "Initializing renv..."
    Rscript -e "renv::init()"
fi

echo ""
echo "Project '$PROJECT_NAME' initialized!"
echo "  Open: $PROJECT_NAME.Rproj"
