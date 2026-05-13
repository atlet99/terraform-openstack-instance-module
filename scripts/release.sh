#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
version_input="${2:-}"
next_version="${3:-v1.0.1}"
current_version="${4:-0.0.0}"

if [[ -z "$mode" ]]; then
  echo "ERROR: mode is required (release|tag)."
  exit 1
fi

version="$version_input"
if [[ -z "$version" ]]; then
  version="$next_version"
fi
version="${version#v}"

if [[ "$mode" == "release" ]]; then
  echo "Releasing v${version} (current: v${current_version})..."
else
  echo "Creating tag v${version} (current: v${current_version})..."
fi

sed -i.bak -e "s/version = \".*\"/version = \"${version}\"/g" README.md
rm -f README.md.bak

git cliff --bump --tag "v${version}" -o CHANGELOG.md
git add CHANGELOG.md README.md
git commit -m "chore: release v${version}"
git tag -a "v${version}" -m "Release v${version}"

if [[ "$mode" == "release" ]]; then
  echo "Done. Run 'git push && git push --tags' to publish."
else
  echo "Tag v${version} created. Run 'git push && git push --tags' to publish."
fi
