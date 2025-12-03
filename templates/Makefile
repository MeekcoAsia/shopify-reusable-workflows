# Shopify CI/CD Makefile

ORG_NAME ?= MeekcoAsia
REPO_NAME ?= shopify-reusable-workflows
BRANCH ?= main

.PHONY: help setup setup-workflows setup-labels commit-workflows clean

help: ## Show this help message
	@echo "Shopify CI/CD Workflow Management"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Usage:"
	@echo "  make setup              # Initial setup (downloads all files)"
	@echo "  make commit-workflows   # Commit and push workflow files"
	@echo "  make clean              # Remove workflow files"

setup: ## Set up GitHub Actions workflows (complete setup)
	@echo "Downloading setup script..."
	@curl -sSL "https://raw.githubusercontent.com/$(ORG_NAME)/$(REPO_NAME)/$(BRANCH)/setup.sh" -o .setup-temp.sh
	@chmod +x .setup-temp.sh
	@echo ""
	@ORG_NAME=$(ORG_NAME) ./.setup-temp.sh
	@rm -f .setup-temp.sh
	@echo ""
	@echo "Next: Run 'make commit-workflows' to commit these files"

setup-workflows: ## Download only workflow files (without labels)
	@echo "Downloading workflow files..."
	@mkdir -p .github/workflows
	@curl -sSL "https://raw.githubusercontent.com/$(ORG_NAME)/$(REPO_NAME)/$(BRANCH)/templates/caller-examples/label-sync-caller.yml" -o .github/workflows/label-sync.yml
	@curl -sSL "https://raw.githubusercontent.com/$(ORG_NAME)/$(REPO_NAME)/$(BRANCH)/templates/caller-examples/shopify-theme-ci-caller.yml" -o .github/workflows/shopify-theme-ci.yml
	@if [ "$$(uname)" = "Darwin" ]; then \
		sed -i '' "s/YOUR_ORG/$(ORG_NAME)/g" .github/workflows/*.yml; \
	else \
		sed -i "s/YOUR_ORG/$(ORG_NAME)/g" .github/workflows/*.yml; \
	fi
	@echo "✓ Workflows downloaded"

setup-labels: ## Download only labels configuration
	@echo "Downloading labels configuration..."
	@mkdir -p .github
	@curl -sSL "https://raw.githubusercontent.com/$(ORG_NAME)/$(REPO_NAME)/$(BRANCH)/templates/labels.yml" -o .github/labels.yml
	@echo "✓ Labels configuration downloaded"

commit-workflows: ## Commit and push workflow files
	@echo "Committing workflow files..."
	@git add .github/ .theme-check.yml
	@git commit -m "Add Shopify CI/CD workflows" || echo "No changes to commit"
	@echo ""
	@echo "Ready to push! Run:"
	@echo "  git push"

clean: ## Remove workflow files
	@echo "Removing workflow files..."
	@rm -rf .github/workflows/label-sync.yml
	@rm -rf .github/workflows/shopify-theme-ci.yml
	@rm -rf .github/labels.yml
	@rm -rf .theme-check.yml
	@echo "✓ Cleaned up"

update: ## Update workflows to latest version
	@echo "Updating workflows to latest version..."
	@$(MAKE) setup-workflows
	@echo "✓ Workflows updated!"
	@echo "Review changes and commit if needed"
