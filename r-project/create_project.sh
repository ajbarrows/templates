#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${1:-start-demo}"
USE_RENV="${2:-true}"

# Create main directory
mkdir -p "$PROJECT_NAME"

# Create directory structure
for dir in data data/raw data/processed R reports reports/figures models notebooks; do
  mkdir -p "$PROJECT_NAME/$dir"
  touch "$PROJECT_NAME/$dir/.gitkeep"
done

# Create .Rproj file
cat > "$PROJECT_NAME/$PROJECT_NAME.Rproj" << 'EOF'
Version: 1.0

RestoreWorkspace: Default
SaveWorkspace: Default
AlwaysSaveHistory: Default

EnableCodeIndexing: Yes
UseSpacesForTab: Yes
NumSpacesForTab: 2
Encoding: UTF-8

RnwWeave: Sweave
LaTeX: pdfLaTeX
EOF

# Initialize renv if requested
if [ "$USE_RENV" = "true" ]; then
  (cd "$PROJECT_NAME" && Rscript -e "renv::init()")
fi

# Create README
cat > "$PROJECT_NAME/README.md" << EOF
# $PROJECT_NAME

## Getting Started

### 1. Clone this repository
\`\`\`bash
git clone <repository-url>
cd $PROJECT_NAME
\`\`\`

### 2. Set up R environment
- Open \`$PROJECT_NAME.Rproj\` in RStudio
- Run: \`renv::restore()\` (this installs all required packages)

### 3. Initialize project data
- Run: \`source('R/load_data.R')\`

You're ready to go!
EOF

# Create starter load_data.R
cat > "$PROJECT_NAME/R/load_data.R" << 'EOF'
# Data loading script
# Add your data loading code here
EOF

# Copy .gitignore
cp .gitignore_template "$PROJECT_NAME/.gitignore"

echo "Project '$PROJECT_NAME' created successfully."
