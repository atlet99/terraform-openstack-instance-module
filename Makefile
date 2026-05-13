.PHONY: \
	help check-deps clean \
	fmt fmt-check init validate validate-matrix check-examples \
	lint docs \
	check-all-single check-all-matrix check-all \
	changelog changelog-preview release tag

SHELL := /bin/bash
.DEFAULT_GOAL := help

# -----------------------------------------------------------------------------
# Metadata
# -----------------------------------------------------------------------------
CURRENT_VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
NEXT_VERSION := $(shell git cliff --bumped-version 2>/dev/null || echo "v1.0.1")

# -----------------------------------------------------------------------------
# Tooling
# -----------------------------------------------------------------------------
TERRAFORM := $(shell if command -v tfenv >/dev/null 2>&1; then echo "tfenv exec"; else echo "terraform"; fi)
TF_MATRIX_VERSIONS ?= 1.5.0 1.5.7 1.11.0

# -----------------------------------------------------------------------------
# Help
# -----------------------------------------------------------------------------
help: ## Show grouped help
	@echo "Usage: make <target>"
	@echo
	@echo "Terraform"
	@echo "  fmt                Run terraform fmt recursively"
	@echo "  fmt-check          Check terraform formatting (fails on diff)"
	@echo "  init               Initialize terraform (no backend)"
	@echo "  validate           Run terraform validate"
	@echo "  validate-matrix    Run init+validate across TF versions: $(TF_MATRIX_VERSIONS)"
	@echo "  check-examples     Validate examples across TF versions: $(TF_MATRIX_VERSIONS)"
	@echo
	@echo "Quality"
	@echo "  lint               Run tflint"
	@echo "  docs               Generate README docs with terraform-docs"
	@echo "  check-all-single   Run checks in active Terraform version"
	@echo "  check-all-matrix   Run checks across Terraform version matrix"
	@echo "  check-all          Alias for check-all-matrix"
	@echo
	@echo "Release"
	@echo "  changelog          Generate CHANGELOG.md from git history"
	@echo "  changelog-preview  Preview next version and unreleased changes"
	@echo "  release            Create release commit + tag (VERSION=x.y.z optional)"
	@echo "  tag                Create tag workflow commit + tag (VERSION=x.y.z optional)"
	@echo
	@echo "Maintenance"
	@echo "  check-deps         Verify required tools are installed"
	@echo "  clean              Remove terraform artifacts"

# -----------------------------------------------------------------------------
# Maintenance
# -----------------------------------------------------------------------------
check-deps: ## Verify required tools are installed
	@./scripts/check_deps.sh

clean: ## Remove terraform artifacts
	rm -rf .terraform .terraform.lock.hcl

# -----------------------------------------------------------------------------
# Terraform
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
	@./scripts/validate_matrix.sh $(TF_MATRIX_VERSIONS)

check-examples: check-deps ## Validate examples across Terraform matrix versions
	@./scripts/check_examples.sh $(TF_MATRIX_VERSIONS)

# -----------------------------------------------------------------------------
# Quality
# -----------------------------------------------------------------------------
lint: check-deps ## Run tflint
	tflint --init
	tflint

docs: check-deps ## Generate documentation with terraform-docs
	terraform-docs .

check-all-single: fmt validate lint docs ## Run checks in active Terraform version

check-all-matrix: fmt validate-matrix check-examples lint docs ## Run checks across Terraform matrix

check-all: check-all-matrix ## Alias for check-all-matrix

# -----------------------------------------------------------------------------
# Release
# -----------------------------------------------------------------------------
changelog: check-deps ## Generate CHANGELOG.md from git commits
	@echo "Generating CHANGELOG.md with git-cliff..."
	@git cliff -o CHANGELOG.md
	@echo "Done. Review CHANGELOG.md and commit."

changelog-preview: check-deps ## Preview next version and unreleased changes
	@echo "Next version: $(NEXT_VERSION)"
	@echo "Unreleased changes:"
	@git cliff --unreleased --strip all

release: check-deps ## Create release commit + tag (VERSION=x.y.z optional)
	@./scripts/release.sh release "$(VERSION)" "$(NEXT_VERSION)" "$(CURRENT_VERSION)"

tag: check-deps ## Create tag workflow commit + tag (VERSION=x.y.z optional)
	@./scripts/release.sh tag "$(VERSION)" "$(NEXT_VERSION)" "$(CURRENT_VERSION)"
