#!/bin/bash

# Shopify CI/CD Setup Script
# This script sets up GitHub Actions workflows for a new Shopify store repository

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="${REPO_NAME:-shopify-reusable-workflows}"
ORG_NAME="${ORG_NAME}"
BRANCH="${BRANCH:-main}"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Shopify CI/CD Workflow Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Prompt for ORG_NAME if not set
if [ -z "$ORG_NAME" ]; then
    read -p "Enter your GitHub organization name (e.g., MeekcoAsia): " ORG_NAME
    if [ -z "$ORG_NAME" ]; then
        echo -e "${RED}Error: Organization name is required${NC}"
        exit 1
    fi
fi

# Detect default branch of current repo
DETECTED_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$DETECTED_BRANCH" ]; then
    # Fallback: try to get current branch
    DETECTED_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
fi

# Prompt for default branch confirmation
echo -e "${BLUE}Detected default branch: ${GREEN}${DETECTED_BRANCH}${NC}"
read -p "Press Enter to use '${DETECTED_BRANCH}' or type a different branch name: " BRANCH_INPUT
DEFAULT_BRANCH=${BRANCH_INPUT:-$DETECTED_BRANCH}

BASE_URL="https://raw.githubusercontent.com/${ORG_NAME}/${REPO_NAME}/${BRANCH}"

echo ""
echo -e "${BLUE}Configuration:${NC}"
echo -e "  Organization: ${GREEN}${ORG_NAME}${NC}"
echo -e "  Repository: ${GREEN}${REPO_NAME}${NC}"
echo -e "  Default Branch: ${GREEN}${DEFAULT_BRANCH}${NC}"
echo ""

# Create directories
echo -e "${YELLOW}[1/5]${NC} Creating directories..."
mkdir -p .github/workflows
echo -e "${GREEN}✓${NC} Created .github/workflows/"

# Download label-sync workflow
echo -e "${YELLOW}[2/5]${NC} Downloading label-sync workflow..."
if curl -sSL "${BASE_URL}/templates/caller-examples/label-sync-caller.yml" -o .github/workflows/label-sync.yml; then
    # Replace YOUR_ORG with actual org name and main with default branch
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/YOUR_ORG/${ORG_NAME}/g" .github/workflows/label-sync.yml
        sed -i '' "s/- main/- ${DEFAULT_BRANCH}/g" .github/workflows/label-sync.yml
    else
        sed -i "s/YOUR_ORG/${ORG_NAME}/g" .github/workflows/label-sync.yml
        sed -i "s/- main/- ${DEFAULT_BRANCH}/g" .github/workflows/label-sync.yml
    fi
    echo -e "${GREEN}✓${NC} Downloaded .github/workflows/label-sync.yml"
else
    echo -e "${RED}✗${NC} Failed to download label-sync workflow"
    exit 1
fi

# Download shopify-theme-ci workflow
echo -e "${YELLOW}[3/5]${NC} Downloading shopify-theme-ci workflow..."
if curl -sSL "${BASE_URL}/templates/caller-examples/shopify-theme-ci-caller.yml" -o .github/workflows/shopify-theme-ci.yml; then
    # Replace YOUR_ORG with actual org name and main with default branch
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/YOUR_ORG/${ORG_NAME}/g" .github/workflows/shopify-theme-ci.yml
        sed -i '' "s/- main/- ${DEFAULT_BRANCH}/g" .github/workflows/shopify-theme-ci.yml
    else
        sed -i "s/YOUR_ORG/${ORG_NAME}/g" .github/workflows/shopify-theme-ci.yml
        sed -i "s/- main/- ${DEFAULT_BRANCH}/g" .github/workflows/shopify-theme-ci.yml
    fi
    echo -e "${GREEN}✓${NC} Downloaded .github/workflows/shopify-theme-ci.yml"
else
    echo -e "${RED}✗${NC} Failed to download shopify-theme-ci workflow"
    exit 1
fi

# Download labels.yml
echo -e "${YELLOW}[4/5]${NC} Downloading labels configuration..."
if curl -sSL "${BASE_URL}/templates/labels.yml" -o .github/labels.yml; then
    echo -e "${GREEN}✓${NC} Downloaded .github/labels.yml"
else
    echo -e "${RED}✗${NC} Failed to download labels configuration"
    exit 1
fi

# Download .theme-check.yml
echo -e "${YELLOW}[5/5]${NC} Downloading theme-check configuration..."
if curl -sSL "${BASE_URL}/templates/.theme-check.yml" -o .theme-check.yml; then
    echo -e "${GREEN}✓${NC} Downloaded .theme-check.yml"
else
    echo -e "${RED}✗${NC} Failed to download theme-check configuration"
    exit 1
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Complete! 🎉${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Files created:"
echo -e "  ${BLUE}●${NC} .github/workflows/label-sync.yml"
echo -e "  ${BLUE}●${NC} .github/workflows/shopify-theme-ci.yml"
echo -e "  ${BLUE}●${NC} .github/labels.yml"
echo -e "  ${BLUE}●${NC} .theme-check.yml"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Review the generated files"
echo -e "  2. Commit and push to your repository:"
echo -e "     ${BLUE}git add .github/ .theme-check.yml${NC}"
echo -e "     ${BLUE}git commit -m \"Add Shopify CI/CD workflows\"${NC}"
echo -e "     ${BLUE}git push${NC}"
echo -e "  3. Go to Actions tab and run 'Label Management' workflow to sync labels"
echo -e "  4. Create a test PR to verify the workflows"
echo ""
echo -e "${GREEN}Done!${NC}"
