# Shopify Reusable Workflows

Centralized GitHub Actions workflows for Shopify theme development across your organization.

## Overview

This repository contains reusable GitHub Actions workflows that can be used across all your Shopify store repositories. Instead of copying and pasting workflows to each repo, you simply reference these centralized workflows.

## Available Workflows

### 1. Label Sync Workflow
Automatically syncs GitHub labels from a configuration file to your repository.

The default configuration includes 4 labels:
- **ready to test**: Dev has completed work and deployed to preview
- **ready to main**: PM has tested and approved - ready to merge
- **feature**: Auto-applied to PRs from `feature/` or `feat/` branches
- **bug**: Auto-applied to PRs from `fix/` or `hotfix/` branches

**Location:** `.github/workflows/label-sync.yml`

### 2. Shopify Theme CI/CD Workflow
Comprehensive CI/CD pipeline for Shopify theme development including:
- Auto-labeling PRs based on branch prefix (feature/bug)
- JSON validation
- Liquid syntax checking
- Shopify Theme Check
- PM approval workflow with "ready to test" and "ready to main" labels
- Automated PR comments with testing instructions

**Location:** `.github/workflows/shopify-theme-ci.yml`

## Quick Start (For New Repos)

### Option 1: One-Line Setup (Fastest) ⚡

In your Shopify store repository, run:

```bash
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
```

This automatically creates all necessary workflow files. Then just commit and push!

### Option 2: Using Makefile (Recommended) 📦

1. Download the Makefile:
```bash
curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/templates/Makefile -o Makefile
```

2. Run setup:
```bash
make setup ORG_NAME=your-org-name
make commit-workflows
git push
```

See [ONE_LINE_SETUP.md](ONE_LINE_SETUP.md) for detailed instructions.

---

## Detailed Setup Instructions

### Step 1: Push This Repository to GitHub

1. Create a new repository in your GitHub organization (e.g., `your-org/shopify-reusable-workflows`)
2. Push this folder to that repository:

```bash
cd shopify-reusable-workflows
git init
git add .
git commit -m "Initial commit: Add centralized Shopify workflows"
git remote add origin git@github.com:YOUR_ORG/shopify-reusable-workflows.git
git branch -M main
git push -u origin main
```

### Step 2: Set Up Individual Shopify Repos

For each Shopify store repository, follow these steps:

#### A. Copy the labels configuration

1. Copy the labels template to your repo:
```bash
cp templates/labels.yml .github/labels.yml
```

2. Customize if needed for your specific repo

#### B. Create the label sync workflow

Create `.github/workflows/label-sync.yml` in your Shopify repo:

```yaml
name: Label Management

on:
  push:
    branches:
      - main
    paths:
      - '.github/labels.yml'
  workflow_dispatch:

jobs:
  sync-labels:
    uses: YOUR_ORG/shopify-reusable-workflows/.github/workflows/label-sync.yml@main
```

#### C. Create the Shopify CI/CD workflow

Create `.github/workflows/shopify-theme-ci.yml` in your Shopify repo:

```yaml
name: Shopify Theme CI/CD

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
    types: [opened, synchronize, reopened, labeled, unlabeled]

permissions:
  contents: read
  issues: write
  pull-requests: write

jobs:
  shopify-ci:
    uses: YOUR_ORG/shopify-reusable-workflows/.github/workflows/shopify-theme-ci.yml@main
    # Optional: Customize versions and features
    # with:
    #   node-version: '20'
    #   ruby-version: '3.1'
```

That's it! No additional setup or variables required.

**Note:** Developers should include the Shopify preview theme link in their PR description for PM testing.

## Workflow Configuration Options

### Label Sync Workflow

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `config-file` | Path to labels config file | No | `.github/labels.yml` |
| `delete-other-labels` | Delete labels not in config | No | `false` |

### Shopify Theme CI/CD Workflow

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `node-version` | Node.js version | No | `20` |
| `ruby-version` | Ruby version for theme-check | No | `3.1` |
| `run-theme-check` | Enable Shopify Theme Check | No | `true` |
| `run-validation` | Enable file validation | No | `true` |

## How It Works

### PR Workflow

1. Developer creates a PR from a branch (e.g., `feature/123-new-component` or `fix/456-bug-fix`)
2. Workflow automatically:
   - Labels the PR based on branch prefix (`feature/`, `feat/` → "feature" | `fix/`, `hotfix/` → "bug")
   - Validates JSON files
   - Checks Liquid syntax
   - Runs Shopify Theme Check
   - Adds "ready to test" label when checks pass
   - Comments with testing instructions
3. PM tests the preview theme and adds "ready to main" label when approved
4. The "ready to main" label is required before the PR can be merged

### Label Sync Workflow

- Runs automatically when you push changes to `.github/labels.yml`
- Can also be triggered manually via workflow_dispatch
- Syncs all labels to match your configuration

## Branch Naming Convention

For automatic labeling to work, follow this branch naming format:

- `feature/123-description` or `feat/123-description` → Gets "feature" label
- `fix/123-description` or `hotfix/123-description` → Gets "bug" label

**Examples:**
- `feature/45-add-new-hero-section` → labeled "feature"
- `fix/67-checkout-button-issue` → labeled "bug"
- `hotfix/89-urgent-cart-fix` → labeled "bug"

## Updating Workflows

When you need to update workflows for all repos:

1. Make changes to this central repository
2. Commit and push changes
3. All repos using these workflows will automatically use the updated version

### Using Version Tags (Recommended for Production)

For better control, use version tags instead of `@main`:

```yaml
uses: YOUR_ORG/shopify-reusable-workflows/.github/workflows/shopify-theme-ci.yml@v1.0.0
```

Then update individual repos when ready:
```bash
# In central repo
git tag v1.0.0
git push origin v1.0.0
```

## File Structure

```
shopify-reusable-workflows/
├── .github/
│   └── workflows/
│       ├── label-sync.yml              # Reusable label sync workflow
│       └── shopify-theme-ci.yml        # Reusable Shopify CI/CD workflow
├── templates/
│   ├── labels.yml                      # Template labels configuration
│   └── caller-examples/
│       ├── label-sync-caller.yml       # Example: How to call label-sync
│       └── shopify-theme-ci-caller.yml # Example: How to call Shopify CI/CD
└── README.md                           # This file
```

## Troubleshooting

### Workflows not appearing in my repo

- Make sure you've pushed the caller workflow files to `.github/workflows/` in your repo
- Check that the repository reference is correct (`YOUR_ORG/shopify-reusable-workflows`)
- Ensure the central repository is accessible to the calling repository

### "ready to main" check failing

- Make sure the labels exist in your repository (run the label-sync workflow first)
- PM needs to manually add the "ready to main" label to approve the PR

### Store name not showing in PR comments

- Verify you've set the `shopify-store-name` input in your caller workflow
- Check that the store name is correct (without .myshopify.com)

## Contributing

To add or modify workflows:

1. Make changes to the workflows in this repository
2. Test in a single repo first
3. Once confirmed working, all repos will automatically use the updated workflow
4. Consider using version tags for production environments

## License

Internal use only for your organization.
