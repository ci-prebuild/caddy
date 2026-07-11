#! /usr/bin/env bash

set -euo pipefail

if ! test -z "$(git status --porcelain)"; then
  echo "Please commit everything first"
  exit 1
fi

date="$(date +'%Y.%m.%d')-1"
sed -i "s/PKG_VERSION: \".*\"/PKG_VERSION: \"$date\"/" .github/workflows/release.yml
git add .github/workflows/release.yml

releaseMsg="release: $date"
prevMsg="$(git log -1 --pretty=%B)"
if [[ "$prevMsg" = "$releaseMsg" ]]; then
  git commit --amend -m "$releaseMsg"
else
  git commit -m "$releaseMsg" --allow-empty
fi

git push --force
git tag "$date" --force
git push --tags --force
