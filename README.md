# Shopify Reusable Workflows

Centralized GitHub Actions workflows for Shopify stores. Set up CI/CD in any new store repo with one command.

## Setup New Store Repo (3 Steps)

### 1. Navigate to your new store repo
```bash
cd my-new-store
```

### 2. Run one-line setup
```bash
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
```

Replace `your-org-name` with your GitHub organization name.

### 3. Commit and push
```bash
git add .github/
git commit -m "Add Shopify CI/CD workflows"
git push
```

**Done!** Your repo now has automated CI/CD workflows.

---

## What This Does

Creates 3 files in your store repo:
- `.github/workflows/label-sync.yml` - Syncs PR labels
- `.github/workflows/shopify-theme-ci.yml` - Runs checks on PRs
- `.github/labels.yml` - Label configuration

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

---

## Alternative: Makefile Setup

Download Makefile to your store repo:
```bash
curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/templates/Makefile -o Makefile
make setup ORG_NAME=your-org-name
make commit-workflows
git push
```

See [ONE_LINE_SETUP.md](ONE_LINE_SETUP.md) for more options.

---

## Updating Workflows

Update workflows for ALL stores:

1. Edit workflows in this central repo
2. Commit and push
3. All store repos automatically use the updated version

To update a single store:
```bash
cd my-store
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
git add .github/
git commit -m "Update workflows"
git push
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
- Verify `YOUR_ORG` is replaced with actual org name in workflow files

**"ready to main" check failing?**
- Run "Label Management" workflow in Actions tab first
- PM must manually add "ready to main" label to approve PR

**Setup script fails?**
- Verify `ORG_NAME=your-org` is set correctly
- Check central repo is accessible: `https://github.com/your-org/shopify-reusable-workflows`
