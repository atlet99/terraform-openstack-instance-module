.PHONY: help check-deps clean \
	fmt fmt-check \
	init validate lint docs \
	check-all check-all-single check-all-matrix validate-matrix \
	changelog changelog-preview release tag

SHELL := /bin/bash
.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# Project metadata
# -----------------------------------------------------------------------------
CURRENT_VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
NEXT_VERSION := $(shell git cliff --bumped-version 2>/dev/null || echo "v1.0.1")
REPO_URL := https://github.com/atlet99/terraform-openstack-instance-module

# -----------------------------------------------------------------------------
# Tooling
# -----------------------------------------------------------------------------
REQUIRED_BINS := terraform tflint terraform-docs git git-cliff tfenv
TERRAFORM := $(shell if command -v tfenv >/dev/null 2>&1; then echo "tfenv exec"; else echo "terraform"; fi)

# Compatibility matrix for validation checks
TF_MATRIX_VERSIONS ?= 1.5.0 1.5.7 1.11.0

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

check-deps: ## Check that all required tools are installed
	@for bin in $(REQUIRED_BINS); do \
		if ! command -v $$bin &>/dev/null; then \
			echo "ERROR: '$$bin' is not installed."; \
			case $$bin in \
				terraform)      echo "  Install: https://developer.hashicorp.com/terraform/install" ;; \
				tflint)         echo "  Install: brew install tflint" ;; \
				terraform-docs) echo "  Install: brew install terraform-docs" ;; \
				git)            echo "  Install: brew install git" ;; \
			esac; \
			exit 1; \
		fi; \
	done
	@echo "All dependencies are available."

# -----------------------------------------------------------------------------
# Terraform core
# -----------------------------------------------------------------------------
fmt: check-deps ## Run terraform fmt recursively
	$(TERRAFORM) fmt -recursive

fmt-check: check-deps ## Check terraform formatting (fails on diff)
	$(TERRAFORM) fmt -recursive -check -diff

init: check-deps ## Initialize terraform (no backend)
	$(TERRAFORM) init -backend=false -input=false

validate: init ## Run terraform validate
	$(TERRAFORM) validate

validate-matrix: check-deps ## Run init+validate across Terraform matrix versions
	@set -euo pipefail; \
	for v in $(TF_MATRIX_VERSIONS); do \
		echo "=== Terraform $$v: init+validate ==="; \
		TFENV_TERRAFORM_VERSION=$$v tfenv exec init -backend=false -input=false; \
		TFENV_TERRAFORM_VERSION=$$v tfenv exec validate; \
	done

# -----------------------------------------------------------------------------
# Linting & docs
# -----------------------------------------------------------------------------
lint: check-deps ## Run tflint
	tflint --init
	tflint

docs: check-deps ## Generate documentation with terraform-docs
	terraform-docs .

# -----------------------------------------------------------------------------
# Aggregate checks
# -----------------------------------------------------------------------------
check-all-single: fmt validate lint docs ## Run checks using active Terraform version

check-all-matrix: fmt validate-matrix lint docs ## Run checks across Terraform version matrix

check-all: check-all-matrix ## Default full check suite (matrix)

# -----------------------------------------------------------------------------
# Release workflow
# -----------------------------------------------------------------------------
changelog: check-deps ## Generate CHANGELOG.md from git commits
	@echo "Generating CHANGELOG.md with git-cliff..."
	@git cliff -o CHANGELOG.md
	@echo "Done. Review CHANGELOG.md and commit."

changelog-preview: check-deps ## Preview next version and unreleased changes
	@echo "Next version: $(NEXT_VERSION)"
	@echo "Unreleased changes:"
	@git cliff --unreleased --strip all

release: check-deps ## Create a release: make release [VERSION=x.y.z]
	@version="$(VERSION)"; \
	if [ -z "$$version" ]; then version="$(NEXT_VERSION)"; fi; \
	version=$${version#v}; \
	echo "Releasing v$$version (current: v$(CURRENT_VERSION))..."; \
	sed -i.bak -e "s/version = \".*\"/version = \"$$version\"/g" README.md; \
	rm -f README.md.bak; \
	git cliff --bump --tag "v$$version" -o CHANGELOG.md; \
	git add CHANGELOG.md README.md; \
	git commit -m "chore: release v$$version"; \
	git tag -a "v$$version" -m "Release v$$version"; \
	echo "Done. Run 'git push && git push --tags' to publish."

tag: check-deps ## Create a tag with CHANGELOG update: make tag [VERSION=x.y.z]
	@version="$(VERSION)"; \
	if [ -z "$$version" ]; then version="$(NEXT_VERSION)"; fi; \
	version=$${version#v}; \
	echo "Creating tag v$$version (current: v$(CURRENT_VERSION))..."; \
	sed -i.bak -e "s/version = \".*\"/version = \"$$version\"/g" README.md; \
	rm -f README.md.bak; \
	git cliff --bump --tag "v$$version" -o CHANGELOG.md; \
	git add CHANGELOG.md README.md; \
	git commit -m "chore: release v$$version"; \
	git tag -a "v$$version" -m "Release v$$version"; \
	echo "Tag v$$version created. Run 'git push && git push --tags' to publish."

# -----------------------------------------------------------------------------
# Cleanup
# -----------------------------------------------------------------------------
clean: ## Remove terraform artifacts
	rm -rf .terraform .terraform.lock.hcl
