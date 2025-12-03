# Shopify Reusable Workflows

Centralized GitHub Actions workflows for Shopify stores. Set up CI/CD in any new store repo with two commands.

## Setup New Store Repo (2 Steps)

### 1. Get the Makefile
```bash
cd my-new-store
curl -sSL https://raw.githubusercontent.com/MeekcoAsia/shopify-reusable-workflows/main/templates/Makefile -o Makefile
```

### 2. Run setup
```bash
make setup
make commit-workflows
git push
```

That's it! The setup script will prompt you for the organization name and auto-detect your default branch.

---

## What Gets Installed

Creates 4 files in your store repo:
- `.github/workflows/label-sync.yml` - Syncs PR labels
- `.github/workflows/shopify-theme-ci.yml` - Runs checks on PRs
- `.github/labels.yml` - Label configuration
- `.theme-check.yml` - Theme Check configuration (disables noisy checks for Dawn theme)

**Works with any default branch name** - automatically detects main, master, develop, or custom branch names.

### PR Workflow

1. Dev creates PR from `feature/123-description` or `fix/456-bug`
2. Workflow automatically:
   - Labels PR as "feature" or "bug"
   - Validates JSON and Liquid files
   - Runs Shopify Theme Check
   - Adds "ready to test" label
3. PM tests on preview theme, adds "ready to main" label to approve
4. Merge to main deploys to production

### Branch Naming

Use these branch prefixes for auto-labeling:
- `feature/` or `feat/` → "feature" label
- `fix/` or `hotfix/` → "bug" label

**Examples:**
- `feature/45-add-hero` → labeled "feature"
- `fix/67-checkout-bug` → labeled "bug"


## Updating Workflows

Update workflows for ALL stores:

1. Edit workflows in this central repo
2. Commit and push
3. All store repos automatically use the updated version

To update a single store:
```bash
cd my-store
curl -sSL https://raw.githubusercontent.com/MeekcoAsia/shopify-reusable-workflows/main/setup.sh | bash
git add .github/ .theme-check.yml
git commit -m "Update workflows"
git push
```

Or skip prompts by setting environment variables:
```bash
export ORG_NAME=MeekcoAsia
curl -sSL https://raw.githubusercontent.com/MeekcoAsia/shopify-reusable-workflows/main/setup.sh | bash
```

---

## Labels

Default labels created in each store:
- `ready to test` - Dev completed, ready for PM testing
- `ready to main` - PM approved, ready to merge (required)
- `feature` - Auto-applied to feature branches
- `bug` - Auto-applied to fix branches

Run "Label Management" workflow in Actions tab to sync labels after setup.

---

## Troubleshooting

**Workflows not running?**
- Check `.github/workflows/` files are pushed to your store repo
- Verify `MeekcoAsia` is set correctly in workflow files

**"ready to main" check failing?**
- Run "Label Management" workflow in Actions tab first
- PM must manually add "ready to main" label to approve PR

**Setup script fails?**
- Ensure you entered the correct organization name when prompted
- Check central repo is accessible: `https://github.com/MeekcoAsia/shopify-reusable-workflows`
- If running non-interactively, set `ORG_NAME` environment variable
