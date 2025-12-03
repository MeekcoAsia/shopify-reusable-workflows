# Quick Setup Guide

Use this guide to quickly set up a new Shopify store repository with the centralized workflows.

## Prerequisites

- This repository (`shopify-reusable-workflows`) must be pushed to your GitHub organization
- You have a Shopify store repository ready to configure

## 🚀 Fastest Method: One-Line Setup

```bash
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
```

Then commit and push:
```bash
git add .github/
git commit -m "Add Shopify CI/CD workflows"
git push
```

**Done!** See [ONE_LINE_SETUP.md](ONE_LINE_SETUP.md) for more options.

---

## Alternative: Manual Setup Steps

### 1. In your Shopify store repository

Create these two files in `.github/workflows/`:

#### File 1: `.github/workflows/label-sync.yml`

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

#### File 2: `.github/workflows/shopify-theme-ci.yml`

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
```

**Replace:**
- `YOUR_ORG` with your GitHub organization name

**Note:** Developers should include the Shopify preview theme link in the PR description for PM testing.

### 2. Copy the labels configuration

Copy `templates/labels.yml` from this repo to `.github/labels.yml` in your Shopify repo.

Or run this command from your Shopify repo:

```bash
curl -o .github/labels.yml https://raw.githubusercontent.com/YOUR_ORG/shopify-reusable-workflows/main/templates/labels.yml
```

### 3. Commit and push

```bash
git add .github/
git commit -m "Add centralized GitHub workflows"
git push
```

### 4. Initialize labels

1. Go to Actions tab in your repository
2. Find "Label Management" workflow
3. Click "Run workflow" to sync labels for the first time

## Done!

Your repository is now set up with:
- Auto-labeling PRs based on branch prefix (feature/bug)
- JSON and Liquid validation
- Shopify Theme Check
- PM approval workflow with "ready to test" and "ready to main" labels
- Label management

## Testing

Create a test PR to verify:

```bash
git checkout -b feature/1-test-workflow
# Make a small change
git add .
git commit -m "test: verify workflows"
git push -u origin feature/1-test-workflow
```

Open a PR and check that:
1. PR gets auto-labeled as "feature"
2. Validation and theme-check jobs run
3. PR gets "ready to test" label when checks pass
4. A comment is added with testing instructions

## Next Steps

- Update branch protection rules to require "ready to main" label before merging
- Share this guide with your team
- Test the workflow by creating a PR
