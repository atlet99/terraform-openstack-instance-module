#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "ERROR: pass at least one Terraform version."
  exit 1
fi

examples=()
while IFS= read -r ex; do
  examples+=("$ex")
done < <(find examples -mindepth 1 -maxdepth 1 -type d | sort)

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
