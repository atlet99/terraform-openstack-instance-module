#!/usr/bin/env bash
set -euo pipefail

required_bins=(terraform tflint terraform-docs git git-cliff tfenv)

for bin in "${required_bins[@]}"; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "ERROR: '$bin' is not installed."
    case "$bin" in
      terraform) echo "  Install: https://developer.hashicorp.com/terraform/install" ;;
      tflint) echo "  Install: brew install tflint" ;;
      terraform-docs) echo "  Install: brew install terraform-docs" ;;
      git) echo "  Install: brew install git" ;;
    esac
    exit 1
  fi
done

echo "All dependencies are available."
