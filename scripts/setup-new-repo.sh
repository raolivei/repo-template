#!/bin/bash
#
# Setup New Repository from Template
#
# This script automates the setup of a new repository from this template.
# It replaces PROJECT_NAME placeholders and initializes the repository.
#
# Usage:
#   ./scripts/setup-new-repo.sh PROJECT_NAME [GITHUB_USERNAME]
#
# Examples:
#   ./scripts/setup-new-repo.sh my-project
#   ./scripts/setup-new-repo.sh my-project raolivei

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
error() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check arguments
if [ $# -lt 1 ]; then
    error "Usage: $0 PROJECT_NAME [GITHUB_USERNAME]"
    echo ""
    echo "Examples:"
    echo "  $0 my-project"
    echo "  $0 my-project raolivei"
    exit 1
fi

PROJECT_NAME="$1"
GITHUB_USERNAME="${2:-raolivei}"

# Validate project name
if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9-]+$ ]]; then
    error "Project name must contain only lowercase letters, numbers, and hyphens"
fi

# Check if we're in a git repository
if [ ! -d .git ]; then
    warning "Not in a git repository. Initializing git repository..."
    git init
    success "Git repository initialized"
fi

info "Setting up repository: $PROJECT_NAME"
info "GitHub username: $GITHUB_USERNAME"
echo ""

# Check for required tools
command -v sed >/dev/null 2>&1 || error "sed is required but not installed"
command -v find >/dev/null 2>&1 || error "find is required but not installed"

# Detect OS for sed command
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_CMD="sed -i ''"
else
    SED_CMD="sed -i"
fi

# Files to exclude from replacement
EXCLUDE_PATTERNS=".git|node_modules|venv|.venv|__pycache__|.github/ISSUE_TEMPLATE|TEMPLATE_VARIABLES.md|SETUP.md|README.md"

info "Replacing PROJECT_NAME with $PROJECT_NAME..."

# Find and replace PROJECT_NAME in files
find . -type f \
    -not -path "./.git/*" \
    -not -path "./node_modules/*" \
    -not -path "./venv/*" \
    -not -path "./.venv/*" \
    -not -path "./__pycache__/*" \
    -not -name "TEMPLATE_VARIABLES.md" \
    -not -name "SETUP.md" \
    -exec grep -l "PROJECT_NAME" {} \; 2>/dev/null | while read -r file; do
    $SED_CMD "s/PROJECT_NAME/$PROJECT_NAME/g" "$file"
done

success "Replaced PROJECT_NAME in all files"

# Replace GitHub username if different from default
if [ "$GITHUB_USERNAME" != "raolivei" ]; then
    info "Replacing GitHub username with $GITHUB_USERNAME..."
    find . -type f \
        -not -path "./.git/*" \
        -not -path "./node_modules/*" \
        -not -path "./venv/*" \
        -not -path "./.venv/*" \
        -not -path "./__pycache__/*" \
        -exec grep -l "raolivei" {} \; 2>/dev/null | while read -r file; do
        # Skip certain files that should keep examples
        if [[ "$file" == *"TEMPLATE_VARIABLES.md" ]] || [[ "$file" == *"SETUP.md" ]] || [[ "$file" == *"README.md" ]]; then
            continue
        fi
        $SED_CMD "s/raolivei/$GITHUB_USERNAME/g" "$file"
    done
    success "Replaced GitHub username"
fi

# Update setup-branch-protection.sh
if [ -f "github/setup-branch-protection.sh" ]; then
    info "Updating branch protection script..."
    $SED_CMD "s/REPO_NAME=\"PROJECT_NAME\"/REPO_NAME=\"$PROJECT_NAME\"/g" github/setup-branch-protection.sh
    success "Updated branch protection script"
fi

# Initialize VERSION file if it doesn't exist or is empty
if [ ! -f "VERSION" ] || [ ! -s "VERSION" ]; then
    info "Initializing VERSION file..."
    echo "0.1.0" > VERSION
    success "Created VERSION file with 0.1.0"
else
    info "VERSION file already exists: $(cat VERSION)"
fi

# Make scripts executable
info "Making scripts executable..."
find scripts -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find github -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
success "Made scripts executable"

# Verify replacements
info "Verifying replacements..."
REMAINING=$(grep -r "PROJECT_NAME" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=venv --exclude-dir=.venv --exclude-dir=__pycache__ \
    --exclude="TEMPLATE_VARIABLES.md" --exclude="SETUP.md" --exclude="README.md" 2>/dev/null | wc -l | tr -d ' ')

if [ "$REMAINING" -gt 0 ]; then
    warning "Found $REMAINING remaining instances of PROJECT_NAME (may be in documentation examples)"
    echo ""
    echo "Remaining instances:"
    grep -r "PROJECT_NAME" . --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=venv --exclude-dir=.venv --exclude-dir=__pycache__ \
        --exclude="TEMPLATE_VARIABLES.md" --exclude="SETUP.md" --exclude="README.md" 2>/dev/null || true
else
    success "All PROJECT_NAME instances replaced"
fi

echo ""
success "Repository setup complete!"
echo ""
info "Next steps:"
echo "  1. Review and update workflow files in .github/workflows/"
echo "  2. Update image names in build-and-push.yml if needed"
echo "  3. Update workflow paths to match your project structure"
echo "  4. Set up GitHub secrets (CR_PAT)"
echo "  5. Push to GitHub and run: ./github/setup-branch-protection.sh"
echo ""
info "See SETUP.md for detailed instructions"













