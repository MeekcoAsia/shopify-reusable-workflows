# One-Line Setup

Set up a new Shopify store repository with CI/CD workflows in one command!

## Option 1: Using curl (Fastest)

```bash
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
```

Replace `your-org-name` with your GitHub organization name.

## Option 2: Using Makefile (Most Flexible)

### First-time setup:

1. Download the Makefile to your Shopify repo:
```bash
curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/templates/Makefile -o Makefile
```

2. Edit the Makefile and replace `YOUR_ORG` with your organization name, or:
```bash
make setup ORG_NAME=your-org-name
```

### After Makefile is set up:

```bash
make setup              # Download all workflow files
make commit-workflows   # Commit and stage for push
git push               # Push to GitHub
```

## What Gets Installed?

Both methods create:
- `.github/workflows/label-sync.yml` - Label management workflow
- `.github/workflows/shopify-theme-ci.yml` - Shopify CI/CD workflow
- `.github/labels.yml` - Label configuration

## After Setup

1. Push the files to GitHub:
   ```bash
   git add .github/
   git commit -m "Add Shopify CI/CD workflows"
   git push
   ```

2. Go to Actions tab in your repo and run "Label Management" workflow to sync labels

3. Create a test PR:
   ```bash
   git checkout -b feature/1-test-workflow
   # Make a small change
   git add .
   git commit -m "test: verify workflows"
   git push -u origin feature/1-test-workflow
   ```

## Makefile Commands

Once you have the Makefile in your repo:

```bash
make help               # Show all available commands
make setup              # Initial setup
make update             # Update workflows to latest version
make clean              # Remove all workflow files
make commit-workflows   # Stage files for commit
```

## Updating Existing Repos

To update workflows to the latest version:

### Using curl:
```bash
ORG_NAME=your-org-name curl -sSL https://raw.githubusercontent.com/your-org-name/shopify-reusable-workflows/main/setup.sh | bash
```

### Using Makefile:
```bash
make update
```

## Example: Complete Setup

```bash
# Navigate to your Shopify store repo
cd my-shopify-store

# One-line setup
ORG_NAME=mycompany curl -sSL https://raw.githubusercontent.com/mycompany/shopify-reusable-workflows/main/setup.sh | bash

# Commit and push
git add .github/
git commit -m "Add Shopify CI/CD workflows"
git push

# Done! 🎉
```

## Troubleshooting

### "ORG_NAME is not set"
Make sure to set the `ORG_NAME` environment variable:
```bash
ORG_NAME=your-org-name curl -sSL https://...
```

### "Failed to download"
- Check that the central repository is accessible
- Verify the organization name is correct
- Ensure the repository name is `shopify-reusable-workflows`

### Permission denied
Make the script executable if downloading manually:
```bash
chmod +x setup.sh
./setup.sh
```
