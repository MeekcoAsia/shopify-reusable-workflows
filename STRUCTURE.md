# Repository Structure Guide

## This Repository (Central Workflows)

```
shopify-reusable-workflows/
├── .github/
│   └── workflows/
│       ├── label-sync.yml              # Reusable workflow for label management
│       └── shopify-theme-ci.yml        # Reusable workflow for Shopify CI/CD
│
├── templates/
│   ├── labels.yml                      # Standard labels configuration
│   ├── Makefile                        # Makefile for easy setup
│   └── caller-examples/
│       ├── label-sync-caller.yml       # Example workflow caller
│       └── shopify-theme-ci-caller.yml # Example workflow caller
│
├── .gitignore
├── setup.sh                            # Automated setup script
├── README.md                           # Main documentation
├── QUICK_SETUP.md                      # Quick setup guide for new repos
├── ONE_LINE_SETUP.md                   # One-line setup instructions
└── STRUCTURE.md                        # This file
```

## Individual Shopify Store Repos (After Setup)

```
your-shopify-store-repo/
├── .github/
│   ├── workflows/
│   │   ├── label-sync.yml              # Calls central label-sync workflow
│   │   └── shopify-theme-ci.yml        # Calls central Shopify CI/CD workflow
│   └── labels.yml                      # Labels configuration (copied from template)
│
├── assets/
├── config/
├── layout/
├── locales/
├── sections/
├── snippets/
├── templates/
└── ... (other Shopify theme files)
```

## Key Points

### Central Repository (`shopify-reusable-workflows`)
- Contains the **actual workflow logic**
- Workflows use `workflow_call` trigger
- Updated here, changes propagate to all repos
- Only needs to be set up once

### Individual Store Repos
- Contain **minimal caller workflows** (2 small files)
- Workflows trigger on push/PR events
- Call the centralized workflows using `uses:`
- Each repo specifies its own store name and settings

## Benefits

1. **Single Source of Truth**: Update workflows in one place
2. **Consistency**: All repos use the same CI/CD process
3. **Easy Maintenance**: Fix bugs or add features centrally
4. **Quick Setup**: New repos only need 2 small workflow files
5. **Customizable**: Each repo can pass different inputs

## Workflow Communication Flow

```
Individual Repo Event (push/PR)
          ↓
Caller Workflow (.github/workflows/shopify-theme-ci.yml)
          ↓
Centralized Workflow (YOUR_ORG/shopify-reusable-workflows/.github/workflows/shopify-theme-ci.yml)
          ↓
Execution (validation, checks, labels, comments)
          ↓
Results shown in Individual Repo
```

## Version Management

### Using `@main` (Development)
```yaml
uses: YOUR_ORG/shopify-reusable-workflows/.github/workflows/shopify-theme-ci.yml@main
```
- Always uses the latest version
- Good for development/testing
- Changes take effect immediately

### Using `@v1.0.0` (Production - Recommended)
```yaml
uses: YOUR_ORG/shopify-reusable-workflows/.github/workflows/shopify-theme-ci.yml@v1.0.0
```
- Uses a specific version
- More stable and predictable
- Update version number when ready to upgrade

## Minimum Required Files in Store Repos

To use the centralized workflows, each store repo needs:

1. `.github/workflows/label-sync.yml` (if using label management)
2. `.github/workflows/shopify-theme-ci.yml` (for CI/CD)
3. `.github/labels.yml` (labels configuration)

That's it! Only 3 files totaling ~30 lines of code to get full CI/CD pipeline.
