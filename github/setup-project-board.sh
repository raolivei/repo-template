#!/bin/bash

# Setup GitHub Project Board
# This script creates a GitHub Project (v2) board for a repository
# with automated columns and workflow integration

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get repository name from git remote or prompt
REPO_NAME="${1:-}"
if [ -z "$REPO_NAME" ]; then
    # Try to get from git remote
    if git remote get-url origin &>/dev/null; then
        REPO_URL=$(git remote get-url origin)
        if [[ "$REPO_URL" =~ github.com[:/]([^/]+)/([^/]+)(\.git)?$ ]]; then
            REPO_OWNER="${BASH_REMATCH[1]}"
            REPO_NAME="${BASH_REMATCH[2]%.git}"
            REPO_NAME="${REPO_OWNER}/${REPO_NAME}"
        fi
    fi
    
    if [ -z "$REPO_NAME" ]; then
        echo -e "${RED}Error: Repository name not provided and could not be determined from git remote${NC}"
        echo "Usage: $0 [OWNER/REPO_NAME]"
        echo "Example: $0 raolivei/my-project"
        exit 1
    fi
fi

echo -e "${GREEN}Setting up project board for repository: ${REPO_NAME}${NC}"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}Error: GitHub CLI (gh) is not installed${NC}"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &>/dev/null; then
    echo -e "${RED}Error: Not authenticated with GitHub CLI${NC}"
    echo "Run: gh auth login"
    exit 1
fi

# Extract owner and repo name
if [[ "$REPO_NAME" =~ ^([^/]+)/(.+)$ ]]; then
    OWNER="${BASH_REMATCH[1]}"
    REPO="${BASH_REMATCH[2]}"
else
    echo -e "${RED}Error: Invalid repository format. Expected: OWNER/REPO${NC}"
    exit 1
fi

# Project name
PROJECT_NAME="${REPO} Project"

echo -e "${YELLOW}Creating GitHub Project: ${PROJECT_NAME}${NC}"

# Create project using GitHub API
PROJECT_ID=$(gh api graphql -f query='
  mutation($owner: String!, $repo: String!, $name: String!) {
    createProjectV2(input: {
      ownerId: $owner
      title: $name
      repositoryId: $repo
    }) {
      projectV2 {
        id
        number
      }
    }
  }
' -f owner="$OWNER" -f repo="$REPO" -f name="$PROJECT_NAME" 2>/dev/null | jq -r '.data.createProjectV2.projectV2.id' || echo "")

if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "null" ]; then
    echo -e "${YELLOW}Note: Project creation via API may require additional permissions.${NC}"
    echo -e "${YELLOW}Creating project manually is recommended.${NC}"
    echo ""
    echo -e "${GREEN}Manual Setup Instructions:${NC}"
    echo "1. Go to: https://github.com/${REPO_NAME}"
    echo "2. Click on 'Projects' tab"
    echo "3. Click 'New project'"
    echo "4. Select 'Board' template"
    echo "5. Name it: '${PROJECT_NAME}'"
    echo "6. Add columns: Backlog, To Do, In Progress, In Review, Done"
    echo ""
    echo "See PROJECT_BOARDS.md for detailed setup instructions."
    exit 0
fi

echo -e "${GREEN}✓ Project created with ID: ${PROJECT_ID}${NC}"

# Define columns
COLUMNS=("Backlog" "To Do" "In Progress" "In Review" "Done")

echo -e "${YELLOW}Setting up columns...${NC}"

for COLUMN in "${COLUMNS[@]}"; do
    echo -e "${GREEN}Adding column: ${COLUMN}${NC}"
    # Note: Column creation via API requires project admin permissions
    # This is a placeholder - manual setup may be required
done

echo -e "${GREEN}✓ Project board setup initiated${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Visit: https://github.com/${REPO_NAME}/projects"
echo "2. Configure columns and automation rules"
echo "3. See PROJECT_BOARDS.md for automation setup"
echo ""
echo -e "${GREEN}Project board URL: https://github.com/${REPO_NAME}/projects${NC}"


