#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "ERROR: pass at least one Terraform version."
  exit 1
fi

examples=("examples/simple" "examples/complete" "examples/integration")

for version in "$@"; do
  for ex in "${examples[@]}"; do
    echo "=== Terraform ${version}: ${ex} ==="
    (
      cd "$ex"
      TFENV_TERRAFORM_VERSION="$version" tfenv exec fmt -check -diff
      TFENV_TERRAFORM_VERSION="$version" tfenv exec init -backend=false -input=false
      TFENV_TERRAFORM_VERSION="$version" tfenv exec validate
    )
  done
done
