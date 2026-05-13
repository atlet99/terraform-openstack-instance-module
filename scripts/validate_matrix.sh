#!/usr/bin/env bash
set -euo pipefail

if ! command -v tfenv >/dev/null 2>&1; then
  echo "ERROR: tfenv is required for validate-matrix."
  exit 1
fi

if [[ $# -eq 0 ]]; then
  echo "ERROR: pass at least one Terraform version."
  exit 1
fi

for version in "$@"; do
  echo "=== Terraform ${version}: init+validate ==="
  TFENV_TERRAFORM_VERSION="$version" tfenv exec init -backend=false -input=false
  TFENV_TERRAFORM_VERSION="$version" tfenv exec validate
done
